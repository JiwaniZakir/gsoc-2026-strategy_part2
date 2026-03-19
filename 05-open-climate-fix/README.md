# Open Climate Fix - GSoC 2026 Strategy

## Organization Overview

**Open Climate Fix (OCF)** is a nonprofit organization leveraging artificial intelligence and machine learning to help mitigate climate change. The organization focuses on making clean energy systems more efficient, reliable, and cost-effective through data-driven solutions.

**Mission:** Use AI/ML to help humanity mitigate climate change by improving renewable energy forecasting and optimization.

**GitHub:** [github.com/openclimatefix](https://github.com/openclimatefix)
- 56 active repositories
- Strong community focus on open-source collaboration
- MIT License across primary projects

---

## Primary Project: Quartz Solar Forecast

**Repository:** [github.com/openclimatefix/open-source-quartz-solar-forecast](https://github.com/openclimatefix/open-source-quartz-solar-forecast)

**Project Statistics:**
- 125 stars
- 105 forks
- 523 commits
- 42 contributors
- MIT License

### What is Quartz?

Quartz Solar Forecast is an open-source tool that provides accurate solar irradiance and PV power predictions. It combines:
- **Numerical Weather Prediction (NWP) data** from multiple sources (GFS, ICON, Open-Meteo)
- **Machine learning models** (Gradient Boosting, XGBoost, LightGBM) trained on historical data
- **Real-time APIs** for integration into production systems
- **Web dashboards** for visualization and monitoring

Solar forecasting is critical infrastructure for grid operators, renewable energy companies, and utilities—enabling better energy dispatch, storage management, and cost reduction.

---

## Ecosystem of Related Repositories

| Repository | Language | Purpose |
|------------|----------|---------|
| **open-source-quartz-solar-forecast** | Python | Core forecasting package and models |
| **quartz-frontend** | TypeScript/React | Web UI dashboard |
| **quartz-api** | Python | FastAPI backend service |
| **quartz-status** | - | System status monitoring |
| **global-solar-forecast** | Python | Global-scale forecasting extension |

---

## Technology Stack

### Backend
- **Language:** Python 3.9+
- **ML Frameworks:** PyTorch, XGBoost, LightGBM
- **API Framework:** FastAPI
- **Data Processing:** Pandas, NumPy, Xarray
- **Testing:** pytest, GitHub Actions CI/CD
- **Package Distribution:** pip, conda

### Frontend
- **Language:** TypeScript
- **Framework:** React
- **Styling & UI:** Modern CSS/component libraries

### Infrastructure
- **Data Sources:** GFS, ICON, Open-Meteo NWP APIs
- **Storage:** Parquet files (DuckDB integration in progress)
- **Deployment:** Docker, cloud-ready

---

## Communication Channels

| Channel | Purpose | Contact |
|---------|---------|---------|
| **Email** | General inquiries, mentorship | quartz.support@openclimatefix.org, info@openclimatefix.org |
| **GitHub Issues** | Bug reports, feature requests | Repository issues tracker |
| **GitHub Discussions** | Q&A, design discussions | Per-repository discussions |
| **Website** | Organization info | [openclimatefix.org](https://openclimatefix.org) |

---

## Codebase Architecture

### Directory Structure
```
open-source-quartz-solar-forecast/
├── quartz_solar_forecast/      # Main Python package
│   ├── models/                 # ML models (GB, XGBoost, LightGBM)
│   ├── dataset/                # Data fetching & preprocessing
│   ├── features/               # Feature engineering
│   └── pv_sites.py             # PVSite class definition
├── api/                        # FastAPI application
├── dashboards/                 # Web UI components
├── examples/                   # Jupyter notebooks & demos
├── scripts/                    # Utility scripts (forecast_csv.py)
├── tests/                      # pytest test suite
├── requirements.txt            # Python dependencies
└── README.md
```

### Key Components

**1. PVSite Class**
- Represents individual solar installation sites
- Encapsulates location, capacity, and metadata
- Used throughout forecasting pipeline

**2. run_forecast() Function**
- Main entry point for generating predictions
- Orchestrates NWP data fetching, feature engineering, model inference
- Returns confidence intervals and uncertainty metrics

**3. NWP Data Pipeline**
- Fetches weather data from GFS, ICON, or Open-Meteo
- Applies quality checks and interpolation
- Extracts 9 key meteorological variables (see below)

**4. FastAPI Backend**
- RESTful endpoints for forecasting
- Health checks and status monitoring
- Request validation and response serialization

---

## Forecasting Models

### Available Models

**1. Gradient Boosting (Default)**
- **Data Source:** GFS/ICON Numerical Weather Prediction
- **Features:** 9 NWP variables
- **Performance:** MAE 0.19 kW
- **Strengths:** Robust, well-tested, production-proven

**2. XGBoost**
- **Data Source:** Open-Meteo API
- **Features:** Subset of NWP variables
- **Performance:** MAE 0.12 kW
- **Strengths:** Faster inference, lower latency

**3. LightGBM v3**
- **Status:** Currently being added via PR
- **Expected Benefits:** Further performance improvements, faster training

### NWP Variables Used

The models leverage 9 key meteorological variables:
1. **Visibility** (km) — Air clarity
2. **Wind Speed 10m** (m/s) — Surface wind affecting air cooling
3. **Temperature 2m** (°C) — Ambient temperature
4. **Precipitation** (mm) — Cloud/rain impact
5. **Shortwave Radiation** (W/m²) — Direct solar irradiance
6. **Direct Radiation** (W/m²) — Direct normal irradiance
7. **Cloud Cover (Low)** (%) — Low-altitude cloud fraction
8. **Cloud Cover (Mid)** (%) — Mid-altitude cloud fraction
9. **Cloud Cover (High)** (%) — High-altitude cloud fraction

---

## Getting Started

### Installation
```bash
# Clone repository
git clone https://github.com/openclimatefix/open-source-quartz-solar-forecast.git
cd open-source-quartz-solar-forecast

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Optional: Install in development mode
pip install -e .
```

### Running Examples
```bash
# Launch Jupyter to explore examples
jupyter notebook

# Run a forecast programmatically
python3 -c "from quartz_solar_forecast import run_forecast; ..."
```

### Testing
```bash
# Run test suite
pytest

# Run with coverage
pytest --cov=quartz_solar_forecast
```

---

## Current Development Status

### Open Issues (34 Total)
- **Evaluation pipeline optimization** — Improve model evaluation metrics
- **Python 3.12 compatibility** — Ensure latest Python support
- **DuckDB for Parquet data** — Performance improvement for data handling
- **Prediction accuracy documentation** — Document model performance benchmarks
- **Race condition bugs** — Concurrency issues in data pipeline
- **Timezone handling** — Edge cases in temporal conversions
- **Documentation improvements** — API docs, architecture guides

### Open Pull Requests (26 Total)
- Zimbabwe flag addition (minor contribution)
- Timezone fixes (active work)
- Python 3.12 compatibility (in review)
- LightGBM v3 model integration (feature addition)
- Snow depth feature (data enhancement)

---

## GSoC 2026 Project Focus

### Proposed Project: "Adjuster This! TabPFN for Solar Forecast Error Adjustment"

**Objective:** Develop a machine learning-based error adjuster for solar forecast predictions using TabPFN (a neural network optimized for tabular data).

**Key Components:**
- Analyze forecast residuals (prediction errors) to identify systematic patterns
- Train TabPFN model to learn error distributions
- Apply adjustments to raw forecasts for improved accuracy
- Integrate adjuster into API/dashboard

**Expected Impact:**
- Reduce overall Mean Absolute Error (MAE)
- Provide more reliable confidence intervals
- Enable grid operators to make better decisions

---

## Contribution Philosophy

> "OCF fosters an inclusive open-source community, welcoming participation from everyone."

OCF explicitly encourages:
- First-time open-source contributors
- Diverse backgrounds and experience levels
- Collaborative problem-solving
- Learning and knowledge-sharing

The organization provides mentorship and clear guidance for new contributors, making it an excellent fit for GSoC participants.

---

## Key Contacts

- **Project Lead/Mentors:** Available via GitHub and email
- **Support Email:** quartz.support@openclimatefix.org
- **General Inquiries:** info@openclimatefix.org
- **Community:** GitHub Discussions in each repository

---

## References & Resources

- **Main Repo:** https://github.com/openclimatefix/open-source-quartz-solar-forecast
- **Organization:** https://openclimatefix.org
- **GitHub Org:** https://github.com/openclimatefix
- **Contributing Guide:** In repository (CONTRIBUTING.md)
