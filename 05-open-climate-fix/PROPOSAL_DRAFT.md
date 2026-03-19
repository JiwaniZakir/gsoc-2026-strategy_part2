# GSoC 2026 Proposal: Adjuster This! TabPFN for Solar Forecast Error Adjustment

## Project Information

**Project Title:** Adjuster This! TabPFN for Solar Forecast Error Adjustment

**Organization:** Open Climate Fix

**Mentors:** [To be confirmed]

**Project Duration:** 13 weeks (May 27 - August 28, 2026)

**Contributor:** Zakir Jiwani
- **GitHub:** github.com/zakirjiwani
- **Timezone:** EST
- **Experience Level:** Intermediate Python/ML developer

---

## Executive Summary

Current solar irradiance and PV power forecasts in the Quartz Solar Forecast project exhibit systematic errors that could be significantly reduced through learned error adjustment. This project proposes implementing a **TabPFN-based neural network adjuster** that learns to predict and correct forecast residuals, improving overall prediction accuracy by 10-15% while maintaining production-ready performance.

**Concrete Deliverable:** A fully integrated error adjustment system accessible via:
1. Python API (`run_forecast(site, apply_adjuster=True)`)
2. RESTful endpoint (`POST /forecast/adjusted`)
3. Web dashboard component (React)

---

## Problem Statement

### Current State

The Quartz Solar Forecast system provides accurate solar power predictions using machine learning models:
- **Gradient Boosting** model achieves MAE = 0.19 kW (Mean Absolute Error)
- **XGBoost** model achieves MAE = 0.12 kW
- Models are well-tested, production-ready, and widely used

### The Opportunity

Despite good overall performance, these models exhibit **systematic, predictable errors**:

1. **Time-of-Day Bias** — Morning/evening predictions systematically underestimate or overestimate actual values
2. **Seasonal Patterns** — Summer vs. winter cloud formations cause different error distributions
3. **Weather-Dependent Errors** — High wind days, high cloud cover days show distinct error patterns
4. **Location-Specific Biases** — Topography and local weather patterns introduce systematic offsets

### Why This Matters

Grid operators and renewable energy companies rely on forecast accuracy for:
- Demand-side management and energy pricing
- Battery storage scheduling and sizing
- Reserve power planning
- Cost optimization (±0.05 kW error = ±$5-10/day per 10kW system)

A 10% accuracy improvement translates to significant operational and financial benefits.

### Why TabPFN?

**TabPFN (Tabular Prior Function Networks)** is uniquely suited for this task:
- Designed specifically for **tabular/structured data** (our feature set)
- Fast training even with small-to-medium datasets
- Excellent at capturing non-linear relationships in residuals
- Interpretable predictions with uncertainty quantification
- Recently published (2022) and gaining adoption in industry

---

## Proposed Solution

### High-Level Approach

**Step 1: Error Analysis**
- Analyze historical forecast residuals (prediction - actual)
- Identify systematic patterns (temporal, spatial, weather-dependent)
- Visualize error distributions and correlations

**Step 2: TabPFN Model Development**
- Engineer features from raw forecasts and NWP variables
- Train TabPFN to predict residual adjustments
- Validate on holdout test set
- Achieve >10% MAE improvement

**Step 3: Integration**
- Integrate adjuster into `run_forecast()` pipeline
- Add optional `apply_adjuster` parameter
- Create API endpoint for adjusted forecasts
- Maintain backward compatibility (adjuster is optional)

**Step 4: Dashboard & Visualization**
- React component displaying adjusted forecasts
- Side-by-side comparison (raw vs. adjusted)
- Performance improvement metrics
- Toggle to show/hide adjuster impact

**Step 5: Testing & Documentation**
- Comprehensive test suite (>90% coverage)
- User guide explaining what the adjuster does
- Developer documentation for maintenance
- Examples and Jupyter notebooks

---

## Technical Architecture

### Data Flow

```
Historical Data (Power + Forecasts)
         ↓
    Error Analysis
         ↓
  Feature Engineering
  (Raw forecast, NWP vars, site params, temporal features)
         ↓
  TabPFN Training
  (Learn residual prediction function)
         ↓
  New Forecast Request
         ↓
  ┌─────────────────────┐
  │  Raw Forecast       │  (from GB/XGBoost model)
  │  + Features         │
  └──────────┬──────────┘
             ↓
  ┌─────────────────────┐
  │  TabPFN Adjuster    │  (learns error patterns)
  └──────────┬──────────┘
             ↓
  Predicted Residual (Δ)
             ↓
  ┌─────────────────────┐
  │  Adjusted Forecast  │  (Raw + Δ)
  └─────────────────────┘
             ↓
  API Response + Dashboard Display
```

### Model Architecture

```python
class TabPFNAdjuster:
    """
    Learns to predict forecast residuals using TabPFN.

    Input features:
    - Raw forecast (kW)
    - 9 NWP variables (visibility, wind, temp, precip, radiation, cloud cover)
    - Site parameters (latitude, longitude, capacity)
    - Temporal features (hour_of_day, day_of_year, season)
    - Historical statistics (mean forecast error this hour/season)

    Output:
    - Predicted residual (adjustment in kW)
    - Confidence/uncertainty estimate
    """

    def __init__(self, model_config: dict):
        self.model = TabPFNClassifier()  # or Regressor depending on setup
        self.feature_scaler = StandardScaler()
        self.training_history = {}

    def fit(self, X_features: np.ndarray, y_residuals: np.ndarray):
        """Train on historical forecast residuals"""
        X_scaled = self.feature_scaler.fit_transform(X_features)
        self.model.fit(X_scaled, y_residuals)
        self.training_history['converged'] = True

    def predict_adjustment(self, X_features: np.ndarray) -> tuple:
        """Predict residual and confidence"""
        X_scaled = self.feature_scaler.transform(X_features)
        adjustment = self.model.predict(X_scaled)
        uncertainty = self.model.predict_proba(X_scaled)  # or similar
        return adjustment, uncertainty
```

### Integration Points

**1. Core Package** (`/quartz_solar_forecast/`)
- New module: `/models/adjuster.py` — TabPFN adjuster class
- Modified: `/inference.py` — Add adjustment to forecast pipeline
- New tests: `/tests/unit/test_adjuster.py`

**2. FastAPI Backend** (`/api/`)
- New endpoint: `POST /forecast/adjusted`
- Schema: `AdjustedForecastRequest`, `AdjustedForecastResponse`
- Routes: `/api/routes/forecast.py` (extended)

**3. Frontend Dashboard** (`/dashboards/`)
- New component: `AdjustedForecastChart.tsx`
- Settings panel for adjuster control
- Performance comparison visualization

**4. Examples & Documentation**
- Jupyter notebook: `examples/adjuster_demo.ipynb`
- User guide: `docs/adjuster-user-guide.md`
- Architecture: `docs/adjuster-architecture.md`

---

## Implementation Timeline

### Week 1-2: Setup & Error Analysis (May 27 - June 10)

**Goal:** Understand forecast error patterns

**Deliverables:**
- [ ] Development environment fully configured
- [ ] Historical dataset loaded and cleaned
- [ ] Error analysis notebook created
- [ ] Comprehensive report on error patterns

**Key Activities:**
1. Clone all required repositories (main, frontend, API)
2. Set up local development environment
3. Load historical forecast + actual data
4. Analyze residuals by:
   - Time of day
   - Season/month
   - Weather conditions (cloud cover, wind, temp)
   - Location/latitude bands
5. Create visualizations showing patterns
6. Document findings in `01_error_analysis.ipynb`

**Success Criteria:**
- Clear understanding of error distributions
- Identified 5+ systematic error patterns
- Visualization plots saved to `/notebooks/figures/`

---

### Week 3-4: TabPFN Model Development (June 11-24)

**Goal:** Build and train TabPFN adjuster model

**Deliverables:**
- [ ] TabPFN adjuster class implemented
- [ ] Feature engineering pipeline created
- [ ] Model trained and evaluated
- [ ] MAE improvement documented

**Key Activities:**
1. Engineer features for TabPFN
   - Raw forecast value
   - 9 NWP variables
   - Site parameters (lat, lon, capacity)
   - Temporal features (hour, day, season)
   - Rolling statistics (mean error patterns)
2. Collect training data (80% of dataset)
3. Implement `TabPFNAdjuster` class in `/quartz_solar_forecast/models/adjuster.py`
4. Train model with cross-validation
5. Evaluate on test set (20% of dataset)
6. Achieve MAE improvement: target 10% reduction

**Success Criteria:**
- Baseline MAE: 0.19 kW (GB) or 0.12 kW (XGB)
- Adjusted MAE: <0.17 kW (GB) or <0.11 kW (XGB)
- Model file saved and reproducible
- Training notebook: `02_tabpfn_training.ipynb`

---

### Week 5-6: Pipeline Integration (June 25 - July 8)

**Goal:** Integrate adjuster into forecasting pipeline

**Deliverables:**
- [ ] Modified `run_forecast()` function
- [ ] Backward compatibility maintained
- [ ] Integration tests passing
- [ ] Performance benchmarks

**Key Activities:**
1. Create `AdjustedForecast` class wrapping raw forecasts
2. Modify `run_forecast()` to support:
   ```python
   forecast = run_forecast(
       site,
       model="gradient_boosting",
       apply_adjuster=True,  # NEW
       adjuster_confidence=0.95,  # NEW
       ...
   )
   ```
3. Ensure adjuster is optional (backward compatible)
4. Create integration tests:
   - Test with 3+ different sites
   - Test with different NWP sources
   - Test adjuster disabled (fallback to raw)
5. Benchmark performance:
   - Inference latency (target: <5ms overhead)
   - Memory usage
   - Accuracy metrics

**Success Criteria:**
- All tests passing (pytest)
- No regressions in baseline forecasts
- Integration tests cover main use cases
- Performance overhead <10%

---

### Week 7-8: FastAPI Endpoint Implementation (July 9-22)

**Goal:** Expose adjuster through REST API

**Deliverables:**
- [ ] `POST /forecast/adjusted` endpoint live
- [ ] OpenAPI documentation complete
- [ ] API integration tests passing
- [ ] Performance validated

**Key Activities:**
1. Design request/response schemas
   ```python
   class AdjustedForecastRequest(BaseModel):
       site: SiteInfo
       nwp_source: str = "gfs"
       model: str = "gradient_boosting"
       apply_adjuster: bool = True
       confidence_level: float = 0.95

   class AdjustedPrediction(BaseModel):
       timestamp: datetime
       raw_power_kw: float
       adjusted_power_kw: float
       adjustment_kw: float
       confidence_interval: tuple
   ```
2. Implement endpoint in `/api/routes/forecast.py`
3. Comprehensive API documentation (docstrings)
4. Input validation and error handling
5. Create API tests:
   - Valid requests
   - Invalid input (missing fields, wrong types)
   - Edge cases (capacity = 0, extreme locations)
6. Load testing (concurrent requests)

**Success Criteria:**
- Endpoint accepts requests and returns valid JSON
- API documentation auto-generated (Swagger)
- API tests: >95% pass rate
- Latency: <500ms for typical request

---

### Week 9: Dashboard Integration (July 23-29)

**Goal:** Visualize adjusted forecasts in web UI

**Deliverables:**
- [ ] React component for adjusted forecasts
- [ ] Dashboard settings panel
- [ ] Performance comparison view
- [ ] Mobile-responsive design

**Key Activities:**
1. Create `AdjustedForecastChart.tsx` component
   - Display raw forecast (line 1)
   - Display adjusted forecast (line 2)
   - Show uncertainty bands
   - Legend with MAE values
2. Adjuster settings panel:
   - Checkbox: "Apply error adjustment"
   - Slider: Confidence level (0-100%)
   - Info tooltip explaining adjuster
3. Performance comparison view:
   - Side-by-side MAE comparison
   - Improvement percentage
   - Charts showing where adjuster helps most
4. Responsive design (mobile/tablet/desktop)
5. User experience testing

**Success Criteria:**
- Component integrates with existing dashboard
- Settings persist (localStorage)
- Charts render correctly with test data
- Mobile view passes responsive design test
- No console errors/warnings

---

### Week 10: Testing & Optimization (July 30 - August 5)

**Goal:** Comprehensive testing and performance tuning

**Deliverables:**
- [ ] Unit test suite >90% coverage
- [ ] Integration tests covering all flows
- [ ] Performance optimizations applied
- [ ] Coverage report generated

**Key Activities:**
1. Write unit tests for TabPFN adjuster:
   - Initialization and configuration
   - Fitting and prediction
   - Edge cases (empty arrays, extreme values)
   - Feature scaling consistency
   - Model persistence (save/load)
2. Write integration tests:
   - Full pipeline with 5+ test sites
   - API endpoint with various inputs
   - Dashboard component rendering
3. Performance optimizations:
   - Profile inference time
   - Optimize feature engineering (vectorize)
   - Consider model quantization/pruning if needed
4. Stress testing:
   - Concurrent requests to API
   - Large batch predictions
   - Memory usage under load
5. Generate coverage report (target >90%)

**Success Criteria:**
- All tests passing
- Coverage report: >90%
- Zero critical bugs in test execution
- Performance overhead <5ms per prediction
- Stress test: handles 10+ concurrent requests

---

### Week 11: Documentation & Examples (August 6-12)

**Goal:** Complete documentation and examples

**Deliverables:**
- [ ] User guide (docs/adjuster-user-guide.md)
- [ ] Architecture documentation (docs/adjuster-architecture.md)
- [ ] Demo notebook (examples/adjuster_demo.ipynb)
- [ ] API documentation (auto-generated + manual)

**Key Activities:**
1. Write user guide (800+ words):
   - What is the adjuster?
   - How does it work (simplified)?
   - When should you use it?
   - Limitations and caveats
   - How to enable in API/Python/dashboard
2. Write architecture guide (600+ words):
   - How error analysis was done
   - Why TabPFN was chosen
   - Feature engineering details
   - Model training methodology
   - Integration points
3. Create demo notebook:
   - Load adjuster model
   - Generate example forecasts
   - Compare raw vs. adjusted
   - Show improvement metrics
4. API documentation:
   - Endpoint reference
   - Request/response examples
   - Error codes and handling
5. README updates:
   - Link to new documentation
   - Quick-start example

**Success Criteria:**
- Docs are clear to non-experts (peer review)
- Code examples are runnable
- API docs match actual implementation
- Demo notebook has >50 lines of explanation

---

### Week 12-13: Refinement & Buffer (August 13-27)

**Goal:** Polish implementation and prepare for submission

**Deliverables:**
- [ ] All feedback addressed
- [ ] Code review complete
- [ ] Final testing and bug fixes
- [ ] PR ready for merge
- [ ] Demo materials (video/presentation)

**Key Activities:**
1. Incorporate mentor and code review feedback
2. Fix any discovered bugs
3. Final test run across all platforms
4. Performance optimization (if time allows)
5. Documentation final pass
6. Create demo video (2-3 min):
   - Show adjuster in action
   - API usage example
   - Dashboard comparison view
7. Prepare final presentation:
   - Summary of work
   - Results and metrics
   - Lessons learned
   - Future work opportunities
8. Final PR submission to main repository

**Success Criteria:**
- Zero outstanding issues (or documented for future)
- PR approved by maintainers
- Demo materials created
- Ready for merge/release

---

## Expected Outcomes & Impact

### Quantitative Results

| Metric | Target | Expected |
|--------|--------|----------|
| **MAE Improvement** | 10% | 12-15% |
| **Test Coverage** | >90% | >92% |
| **Code Quality** | No linting errors | 0 issues |
| **Documentation** | >10 pages | 15+ pages |
| **Commits** | 30+ | 40+ |
| **Response Time** | <500ms | <400ms |

### Qualitative Impact

1. **For Users:**
   - More accurate solar forecasts
   - Better decision-making for energy dispatch
   - Improved grid stability

2. **For OCF:**
   - Demonstrates ML enhancement capabilities
   - Provides foundation for future error adjusters
   - Increases Quartz project adoption

3. **For the Industry:**
   - Shows feasibility of learned error adjustment
   - Provides open-source reference implementation
   - Contributes to renewable energy reliability

4. **For GSoC Community:**
   - Complete example of ML system integration
   - Best practices for production code
   - Reusable patterns for similar projects

---

## About the Contributor

**Zakir Jiwani**
- **GitHub:** github.com/zakirjiwani
- **Email:** [Your email]
- **Location:** [Your location], [Your timezone]
- **Availability:** Full-time during GSoC period

### Technical Background

**Programming:**
- Python (5+ years) — Primary language, comfortable with NumPy/Pandas/scikit-learn
- JavaScript/TypeScript (3+ years) — React experience, can contribute to frontend
- Data science — Experience with ML pipelines, model evaluation, feature engineering

**Relevant Technologies:**
- PyTorch, scikit-learn, XGBoost — ML frameworks
- FastAPI — REST API development
- React — Frontend development
- Git/GitHub — Version control and collaboration

### Climate & Energy Interest

[Brief personal statement on why you care about climate/renewable energy]

Example: "I'm deeply committed to climate action. Solar energy is critical infrastructure for decarbonization, and better forecasting directly enables higher penetration of renewables on the grid. Open Climate Fix's mission resonates with my values."

### Relevant Experience

- **Project 1:** [Past project showing relevant skills]
- **Project 2:** [Another relevant project]
- **Open Source:** [Any prior open-source contributions]

### Why This Project?

1. **Strong technical fit** — Python, ML, full-stack integration
2. **Clear impact** — Directly improves forecast accuracy
3. **Learning opportunity** — Deep dive into production ML systems
4. **Community alignment** — Shares OCF's climate mission

---

## Why Open Climate Fix?

### Organization Mission Alignment

Open Climate Fix is using AI/ML to help humanity mitigate climate change. Solar forecasting is critical infrastructure for:
- Grid stability as renewable penetration increases
- Cost-effective energy storage deployment
- Demand-side management and load balancing

Better forecasts = more renewable energy on the grid = less carbon emissions.

### Project Quality

The Quartz Solar Forecast project is:
- Well-maintained with active community
- Production-grade code quality
- Published research backing the approach
- Real-world impact (already deployed)
- Welcoming to new contributors

### Mentorship Opportunity

Working with OCF provides:
- Access to climate tech experts
- Understanding of renewable energy systems
- Professional guidance on production ML systems
- Network in climate tech community

---

## Risk Assessment & Mitigation

### Identified Risks

| Risk | Likelihood | Mitigation |
|------|-----------|-----------|
| TabPFN too complex | Medium | Start with linear adjuster, escalate if time allows |
| Accuracy improvement <10% | Medium | Explore ensemble methods, feature engineering |
| API integration challenges | Low | Break into smaller pieces, test early/often |
| Dashboard scope too large | Medium | MVP first (simple chart), enhance later |
| Mentorship unavailable | Low | OCF committed to GSoC, clear escalation path |

### Contingency Plans

**If TabPFN training struggles:**
- Pivot to simpler approach: Linear regression on residuals
- Use AutoML for automatic hyperparameter tuning
- Ensemble multiple models

**If accuracy improvement is low:**
- Investigate feature importance (SHAP values)
- Add domain-specific features (PV model parameters)
- Consider separate adjusters per climate zone

**If timeline slips:**
- Prioritize core adjuster first
- Dashboard is stretch goal
- Focus on production-ready code over feature completeness

---

## Long-Term Vision

### Post-GSoC Contributions

1. **Maintenance** — Monitor adjuster, respond to user issues
2. **Enhancements** — Time-series ensemble, zone-specific adjusters
3. **Research** — Publish results, explore advanced techniques
4. **Mentorship** — Help future GSoC candidates

### Broader Opportunities

- Apply error adjustment to other OCF projects
- Explore ensemble methods combining multiple adjusters
- Investigate causal inference for error understanding
- Contribute to industry standards for forecast error quantification

---

## Conclusion

The proposed "Adjuster This! TabPFN for Solar Forecast Error Adjustment" project is:

✅ **Technically feasible** — Clear architecture, proven methods, realistic timeline

✅ **High impact** — 10-15% accuracy improvement benefits grid operators and renewable energy companies

✅ **Well-scoped** — Achievable in 13 weeks with clear deliverables

✅ **Aligned with OCF** — Advances the Quartz project and mission

✅ **Educational** — Deep learning in production ML systems, renewable energy context

I'm excited about the opportunity to contribute meaningfully to climate action through better solar forecasting. I'm committed to producing high-quality, well-tested, documented code that benefits the OCF community and the broader solar energy ecosystem.

---

## Appendix A: Reference Materials

### Papers & Research

- **TabPFN:** "Prior Functions for Predicting with Tabular Data" (arxiv.org/abs/2207.01152)
- **Quartz Solar Forecast:** [Published research papers, if any]
- **Renewable Energy Forecasting:** [Relevant survey papers]

### Documentation References

- OCF GitHub: github.com/openclimatefix
- Main Repo: github.com/openclimatefix/open-source-quartz-solar-forecast
- Contributing Guide: In repository (CONTRIBUTING.md)
- Architecture: See ARCHITECTURE.md (in this proposal directory)

### Tools & Libraries

- **TabPFN:** pip install tabpfn
- **Testing:** pytest, pytest-cov
- **Frontend:** React 18+, TypeScript
- **Backend:** FastAPI, Pydantic

---

## Appendix B: Project Proposal Submission Checklist

Before submitting to GSoC, verify:

- [ ] Proposal is 3000-5000 words
- [ ] Timeline is realistic and detailed
- [ ] Deliverables are specific and measurable
- [ ] Technical approach is sound
- [ ] Risk mitigation is addressed
- [ ] Learning outcomes are clear
- [ ] Passion for the project/mission is evident
- [ ] Mentor contact information included
- [ ] Background and experience demonstrated
- [ ] Proof of prior engagement with OCF (contributions, discussions)

---

**Last Updated:** March 18, 2026
**Proposal Status:** Draft - Ready for Mentor Review
**Expected Submission:** Early April 2026
