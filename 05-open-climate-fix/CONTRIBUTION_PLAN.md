# Contribution Plan - Open Climate Fix GSoC 2026

## Overview

This document outlines a strategic 3-phase contribution plan for participating in Google Summer of Code 2026 with Open Climate Fix. The plan emphasizes building expertise, community relationship, and demonstrating impact before, during, and after GSoC.

---

## Phase 1: Pre-GSoC Engagement (Now - April 2026)

### Objective
Establish presence in the OCF community, understand the codebase, and build momentum through small, impactful contributions.

### Key Principle: Comment First, Code Second
**Critical Rule:** Open Climate Fix explicitly requires contributors to **comment on issues before starting work** to prevent duplicate efforts and ensure alignment with maintainers.

### Activity 1.1: Repository Familiarization

**Timeline:** Week 1-2

**Actions:**
1. Clone and set up the main repository locally
   ```bash
   git clone https://github.com/openclimatefix/open-source-quartz-solar-forecast.git
   cd open-source-quartz-solar-forecast
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   pip install -e ".[dev]"  # Development mode
   ```

2. Explore the directory structure
   - Navigate `/quartz_solar_forecast/` — understand package layout
   - Review `/api/` — FastAPI backend structure
   - Check `/examples/` — Jupyter notebooks for usage patterns
   - Examine `/tests/` — Test organization and patterns

3. Read key documentation
   - `README.md` — Overview
   - `CONTRIBUTING.md` — Community guidelines
   - `ARCHITECTURE.md` — System design (from ARCHITECTURE.md above)
   - `docs/` folder — Any existing documentation

4. Review 34 open issues to understand pain points
   - Filter by "good first issue" label
   - Examine issue descriptions for complexity and scope

5. Run existing tests to ensure local environment works
   ```bash
   pytest -v
   pytest --cov=quartz_solar_forecast
   ```

### Activity 1.2: "Good First Issue" Contributions

**Timeline:** Week 2-6 (staggered)

**Target Issues:** Start with these categories:

#### A. Documentation Improvements (Low Technical Barrier)
**Target Issue:** #34 and related accuracy documentation gaps

**Scope:**
- Document model performance metrics (MAE, RMSE, examples)
- Create "Getting Started" guide for new users
- Add docstrings to key functions in codebase

**Steps:**
1. Comment on the issue: "I'd like to help improve the accuracy documentation. I'm planning to add benchmark tables for each model and usage examples. Is this aligned with what's needed?"
2. Wait for maintainer approval
3. Create feature branch: `feature/accuracy-docs`
4. Add documentation in `/docs/` or in README sections
5. Submit PR with clear reference to the issue

**Why This First:**
- Low risk (no code breakage)
- Demonstrates understanding of the project
- Gives you time to study the codebase
- Improves community visibility

#### B. Timezone Handling Fixes (Medium Technical Barrier)
**Target Issue:** Open timezone edge cases (#15-20 range, estimated)

**Scope:**
- Identify timezone handling bugs (conversion errors, DST issues)
- Write test cases exposing the bugs
- Fix in `/quartz_solar_forecast/utils/timezone_utils.py`

**Steps:**
1. Comment: "I'm interested in fixing timezone handling edge cases. I've identified [specific cases] that need attention. Would this be a good starting point?"
2. Create test cases first (red-green refactor)
3. Create branch: `fix/timezone-edge-cases`
4. Implement fixes
5. Ensure all tests pass
6. Submit PR with test evidence

**Why This Next:**
- Builds coding confidence
- Relatively isolated changes
- Good review/feedback opportunity
- Relevant to production systems

#### C. Python 3.12 Compatibility (Medium-High Technical Barrier)
**Target Issue:** Python 3.12 support (#estimated 5-8)

**Scope:**
- Test codebase with Python 3.12
- Identify deprecation warnings
- Update dependencies (PyTorch, XGBoost, FastAPI versions)
- Fix any incompatibilities

**Steps:**
1. Comment: "I can help with Python 3.12 compatibility. I'm planning to [specific approach]. Is there a priority order for dependencies to update?"
2. Set up Python 3.12 locally
3. Run tests and capture warnings/errors
4. Create branch: `feature/python-3.12-compat`
5. Update `requirements.txt` and code
6. Run full test suite on 3.12
7. Submit PR

**Why This After Documentation/Timezone:**
- Requires higher Python expertise
- More risk of side effects
- Good for demonstrating testing discipline

### Activity 1.3: Community Engagement

**Timeline:** Concurrent with contributions

**Actions:**
1. **Comment thoughtfully on PRs/issues**
   - Read existing discussions
   - Ask clarifying questions (if helpful)
   - Offer to test PRs (if relevant to your expertise)
   - Be respectful and constructive

2. **Use GitHub Discussions**
   - Ask questions about architecture
   - Propose ideas (don't start PRs without feedback)
   - Help answer others' questions (build reputation)

3. **Monitor project updates**
   - Watch the repository for releases
   - Read merged PRs to understand patterns
   - Note what gets accepted/rejected (learn preferences)

4. **Email the team**
   - Send introductory email: quartz.support@openclimatefix.org
   - Mention GSoC interest, background, timezone issues work
   - Ask about mentorship availability
   - Ask for feedback on proposed GSoC project

### Activity 1.4: Project Proposal Development

**Timeline:** Week 6-8

**Objective:** Develop detailed GSoC proposal incorporating feedback

**Starting Point:** "Adjuster This! TabPFN for Solar Forecast Error Adjustment"

**Key Components:**
1. **Problem Statement**
   - Current forecast models have systematic errors
   - MAE of 0.19 kW (GB) and 0.12 kW (XGB) still significant
   - Error distributions vary by time of day, season, location

2. **Solution Approach**
   - Use TabPFN (TabNet Feature Preprocessing Network)
   - Learn to predict forecast residuals
   - Apply learned adjustments to raw forecasts
   - Integrate into API and dashboard

3. **Detailed Timeline** (See Phase 2 below)

4. **Deliverables**
   - Working adjuster model
   - API endpoint: `/forecast/adjusted`
   - Dashboard UI showing adjusted forecasts
   - Test suite with >90% coverage
   - Documentation and examples

5. **Learning Outcomes**
   - Deep understanding of error analysis
   - TabPFN/neural network implementation
   - Production ML deployment patterns

---

## Phase 2: GSoC Project (May - August 2026)

### Project: "Adjuster This! TabPFN for Solar Forecast Error Adjustment"

### Timeline

#### Week 1-2: Setup & Error Analysis (May 1-14)

**Deliverable:** Comprehensive error analysis report

**Activities:**
1. Set up development environment with all tools
2. Analyze forecast residuals across dataset
   - Identify systematic biases (time-of-day, seasonal patterns)
   - Quantify error distributions
   - Find correlations with input features (cloud cover, wind, etc.)
3. Create visualizations showing error patterns
4. Document findings in `/docs/error-analysis.md`

**Output:**
- Analysis notebook: `notebooks/01_error_analysis.ipynb`
- Report with plots and statistics
- Identified improvement opportunities

#### Week 3-4: TabPFN Model Development (May 15-28)

**Deliverable:** Baseline TabPFN adjuster model

**Activities:**
1. Collect training data (historical predictions + actuals)
2. Engineer features for TabPFN
   - Input: Raw forecast + NWP features
   - Output: Predicted error adjustment
3. Implement TabPFN model class
   ```python
   class TabPFNAdjuster(BaseModel):
       def __init__(self, config: dict):
           # Initialize TabPFN

       def fit(self, X_features, y_residuals):
           # Train adjuster

       def predict_adjustment(self, X_features) -> float:
           # Predict error adjustment
   ```
4. Train baseline model
5. Evaluate on test set (MAE reduction)

**Output:**
- `/quartz_solar_forecast/models/adjuster.py`
- Training notebook: `notebooks/02_tabpfn_training.ipynb`
- Model weights checkpoint

#### Week 5-6: Integration into Forecasting Pipeline (May 29 - June 11)

**Deliverable:** Adjusted forecast pipeline

**Activities:**
1. Create `AdjustedForecast` class
   ```python
   class AdjustedForecast:
       def __init__(self, raw_forecast, adjuster):
           self.raw = raw_forecast
           self.adjuster = adjuster

       def get_adjusted_predictions(self):
           # Apply adjustments to raw forecast
   ```
2. Modify `run_forecast()` to support adjustment
   ```python
   def run_forecast(
       site,
       model="gradient_boosting",
       apply_adjuster=True,  # NEW
       ...
   )
   ```
3. Add CI tests for adjusted pipeline
4. Benchmark: measure MAE reduction

**Output:**
- Modified `/quartz_solar_forecast/inference.py`
- Integration tests in `/tests/integration/test_adjuster.py`
- Benchmark report showing improvement

#### Week 7-8: FastAPI Endpoint Implementation (June 12-25)

**Deliverable:** `/forecast/adjusted` API endpoint

**Activities:**
1. Create API schema for adjusted forecasts
   ```python
   class AdjustedForecastRequest(BaseModel):
       site: SiteInfo
       apply_adjuster: bool = True
       confidence_level: float = 0.95

   class AdjustedForecastResponse(BaseModel):
       predictions: List[AdjustedPrediction]
       raw_predictions: List[Prediction]  # For comparison
       improvement_metrics: dict
   ```
2. Implement endpoint in `/api/routes/forecast.py`
3. Add comprehensive API documentation
4. Test with various input scenarios
5. Performance testing (latency, throughput)

**Output:**
- New endpoint: POST `/forecast/adjusted`
- API documentation in OpenAPI/Swagger
- API integration tests

#### Week 9: Dashboard Integration (June 26 - July 2)

**Deliverable:** Dashboard UI for adjusted forecasts

**Activities:**
1. Create React component: `AdjustedForecastChart.tsx`
   - Display both raw and adjusted predictions
   - Show improvement metrics
   - Allow toggling between forecasts
2. Integrate adjuster settings into dashboard
   - Checkbox: "Apply error adjustment"
   - Slider: Confidence level
3. Add performance comparison visualization
4. Responsive design (mobile-friendly)

**Output:**
- `/dashboards/src/components/AdjustedForecastChart.tsx`
- Adjuster settings panel component
- Dashboard screenshot/demo video

#### Week 10: Testing & Optimization (July 3-9)

**Deliverable:** Comprehensive test suite (>90% coverage)

**Activities:**
1. Unit tests for TabPFN adjuster
   - Test fitting, prediction, edge cases
2. Integration tests for full pipeline
   - Test with various sites, NWP sources
3. API endpoint tests
   - Valid/invalid requests
   - Response validation
4. Performance/load testing
5. Documentation of test patterns

**Output:**
- `/tests/unit/test_adjuster.py`
- `/tests/integration/test_adjuster_pipeline.py`
- `/tests/integration/test_adjuster_api.py`
- Coverage report (target >90%)

#### Week 11: Documentation & Examples (July 10-16)

**Deliverable:** Complete user and developer documentation

**Activities:**
1. User guide: How to use adjusted forecasts
   ```markdown
   # Using TabPFN Adjusted Forecasts
   ## What it is
   ## Benefits & Limitations
   ## How to enable
   ## Examples
   ```
2. Developer guide: How adjuster works
   - Architecture diagram
   - Model explanation
   - Training data requirements
3. API documentation
   - Endpoint reference
   - Request/response examples
   - Error handling
4. Jupyter notebook example
   - Load adjuster
   - Generate predictions
   - Visualize improvements

**Output:**
- `/docs/adjuster-user-guide.md`
- `/docs/adjuster-architecture.md`
- `/examples/adjuster_demo.ipynb`

#### Week 12-13: Refinement & Buffer (July 17-30)

**Deliverable:** Polish and handle edge cases

**Activities:**
1. Incorporate feedback from code reviews
2. Fix any discovered bugs
3. Performance optimization
4. Final documentation pass
5. Create demo video or presentation
6. Prepare final PR/submission

**Output:**
- Final working system
- Code review ready
- Demo materials

### Evaluation Criteria

By end of GSoC, achievement will be measured by:

1. **Code Quality** ✅
   - Passes linting (flake8, black)
   - Comprehensive tests (>90% coverage)
   - Clear documentation

2. **Functionality** ✅
   - Adjuster trains successfully
   - MAE improvement >5% (target: >10%)
   - Integrated into API and dashboard
   - No regression in baseline forecasts

3. **Community Impact** ✅
   - PRs merged into main repository
   - Documentation helps future users
   - Closes 5+ open issues

4. **Learning & Growth** ✅
   - Deep expertise in ML error analysis
   - Understanding of production ML systems
   - Comfortable contributing to mature projects

---

## Phase 3: Post-GSoC Engagement (September 2026+)

### Objective
Transition to sustainable, ongoing contribution. Become a trusted community member.

### Activity 3.1: Maintenance
- Monitor TabPFN adjuster for issues
- Support users with questions
- Keep dependencies updated

### Activity 3.2: Enhancement
- Collect user feedback on adjuster
- Propose improvements (uncertainty quantification, time-series ensemble)
- Contribute to related features

### Activity 3.3: Mentorship
- Help new GSoC candidates (2027+)
- Review PRs from community
- Write blog post about experience

### Activity 3.4: Research & Innovation
- Explore advanced error adjustment techniques
- Contribute to industry best practices
- Present at conferences if opportunities arise

---

## Contribution Best Practices

### Branch Naming Convention

OCF uses this naming scheme (from CONTRIBUTING.md):

```
feature/your-feature-name        # New feature
fix/issue-description            # Bug fix
docs/documentation-improvement   # Documentation
refactor/code-improvement        # Code refactoring
test/test-addition               # New tests
```

**Examples:**
- `feature/tabpfn-adjuster`
- `fix/timezone-dst-bug`
- `docs/accuracy-benchmarks`
- `test/adjuster-edge-cases`

### Commit Message Format

Clear, descriptive commit messages:

```
feat: Add TabPFN adjuster model training

- Implement TabPFN-based error adjustment
- Add training pipeline with validation splits
- Achieve 10% MAE reduction on test set

Closes #XXX
```

### PR Description Template

```markdown
## Description
Brief summary of changes

## Related Issue
Fixes #123

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation

## How Has This Been Tested?
Describe test coverage

## Checklist:
- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Commits are clear
```

### Code Review Expectations

**Before Submitting:**
1. Run `pytest` locally
2. Run linter: `flake8` and `black`
3. Check code coverage
4. Review your own PR first

**After Submitting:**
1. Respond promptly to feedback
2. Ask clarifying questions (don't assume)
3. Push updates as new commits (don't force-push during review)
4. Thank reviewers for their time

---

## Communication Templates

### Initial Contact Email

**To:** quartz.support@openclimatefix.org

```
Subject: GSoC 2026 Interest - Solar Forecast Error Adjustment

Hi OCF Team,

I'm [Your Name], a [background] developer interested in contributing to Open Climate Fix as part of Google Summer of Code 2026.

I've been exploring the Quartz Solar Forecast project and am particularly interested in improving forecast accuracy through error adjustment techniques. I've started contributing with [documentation/timezone fixes/Python 3.12 work], and would like to propose a GSoC project focused on:

"Adjuster This! TabPFN for Solar Forecast Error Adjustment"

The idea is to use TabPFN neural networks to learn and adjust systematic forecast errors, building on your existing GB/XGBoost models.

I'm [your timezone] and available for mentorship meetings [your availability]. Would you be open to discussing this project further?

Best regards,
[Your Name]
[GitHub profile]
```

### Issue Comment Before Starting Work

```markdown
I'd like to work on this issue. Here's my planned approach:

1. [Step 1]
2. [Step 2]
3. [Step 3]

I'm estimating this will take [X hours/days] and I plan to submit a PR by [date].

Is this aligned with what you had in mind? Any specific requirements or constraints I should be aware of?
```

### PR Submission Template

```markdown
## What
Implement TabPFN-based error adjuster for solar forecasts

## Why
Current models have systematic errors that could be reduced through learned adjustments

## How
- Trained TabPFN on forecast residuals
- Integrated into run_forecast() pipeline
- Added API endpoint and dashboard UI

## Testing
- Added 15 new unit tests (test_adjuster.py)
- Integration tests verify MAE improvement of 8%
- Tested on 3 sites with different capacities

Closes #123
```

---

## Risk Mitigation

### Potential Risks & Mitigation Strategies

| Risk | Likelihood | Mitigation |
|------|------------|-----------|
| Scope too large for 12 weeks | Medium | Break into phases, prioritize MVP first |
| TabPFN complexity higher than expected | Medium | Start with simpler approach (linear regressor), escalate if time allows |
| Lack of mentorship availability | Low | OCF is committed to GSoC; follow up proactively |
| Codebase changes during GSoC | Low | Regularly pull from main, use feature branches |
| Performance regression | Low | Comprehensive testing required; maintain baseline benchmarks |
| API/dashboard scope expansion | Medium | Deliver core adjuster first, UI enhancements are bonus |

### Escalation Path
1. **Week 2:** If TabPFN is too complex, pivot to linear residual adjustment
2. **Week 5:** If integration is stalled, focus on core model quality
3. **Week 8:** If dashboard work is bottleneck, simplify UI (CLI interface acceptable)

---

## Success Metrics

### Quantitative
- ✅ MAE improvement: >5% (target: >10%)
- ✅ Test coverage: >90%
- ✅ Code review: <3 rounds to approval
- ✅ Documentation: >10 pages of comprehensive guides
- ✅ Commits: >30 meaningful commits throughout GSoC

### Qualitative
- ✅ Positive feedback from maintainers
- ✅ Community engagement (issue comments, discussions)
- ✅ Clear code with good practices
- ✅ Production-ready quality
- ✅ Helpful documentation for future users

---

## Timeline Summary

```
Now (March 2026)        │ Phase 1: Pre-GSoC Engagement
                        │ - Setup & familiarization
                        │ - 3-4 small contributions
                        │ - Community engagement
                        │ - Proposal development
                        ↓
April 2026             │ GSoC Application Deadline
                        ↓
May 2026               │ Phase 2: GSoC Project
                        │ Week 1-13: TabPFN Adjuster
                        │ - Analysis → Development → Integration
                        │ - Weekly check-ins with mentors
                        ↓
August 30, 2026        │ GSoC Final Submission
                        ↓
September 2026+        │ Phase 3: Ongoing Contribution
                        │ - Maintenance & support
                        │ - Enhancement & innovation
```

---

## Resources

**Key Repositories:**
- Main: https://github.com/openclimatefix/open-source-quartz-solar-forecast
- API: https://github.com/openclimatefix/quartz-api
- Frontend: https://github.com/openclimatefix/quartz-frontend

**Documentation:**
- Organization: https://openclimatefix.org
- Contributing Guide: CONTRIBUTING.md in main repo
- Architecture: See ARCHITECTURE.md (in this directory)

**Learning Materials:**
- TabPFN: https://arxiv.org/abs/2207.01152 (research paper)
- Solar Forecasting: Recent papers on error adjustment
- FastAPI: https://fastapi.tiangolo.com/
- React: https://react.dev/

**Communication:**
- Email: quartz.support@openclimatefix.org
- GitHub: Issues and Discussions in repositories
