# Sensitivity, robustness and limitations

## Weight-independent direction

The numerical magnitudes depend on the published coding and weights. The **direction** of the coded trend does not: every role presence value is non-decreasing across S0-S6. For any non-negative role weights `a_v`,

```text
C(t) = sum_v a_v x_t(v) / sum_v a_v
```

is non-decreasing whenever `x_t(v) <= x_(t+1)(v)` for every role. The verification script checks this cell by cell. Thus any positive reweighting preserves the direction of the coded convergence; it can only alter magnitude.

## Threshold counts

The package also reports unweighted counts of high-probative roles and edges above thresholds 0.50, 0.75, 0.90 and 1.00 in `data/sensitivity_counts.csv`. These provide a simple check that the trend is not an artifact of decimal weighting.

## What remains subjective

The role selection and 0-1 presence coding are human judgments. They are exposed rather than hidden. A critic can change any value and rerun the script. The score is not a probability, legal test, plagiarism detector or causal estimator.

## Missing public evidence

The anonymous package does not publish private access records or unredacted source documents. Hashes establish artifact identity, not delivery time. The conceptual-ancestry question therefore remains separate from the public technical no-go.

## Alternative explanations

Independent convergence, audit-responsive research, indirect influence, shared AI training/context and deliberate unattributed borrowing are different causal hypotheses. The public chronology alone does not decide among them. The requested dated ancestry/AI-context disclosure is the appropriate discriminating evidence.

## Negative controls

Generic Born-rule, Lorentz/3D, broad Yukawa/mixing and ordinary A5/golden structure are retained as low-weight controls because OPH has documented earlier antecedents or standard mathematical routes.
