# Quartz Solar Forecast - Architecture Documentation

## System Overview

Quartz Solar Forecast is a modular, production-ready system for accurate solar irradiance and photovoltaic (PV) power predictions. The architecture follows a layered design pattern:

```
┌─────────────────────────────────────────────────────────┐
│              Web Dashboard (React/TypeScript)            │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│         FastAPI Backend (REST Endpoints)                 │
│  - /forecast, /health, /sites, /predictions endpoints   │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│      Core Quartz Package (Python)                        │
│  - Data pipeline, feature engineering, model inference   │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│   External Data Sources                                  │
│  - GFS, ICON, Open-Meteo NWP APIs                       │
│  - Historical solar/weather datasets                     │
└─────────────────────────────────────────────────────────┘
```

---

## Directory Structure

### Root-Level Organization

```
open-source-quartz-solar-forecast/
├── quartz_solar_forecast/          # Main Python package
├── api/                            # FastAPI application
├── dashboards/                     # Web UI (React/TypeScript)
├── examples/                       # Jupyter notebooks & demos
├── scripts/                        # Utility scripts
├── tests/                          # Test suite (pytest)
├── docs/                           # Documentation files
├── requirements.txt                # Python dependencies
├── setup.py                        # Package configuration
├── Dockerfile                      # Container configuration
├── .github/workflows/              # CI/CD workflows
└── README.md                       # Project overview
```

---

## Core Package: quartz_solar_forecast/

The main package encapsulates all forecasting logic and can be imported as a library.

### Submodule Structure

```
quartz_solar_forecast/
├── __init__.py                     # Main exports (run_forecast)
├── pv_sites.py                     # PVSite class definition
├── models/                         # ML models directory
│   ├── __init__.py
│   ├── gradient_boosting.py        # Default GB model
│   ├── xgboost_model.py            # XGBoost implementation
│   ├── lightgbm_model.py           # LightGBM v3 (new)
│   └── base_model.py               # Abstract base class
├── dataset/                        # Data fetching & loading
│   ├── __init__.py
│   ├── nwp_data.py                 # NWP source handling
│   ├── gfs_fetcher.py              # GFS-specific fetching
│   ├── icon_fetcher.py             # ICON-specific fetching
│   ├── open_meteo_fetcher.py       # Open-Meteo API integration
│   ├── data_loader.py              # General data loading
│   └── validation.py               # Data quality checks
├── features/                       # Feature engineering
│   ├── __init__.py
│   ├── engineering.py              # Feature creation logic
│   ├── scalers.py                  # Data normalization
│   └── lookback.py                 # Historical lookback features
├── utils/                          # Utility functions
│   ├── __init__.py
│   ├── logging.py                  # Logging setup
│   ├── config.py                   # Configuration management
│   ├── constants.py                # Magic numbers, constants
│   └── timezone_utils.py           # Timezone handling (under active work)
└── inference.py                    # Main inference pipeline
```

### Key Classes & Functions

#### PVSite Class (`pv_sites.py`)

```python
class PVSite:
    """Represents a solar PV installation site"""

    def __init__(
        self,
        latitude: float,
        longitude: float,
        capacity_kw: float,
        tilt: Optional[float] = None,
        azimuth: Optional[float] = None,
        **metadata
    ):
        """Initialize a PV site with location and capacity info"""

    @property
    def location(self) -> tuple[float, float]:
        """Return (lat, lon) tuple"""

    def get_forecast(self, hours_ahead: int = 48):
        """Generate forecast for this site"""
```

**Properties:**
- `latitude`, `longitude` — Geographic coordinates (WGS84)
- `capacity_kw` — Installed capacity in kilowatts
- `tilt`, `azimuth` — Panel orientation (optional, used for some models)
- `metadata` — Additional site-specific information (name, owner, etc.)

**Usage Pattern:**
```python
site = PVSite(
    latitude=51.5074,
    longitude=-0.1278,
    capacity_kw=10.0,
    name="London Office"
)
forecast = run_forecast(site)
```

#### run_forecast() Function

```python
def run_forecast(
    site: PVSite,
    nwp_source: str = "gfs",
    model: str = "gradient_boosting",
    hours_ahead: int = 48,
    include_uncertainty: bool = True
) -> ForecastResult:
    """
    Generate a solar forecast for a given PV site.

    Args:
        site: PVSite object with location and capacity
        nwp_source: NWP data source ('gfs', 'icon', 'open_meteo')
        model: ML model to use ('gradient_boosting', 'xgboost', 'lightgbm')
        hours_ahead: Number of hours to forecast
        include_uncertainty: Include confidence intervals

    Returns:
        ForecastResult with predictions and metadata
    """
```

**Data Flow Inside run_forecast():**

1. **NWP Data Fetching** → Download weather forecasts from specified source
2. **Data Validation** → Check quality, handle missing values
3. **Feature Engineering** → Extract 9 NWP variables + site parameters
4. **Model Selection** → Load appropriate ML model
5. **Inference** → Generate predictions
6. **Post-Processing** → Apply adjustments (clipping, uncertainty)
7. **Return** → ForecastResult object

---

## Data Pipeline

### Step-by-Step Data Flow

```
┌─────────────────────────────┐
│  PVSite Definition          │
│  (lat, lon, capacity)       │
└──────────────┬──────────────┘
               │
        ┌──────▼──────┐
        │  NWP Data   │
        │   Fetching  │
        └──────┬──────┘
               │
    ┌──────────┼──────────┬──────────┐
    │          │          │          │
    ▼          ▼          ▼          ▼
   GFS       ICON    Open-Meteo    [Future]
  (12-15k    (~40km)   (API-based) Sources
   nodes)
               │
        ┌──────▼───────────┐
        │   Data Quality   │
        │   Validation     │
        └──────┬───────────┘
               │
        ┌──────▼──────────────────┐
        │  Feature Engineering    │
        │  Extract 9 NWP Variables│
        └──────┬──────────────────┘
               │
    ┌──────────┼──────────────────────┐
    │          │          │           │
    ▼          ▼          ▼           ▼
   Vis      WindSp      Temp      Precip
   10m      Rad_sw      Rad_dir   CC_L/M/H
               │
        ┌──────▼──────────────┐
        │   Feature Scaling   │
        │   (Normalization)   │
        └──────┬──────────────┘
               │
        ┌──────▼────────────────┐
        │  Model Selection      │
        │ (GB/XGB/LGBM)         │
        └──────┬────────────────┘
               │
        ┌──────▼──────────────┐
        │   Inference         │
        │  (Generate Pred.)   │
        └──────┬──────────────┘
               │
        ┌──────▼──────────────────┐
        │  Post-Processing        │
        │  (Bounds, Uncertainty)  │
        └──────┬──────────────────┘
               │
        ┌──────▼──────────────┐
        │  ForecastResult     │
        │  (return to client) │
        └─────────────────────┘
```

### NWP Variable Extraction

Nine meteorological variables are extracted per location and timestep:

| Variable | Unit | Source | Relevance |
|----------|------|--------|-----------|
| **Visibility** | km | NWP model | Aerosol/dust impact on irradiance |
| **Wind Speed (10m)** | m/s | NWP model | Atmospheric cooling, PV performance |
| **Temperature (2m)** | °C | NWP model | Ambient condition, PV efficiency loss |
| **Precipitation** | mm | NWP model | Cloud cover indicator |
| **Shortwave Radiation** | W/m² | NWP model | Global horizontal irradiance |
| **Direct Radiation** | W/m² | NWP model | Direct normal irradiance component |
| **Cloud Cover (Low)** | % | NWP model | <2km altitude cloud obstruction |
| **Cloud Cover (Mid)** | % | NWP model | 2-6km altitude cloud obstruction |
| **Cloud Cover (High)** | % | NWP model | >6km altitude cloud obstruction |

---

## Machine Learning Models

### Model Architecture Overview

All models inherit from an abstract base class:

```python
class BaseModel(ABC):
    """Abstract base for all forecasting models"""

    def __init__(self, config: dict):
        """Initialize model with config"""

    @abstractmethod
    def train(self, X: np.ndarray, y: np.ndarray):
        """Train on features X and targets y"""

    @abstractmethod
    def predict(self, X: np.ndarray) -> np.ndarray:
        """Generate predictions from features"""

    def save(self, path: str):
        """Serialize model to disk"""

    @classmethod
    def load(cls, path: str):
        """Deserialize model from disk"""
```

### Model Comparison

#### 1. Gradient Boosting (Default)
- **Framework:** scikit-learn or XGBoost gradient boosting
- **Input Data:** GFS/ICON NWP forecasts
- **Features:** 9 meteorological variables + site parameters
- **Performance:** MAE = 0.19 kW (on typical 10kW system)
- **Training:** Offline, periodically retrained
- **Inference Speed:** ~50-100ms per site
- **Production Status:** ✅ Stable, proven

#### 2. XGBoost
- **Framework:** XGBoost library
- **Input Data:** Open-Meteo API (lower resolution but fast)
- **Features:** Subset of 9 variables
- **Performance:** MAE = 0.12 kW (better accuracy)
- **Training:** Can be retrained frequently
- **Inference Speed:** ~30-50ms per site (faster)
- **Production Status:** ✅ Stable, lower latency option

#### 3. LightGBM v3 (In Development)
- **Framework:** LightGBM
- **Input Data:** Mixed (GFS + historical)
- **Features:** Enhanced with new variables (snow depth PR in progress)
- **Expected Performance:** MAE < 0.12 kW
- **Training:** Fast, GPU-compatible
- **Inference Speed:** ~20-30ms per site (fastest)
- **Production Status:** 🔄 PR under review

### Model Selection Strategy

```python
# Example: How models are selected at runtime
def get_model(model_name: str, config: dict) -> BaseModel:
    if model_name == "gradient_boosting":
        return GradientBoostingModel(config)
    elif model_name == "xgboost":
        return XGBoostModel(config)
    elif model_name == "lightgbm":
        return LightGBMModel(config)
    else:
        raise ValueError(f"Unknown model: {model_name}")
```

---

## FastAPI Backend (/api/)

### Architecture

```
api/
├── __init__.py
├── main.py                         # FastAPI app creation
├── routes/
│   ├── __init__.py
│   ├── forecast.py                 # /forecast endpoints
│   ├── health.py                   # /health checks
│   ├── sites.py                    # /sites management
│   └── predictions.py              # /predictions historical
├── schemas/
│   ├── __init__.py
│   ├── requests.py                 # Pydantic request models
│   └── responses.py                # Pydantic response models
├── middleware/
│   ├── __init__.py
│   ├── logging.py                  # Request/response logging
│   └── error_handling.py           # Exception handling
└── config.py                       # API configuration
```

### Key Endpoints

**POST /forecast**
```
Request Body:
{
  "site": {
    "latitude": 51.5074,
    "longitude": -0.1278,
    "capacity_kw": 10.0
  },
  "nwp_source": "gfs",
  "model": "gradient_boosting",
  "hours_ahead": 48
}

Response:
{
  "site_id": "london_office",
  "forecast_generated_at": "2026-03-18T10:30:00Z",
  "predictions": [
    {
      "timestamp": "2026-03-18T11:00:00Z",
      "power_kw": 2.34,
      "confidence_lower": 1.95,
      "confidence_upper": 2.73
    },
    ...
  ]
}
```

**GET /health**
```
Response:
{
  "status": "healthy",
  "timestamp": "2026-03-18T10:30:00Z",
  "models_loaded": ["gradient_boosting", "xgboost"],
  "nwp_sources": ["gfs", "icon", "open_meteo"]
}
```

**GET /sites/{site_id}/predictions**
```
Query Parameters:
- from: ISO timestamp (default: 24h ago)
- to: ISO timestamp (default: now)
- limit: number of predictions (default: 100)

Response:
{
  "site_id": "london_office",
  "predictions": [...]
}
```

### Response Models (Pydantic)

```python
class ForecastPrediction(BaseModel):
    timestamp: datetime
    power_kw: float
    confidence_lower: Optional[float] = None
    confidence_upper: Optional[float] = None
    model_version: str

class ForecastResponse(BaseModel):
    site_id: str
    forecast_generated_at: datetime
    predictions: List[ForecastPrediction]
    model_used: str
    nwp_source: str
```

---

## Web Dashboard (/dashboards/)

### Frontend Stack

- **Language:** TypeScript
- **Framework:** React 18+
- **Styling:** CSS Modules / Tailwind CSS
- **State Management:** React Context or Redux
- **Charts:** D3.js or Plotly.js for visualization

### Dashboard Features

1. **Real-time Forecasts** — Live power predictions
2. **Historical Comparison** — Prediction vs. actual performance
3. **Model Performance** — MAE, RMSE, accuracy metrics
4. **Site Management** — Add/edit/delete PV sites
5. **Alert System** — Notify on forecast anomalies
6. **Export Data** — Download forecasts as CSV/JSON

### Component Structure

```
src/
├── components/
│   ├── ForecastChart.tsx           # Main prediction chart
│   ├── SiteSelector.tsx            # Site dropdown/search
│   ├── PerformanceMetrics.tsx      # Accuracy display
│   ├── HistoricalComparison.tsx    # Actual vs predicted
│   └── Settings.tsx                # Model/NWP selection
├── pages/
│   ├── Dashboard.tsx               # Main dashboard
│   ├── SiteDetails.tsx             # Per-site view
│   └── Admin.tsx                   # Management panel
├── services/
│   └── api.ts                      # FastAPI client
├── hooks/
│   └── useForecast.ts              # Forecast data fetching
├── types/
│   └── index.ts                    # TypeScript interfaces
└── App.tsx
```

---

## Testing Infrastructure

### Test Organization

```
tests/
├── unit/                           # Unit tests
│   ├── test_models.py              # Model behavior
│   ├── test_features.py            # Feature engineering
│   ├── test_pv_sites.py            # PVSite class
│   └── test_utils.py               # Utility functions
├── integration/                    # Integration tests
│   ├── test_pipeline.py            # Full data pipeline
│   ├── test_api_endpoints.py       # API endpoint behavior
│   └── test_nwp_fetching.py        # NWP data sources
├── fixtures/                       # Test data
│   ├── sample_nwp_data.py          # Mock NWP data
│   ├── sample_sites.py             # Test PV sites
│   └── expected_forecasts.py       # Expected outputs
└── conftest.py                     # pytest configuration
```

### Testing Tools

- **Framework:** pytest
- **Mocking:** unittest.mock, pytest-mock
- **Fixtures:** pytest fixtures for consistent test data
- **CI/CD:** GitHub Actions
- **Coverage:** pytest-cov (target: >85%)

### Example Test

```python
def test_gradient_boosting_forecast():
    """Test GB model forecast generation"""
    site = PVSite(
        latitude=51.5074,
        longitude=-0.1278,
        capacity_kw=10.0
    )

    forecast = run_forecast(
        site,
        model="gradient_boosting",
        hours_ahead=24
    )

    assert len(forecast.predictions) == 24
    assert all(p.power_kw >= 0 for p in forecast.predictions)
    assert forecast.model_used == "gradient_boosting"
```

---

## Build & Deployment

### Installation Methods

**Method 1: From PyPI (End Users)**
```bash
pip install quartz-solar-forecast
```

**Method 2: Development Install (Contributors)**
```bash
git clone https://github.com/openclimatefix/open-source-quartz-solar-forecast.git
cd open-source-quartz-solar-forecast
pip install -e ".[dev]"
```

**Method 3: Docker (Production)**
```bash
docker build -t quartz-forecast:latest .
docker run -p 8000:8000 quartz-forecast:latest
```

### CI/CD Pipeline (GitHub Actions)

```yaml
name: Tests & Deployment
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: [3.9, "3.10", "3.11", "3.12"]
    steps:
      - uses: actions/checkout@v3
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}
      - name: Install dependencies
        run: pip install -r requirements.txt
      - name: Run tests
        run: pytest
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

---

## Performance Characteristics

### Inference Latency
- **Gradient Boosting:** 50-100ms per site
- **XGBoost:** 30-50ms per site
- **LightGBM:** 20-30ms per site

### Memory Usage
- **Model Size:** 50-200 MB per model
- **NWP Data:** 500 MB - 2 GB per grid (depends on resolution)
- **Feature Engineering:** 100-500 MB per batch

### Accuracy Metrics
- **MAE (Gradient Boosting):** 0.19 kW
- **MAE (XGBoost):** 0.12 kW
- **MAE (LightGBM, expected):** < 0.12 kW

---

## Roadmap & Active Work

### Completed
- ✅ Gradient Boosting model
- ✅ XGBoost model
- ✅ GFS/ICON NWP fetching
- ✅ Basic FastAPI backend
- ✅ React dashboard (MVP)

### In Progress
- 🔄 LightGBM v3 integration
- 🔄 Python 3.12 compatibility
- 🔄 Timezone handling fixes
- 🔄 Snow depth feature extraction

### Planned
- 📅 DuckDB for Parquet optimization
- 📅 Evaluation pipeline improvements
- 📅 Error adjuster (TabPFN-based)
- 📅 Real-time performance monitoring
- 📅 Advanced uncertainty quantification

---

## Architecture Design Principles

1. **Modularity** — Each component (data, models, API) is independent
2. **Extensibility** — Easy to add new models, NWP sources, features
3. **Reproducibility** — Version control for data, models, experiments
4. **Testing** — Comprehensive unit and integration tests
5. **Documentation** — Clear docs for developers and users
6. **Performance** — Optimized inference for production use
7. **Accessibility** — Open-source with clear contribution guidelines
