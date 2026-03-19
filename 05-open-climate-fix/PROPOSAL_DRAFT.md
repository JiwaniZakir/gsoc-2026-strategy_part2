# GSoC 2026 Proposal: TabPFN-Based Solar Forecast Error Adjustment

**Applicant:** Zakir Jiwani
**GitHub:** github.com/JiwaniZakir
**Email:** jiwzakir@gmail.com
**Timezone:** EST (UTC-5)
**Availability:** Full-time, 40 hrs/week (May–August)
**Organization:** Open Climate Fix
**Project Title:** Adjuster This! TabPFN for Solar Forecast Error Adjustment
**Duration:** 13 weeks (May 27 – August 28, 2026)
**Mentors:** [To confirm]

---

## Synopsis

The Quartz Solar Forecast system produces accurate solar power predictions, but systematic errors persist: morning/evening predictions skew in predictable directions, seasonal cloud formations introduce seasonal biases, and location-specific weather patterns create persistent offsets. These errors are learnable — and a trained adjuster can correct for them in real time. This project implements a **TabPFN-based error adjustment system** that learns to predict and correct forecast residuals from historical (forecast, actual) pairs, reducing MAE by 10–15%. The adjuster is fully integrated into the existing API (`run_forecast(site, apply_adjuster=True)`), exposed as a REST endpoint, and optionally visualized in the web dashboard.

---

## Problem Statement

### Current State

The Quartz Solar system's base models are already good:
- Gradient Boosting: MAE = 0.19 kW
- XGBoost: MAE = 0.12 kW

But "good overall" hides systematic failures:

| Error Type | Pattern | Impact |
|-----------|---------|--------|
| Time-of-day bias | Morning predictions consistently high, evening consistently low | Grid operators see systematic overproduction in AM |
| Seasonal error | Summer high-irradiance days have different error distributions | Summer accuracy degrades |
| Weather-conditional | High wind + low cloud day = distinct error profile | Difficult edge cases |
| Location-specific | Coastal vs. inland sites have different bias offsets | Per-site calibration needed |

These patterns mean **a model that learns residuals from historical data can systematically improve predictions** — without retraining the base model.

### Why TabPFN

TabPFN (Tabular Prior-data Fitted Networks) is designed for exactly this use case:
- **Small tabular datasets:** The error pattern history for any given site is a small tabular dataset (features + residual). TabPFN outperforms gradient boosting on datasets with <1000 samples.
- **No hyperparameter tuning:** TabPFN requires no tuning — it learns from in-context examples. This matters for production: no retraining pipeline needed.
- **Uncertainty quantification:** TabPFN provides calibrated uncertainty estimates, which are more useful to grid operators than a point prediction.
- **Fast inference:** Once the in-context examples are set, TabPFN inference is fast (~ms per prediction).

---

## Technical Design

### Adjuster Architecture

```
Base Forecast Pipeline
┌─────────────────────────────────┐
│ run_forecast(site, start, end)  │
│   → raw_forecast: pd.DataFrame  │
└─────────────────────────────────┘
              ↓
Adjuster Feature Engineering
┌─────────────────────────────────┐
│ AdjusterFeatures.from_forecast: │
│   - raw_forecast_value          │
│   - hour_of_day (sin/cos)       │
│   - day_of_year (sin/cos)       │
│   - irradiance (from NWP)       │
│   - temperature                 │
│   - cloud_cover                 │
│   - wind_speed                  │
└─────────────────────────────────┘
              ↓
TabPFN Adjuster
┌─────────────────────────────────┐
│ TabPFNAdjuster.predict:         │
│   In-context: historical        │
│   (features, residual) pairs    │
│   Output: predicted residual    │
│   + uncertainty interval        │
└─────────────────────────────────┘
              ↓
Adjusted Forecast
┌─────────────────────────────────┐
│ adjusted = raw + predicted_Δ    │
│ interval = raw ± uncertainty    │
└─────────────────────────────────┘
```

### Core Implementation

**TabPFNAdjuster Class:**
```python
from dataclasses import dataclass
from typing import Optional
import pandas as pd
import numpy as np
from tabpfn import TabPFNRegressor

@dataclass
class AdjustmentResult:
    adjusted_forecast: pd.Series     # raw + predicted residual
    predicted_residual: pd.Series    # Δ the adjuster learned
    confidence_interval_lower: pd.Series
    confidence_interval_upper: pd.Series
    mae_improvement_estimate: float  # estimated % improvement over raw

class TabPFNAdjuster:
    """
    Learns to predict forecast residuals from historical error patterns.
    Uses TabPFN for in-context learning on small tabular datasets.
    """

    def __init__(self, n_context_samples: int = 128):
        self.model = TabPFNRegressor(device='cpu', N_ensemble_configurations=16)
        self.n_context_samples = n_context_samples
        self._context_X: Optional[np.ndarray] = None
        self._context_y: Optional[np.ndarray] = None
        self._is_fitted = False

    def fit(self, historical_forecasts: pd.DataFrame, actuals: pd.Series) -> 'TabPFNAdjuster':
        """
        Build in-context dataset from historical (forecast, actual) pairs.

        Args:
            historical_forecasts: DataFrame with forecast values + weather features
            actuals: Actual measured power output (same index)
        """
        residuals = actuals - historical_forecasts['forecast_power_kw']
        features = self._build_features(historical_forecasts)

        # TabPFN works best with ≤1024 context samples
        if len(features) > self.n_context_samples:
            # Stratified sample to preserve temporal distribution
            idx = self._stratified_sample(features, self.n_context_samples)
            features, residuals = features.iloc[idx], residuals.iloc[idx]

        self._context_X = features.values
        self._context_y = residuals.values
        self.model.fit(self._context_X, self._context_y)
        self._is_fitted = True
        return self

    def predict(self, forecast: pd.DataFrame) -> AdjustmentResult:
        """Apply learned adjustment to new forecast."""
        if not self._is_fitted:
            raise RuntimeError('Adjuster must be fitted before predicting')

        features = self._build_features(forecast)
        predicted_residual = self.model.predict(features.values)
        # TabPFN provides sample-based uncertainty estimation
        residual_samples = self.model.predict(features.values, return_logits=False)

        adjusted = forecast['forecast_power_kw'] + predicted_residual
        return AdjustmentResult(
            adjusted_forecast=pd.Series(adjusted, index=forecast.index),
            predicted_residual=pd.Series(predicted_residual, index=forecast.index),
            confidence_interval_lower=pd.Series(
                np.percentile(residual_samples, 5, axis=0), index=forecast.index
            ),
            confidence_interval_upper=pd.Series(
                np.percentile(residual_samples, 95, axis=0), index=forecast.index
            ),
            mae_improvement_estimate=self._estimate_improvement()
        )

    def _build_features(self, df: pd.DataFrame) -> pd.DataFrame:
        """Feature engineering for the adjuster."""
        features = pd.DataFrame(index=df.index)
        features['forecast_kw'] = df['forecast_power_kw']
        # Cyclical time encoding (avoids discontinuity at midnight/Jan 1)
        features['hour_sin'] = np.sin(2 * np.pi * df.index.hour / 24)
        features['hour_cos'] = np.cos(2 * np.pi * df.index.hour / 24)
        features['doy_sin'] = np.sin(2 * np.pi * df.index.dayofyear / 365)
        features['doy_cos'] = np.cos(2 * np.pi * df.index.dayofyear / 365)
        # Weather features (where available from NWP)
        for col in ['irradiance_w_m2', 'temperature_c', 'cloud_cover', 'wind_speed_ms']:
            features[col] = df.get(col, 0.0)
        return features
```

### Integration with Existing API

**Current API (unchanged):**
```python
forecast = run_forecast(site, start_time, end_time)
# Returns: pd.DataFrame with forecast_power_kw column
```

**New optional parameter (backward compatible):**
```python
# Default: same as before
forecast = run_forecast(site, start_time, end_time)

# With adjuster:
result = run_forecast(site, start_time, end_time, apply_adjuster=True)
# Returns AdjustmentResult with adjusted_forecast + interval
```

**Implementation:**
```python
def run_forecast(
    site: PVSite,
    timestamp: datetime,
    apply_adjuster: bool = False,
    adjuster_context_days: int = 30
) -> pd.DataFrame | AdjustmentResult:
    # Existing forecast logic (unchanged)
    raw_forecast = _run_base_model(site, timestamp)

    if not apply_adjuster:
        return raw_forecast  # Unchanged behavior

    # Load historical data for adjuster context
    historical = _load_historical_pairs(site, n_days=adjuster_context_days)
    if len(historical) < 7:  # Not enough history
        return raw_forecast  # Fall back gracefully

    adjuster = TabPFNAdjuster()
    adjuster.fit(historical['forecasts'], historical['actuals'])
    return adjuster.predict(raw_forecast)
```

### REST API Extension

**New Endpoint:**
```
POST /forecast/adjusted
Content-Type: application/json

{
  "site_id": "site_001",
  "timestamp": "2026-03-19T12:00:00Z",
  "context_days": 30
}

Response:
{
  "site_id": "site_001",
  "timestamp": "2026-03-19T12:00:00Z",
  "raw_forecast_kw": 4.2,
  "adjusted_forecast_kw": 3.8,
  "adjustment_delta_kw": -0.4,
  "confidence_interval": {
    "lower_kw": 3.1,
    "upper_kw": 4.5
  },
  "adjuster_context_samples": 128,
  "mae_improvement_estimate": 0.12
}
```

---

## Week-by-Week Timeline

| Week | Focus | Deliverables |
|------|-------|-------------|
| 1 | Architecture + environment | Design reviewed by mentors, feature engineering plan |
| 2 | AdjusterFeatures + TabPFNAdjuster.fit | Core class, unit tests |
| 3 | TabPFNAdjuster.predict + confidence intervals | Full prediction with uncertainty |
| 4 | API integration (`apply_adjuster=True`) | Backward-compatible API change |
| 5 | Error analysis tooling | Residual analysis, bias detection utilities |
| 6 | *MIDTERM* End-to-end working + benchmarks | Adjuster integrated, MAE comparison |
| 7 | REST endpoint implementation | POST /forecast/adjusted endpoint |
| 8 | Per-site calibration + context management | Site-specific adjuster fitting |
| 9 | React dashboard component | Adjusted vs. raw forecast visualization |
| 10 | Performance optimization | Batch prediction, caching fitted adjuster |
| 11 | Documentation + tutorials | Integration guide, example notebooks |
| 12 | Final testing + polish | Comprehensive tests, benchmark report |
| 13 | Buffer / stretch goals | Additional site types, broader evaluation |

**Midterm (Week 6):** `TabPFNAdjuster` fully working, integrated into `run_forecast`, MAE comparison benchmarks on test sites showing improvement.

**Final (Week 13):** REST endpoint, optional React component, documentation, per-site calibration, comprehensive test suite.

---

## Evaluation Approach

### Benchmark Protocol

```python
def evaluate_adjuster(site_ids: list[str], n_test_days: int = 30):
    """Evaluate adjuster improvement across multiple sites."""
    results = []
    for site_id in site_ids:
        # Use first n_context_days for fitting, last n_test_days for evaluation
        history = load_historical_data(site_id)
        train, test = train_test_split_temporal(history)

        adjuster = TabPFNAdjuster().fit(
            train['forecasts'], train['actuals']
        )

        raw_mae = mean_absolute_error(test['actuals'], test['raw_forecasts'])
        adjusted_mae = mean_absolute_error(
            test['actuals'],
            adjuster.predict(test['raw_forecasts']).adjusted_forecast
        )

        results.append({
            'site_id': site_id,
            'raw_mae': raw_mae,
            'adjusted_mae': adjusted_mae,
            'improvement_pct': (raw_mae - adjusted_mae) / raw_mae * 100
        })

    return pd.DataFrame(results)
```

**Target:** 10–15% MAE reduction across test sites.

---

## Expected Deliverables

### Code
- `TabPFNAdjuster` class with full API
- `AdjusterFeatures` feature engineering module
- `run_forecast(apply_adjuster=True)` integration
- `POST /forecast/adjusted` REST endpoint
- Per-site calibration and context management

### Tests
- Unit tests for `TabPFNAdjuster` (fit, predict, edge cases)
- Integration tests for API endpoint
- Benchmark evaluation suite

### Documentation
- "Using the Error Adjuster" guide
- Example Jupyter notebook showing improvement on real data
- Benchmark report with before/after MAE comparison

---

## About the Applicant

**Zakir Jiwani** | GitHub: [JiwaniZakir](https://github.com/JiwaniZakir) | EST

My relevant background:

**Tabular ML & Error Correction:**
- Built **spectra**, a RAG evaluation toolkit — core problem is learning to predict quality from features (analogous to learning to predict forecast error from weather features)
- Experience with HuggingFace, TabPFN-adjacent approaches, and uncertainty quantification
- Familiar with systematic error analysis and bias correction in ML pipelines

**Python ML Ecosystem:**
- scikit-learn, pandas, numpy expertise from aegis and spectra projects
- FastAPI/REST API background for the `/forecast/adjusted` endpoint
- pytest discipline — all my projects have comprehensive test suites

**Full-Stack (for Dashboard Component):**
- **evictionchatbot**: React/Vite frontend — directly applicable to the React chart component
- **Partnerships_OS**: Turborepo/React — experience with production frontend components

**Why Solar Forecast Adjustment:**
The TabPFN approach is technically elegant — using in-context learning for error correction means no retraining infrastructure, no hyperparameter tuning, and fast iteration. This is the kind of pragmatic ML engineering that actually gets deployed and used, not just written in notebooks. Open Climate Fix's mission (use ML to accelerate the green energy transition) is worth contributing to beyond GSoC.

---

## Questions for Mentors

1. **Context window size:** Is 30 days (~720 data points) a reasonable default for the in-context set, or do you prefer more conservative (7 days) to keep inference fast?
2. **Feature set:** Are the weather features from NWP (irradiance, temperature, cloud cover) already in the base forecast output, or will the adjuster need to fetch them separately?
3. **Dashboard scope:** Is the React component in scope for GSoC, or should I treat it as a stretch goal and focus on Python API first?
4. **Evaluation sites:** Do you have specific test sites I should target in the benchmark evaluation?
5. **Uncertainty output format:** Do grid operators have a preferred confidence interval representation (percentiles vs. ± sigma)?

---

**Status:** Near-final draft — ready for mentor review
**Last Updated:** March 2026
**Submitted by:** Zakir Jiwani (JiwaniZakir)
