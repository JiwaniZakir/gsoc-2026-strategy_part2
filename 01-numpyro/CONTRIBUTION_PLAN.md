# numpyro — Aggressive 5-Day Contribution Plan (Mar 19–23)

**Target: 10–12 PRs in 5 days | Goal: Become a recognizable contributor before proposal**

## Day 1 — March 19: Setup + First PR

### Morning (07:00–10:00): Environment Setup
```bash
git clone https://github.com/pyro-ppl/numpyro
cd numpyro
pip install -e ".[dev]"
pip install jax jaxlib
python -c "import numpyro; print(numpyro.__version__)"
pytest tests/ -x --tb=short -q  # Confirm tests pass
```

### PR #1 (10:00–13:00): Tutorial Notebook — Issue #189
**Target:** Add a user-contributed example notebook on a practical topic
- Bayesian linear regression with uncertainty quantification
- Add to `docs/source/examples/` or `notebooks/`
- Include posterior predictive checks and visualization
- Validate with pytest-nbval or by running notebook

**Why:** Easy entry, the maintainers explicitly asked for this, demonstrates ability to write Bayesian code.

```bash
# After writing notebook:
git checkout -b add-bayesian-lr-tutorial
git add docs/source/examples/bayesian_linear_regression.ipynb
git commit -m "docs: add Bayesian linear regression tutorial with uncertainty quantification"
gh pr create --title "docs: add Bayesian linear regression tutorial" \
  --body "Closes #189 — adds a practical tutorial showing posterior predictive checks and visualization using NUTS."
```

### Afternoon (13:00–16:00): Community Intro
- Post in GitHub Discussions: introduce yourself, mention existing PR, ask about GSoC 2026 mentorship
- Check Pyro forum for active threads to engage with

---

## Day 2 — March 20: Issue #1872 — CatTransform

### PR #2: Support constraints.cat and CatTransform
**Target:** Implement `constraints.cat` and `CatTransform` in `numpyro/distributions/constraints.py`

**Approach:**
1. Read `numpyro/distributions/constraints.py` — understand existing constraint/transform pattern
2. Study `CatTransform` in Pyro (torch-based) as reference implementation
3. Implement JAX-compatible version:
```python
class CatTransform(Transform):
    """Concatenation transform for multiple distributions."""
    def __init__(self, transforms, dim=-1):
        self.transforms = transforms
        self.dim = dim

    def __call__(self, x):
        # split along dim, apply each transform, concatenate
        ...

    def _inverse(self, y):
        ...

    def log_abs_det_jacobian(self, x, y):
        ...
```
4. Add corresponding `constraints.cat` constraint
5. Write tests in `tests/test_distributions.py`

```bash
git checkout -b feat/cat-transform-constraint
# implement + test
gh pr create --title "feat: add CatTransform and constraints.cat" \
  --body "Closes #1872 — implements CatTransform for concatenated distributions with full test coverage."
```

---

## Day 3 — March 21: Issue #810 — Weighted Statistics

### PR #3: Weighted statistics in `summary` diagnostics
**Target:** Extend `numpyro.diagnostics.summary()` to support importance weights

**Approach:**
1. Read `numpyro/diagnostics.py` — find `summary()` function
2. Identify where mean/std/quantiles are computed (currently unweighted)
3. Add `weights` parameter; use `jnp.average()` for weighted mean/variance
4. Compute weighted quantiles via sort + cumsum approach
5. Update docstring and add test with known weighted distribution

**Code sketch:**
```python
def summary(samples, prob=0.9, group_by_chain=True, weights=None):
    """
    ...
    :param weights: Optional importance weights for each sample.
    """
    # if weights provided, use weighted statistics
    ...
```

### Also Day 3: Start GSoC Proposal Draft
- Begin `PROPOSAL_DRAFT.md` outline
- Post proposal title in GitHub Discussions, ask for mentor feedback

---

## Day 4 — March 22: Issue #1623 — Batched scale_tril

### PR #4: Batched scale_tril support
**Target:** Fix batching logic for `scale_tril` parameter in multivariate distributions

**Approach:**
1. Identify where `scale_tril` is used in `numpyro/distributions/multivariate.py`
2. Reproduce the batching failure with a minimal test case
3. Fix using `jnp.broadcast_to` or correct batch-dimension handling
4. Add regression test

### Afternoon: Engage Mentors
- Comment on GSoC-relevant issues with your proposal concept
- Ask specific technical question in Discussions (shows depth, not just surface contributions)

---

## Day 5 — March 23: Polish + Substantial PR

### PR #5: More complete diagnostic improvements OR documentation fix
**Target:** Either:
- Fix any open diagnostic/sampling issue found while working on #810
- Add missing docstrings/examples to a frequently-used API
- Fix a reproducibility issue (issue #1616 — GMM MCMC not reproducible)

### Final Steps
- Respond to all outstanding PR review comments
- Ensure all 4–5 PRs are in "ready for review" state (not draft)
- Complete proposal draft to 80%

---

## March 24: Proposal Submission

- Submit final proposal to GSoC platform
- Thank mentors by name in submission
- Post contribution summary in GitHub Discussions

---

## PR Summary Table

| Day | PR | Issue | Type | Effort |
|-----|-----|-------|------|--------|
| Mar 19 | #1 | #189 | Tutorial notebook | Low |
| Mar 20 | #2 | #1872 | Feature: CatTransform | Medium |
| Mar 21 | #3 | #810 | Feature: weighted stats | Medium |
| Mar 22 | #4 | #1623 | Bug: batched scale_tril | Medium |
| Mar 23 | #5 | #1616 or docs | Bug fix / docs | Low-Med |

**Target: 5 PRs in 5 days. Goal is quality over quantity — 92.9% merge rate means each PR has a real shot.**

---

## AI-Assisted PR Workflow

```
1. Claude reads the target file + relevant test file
2. Claude identifies the exact change needed
3. Claude writes implementation + tests
4. Zakir reviews for correctness and natural Python style
5. Zakir runs tests locally to confirm
6. Submit PR with detailed body explaining the "why"
```

**Do NOT submit AI-generated code without verifying tests pass locally.**
