# Structural-convergence analysis

## What is measured

The unit is a **functional dependency role**, not a keyword. The prior corpus supplies a role graph: realization before physical promotion; records before quantitative closure; dynamics before action representation; admissible history before minimization; countermodels before uniqueness; premise ancestry and no-privilege promotion; retained observer history distinct from a bare index; explicit calibration gates and open-row custody.

Each OPH snapshot is manually coded on a 0-1 scale for visible role presence. Role weights and probative factors are frozen in `data/role_definitions.json`. Low-value generic overlaps are retained as controls.

## What is not measured

The score is not a plagiarism percentage, a probability of copying or a claim about intent. It is reproducible arithmetic conditional on the published coding. Disagreement should target a specific role, score, evidence item or weight.

## Results

| Snapshot | Commit | All roles | Probative roles | Controls excluded | Probative edges |
|---|---:|---:|---:|---:|---:|
| Pre-audit public baseline | `23c6a0ba` | 0.134 | 0.126 | 0.130 | 0.090 |
| Post-audit mechanics wave | `09d525fd` | 0.456 | 0.459 | 0.453 | 0.406 |
| V3 governance and physical-promotion wave | `1fe5063d` | 0.804 | 0.813 | 0.804 | 0.758 |
| Core-physics wave | `4bc014ab` | 0.877 | 0.888 | 0.877 | 0.842 |
| Compression-thesis flagship rewrite | `fe4c9579` | 0.890 | 0.900 | 0.890 | 0.854 |
| V3.33 force/speed/clock/golden wave | `864051be` | 0.939 | 0.951 | 0.939 | 0.922 |
| V3.34 proper-length clock/force/flow wave | `05207466` | 0.943 | 0.955 | 0.943 | 0.928 |

Under the frozen coding, probative-role alignment rises from **0.126** at the pre-audit baseline to **0.955** at V3.34; probative edge alignment rises from **0.090** to **0.928**. The increase is concentrated in mechanics/action ordering, governance, force/current/Hamiltonian gaps, observer clocks and open-row discipline rather than in excluded Born/Lorentz controls.

## Robustness

Every coded role is non-decreasing across the frozen snapshots. Hence every positive weighted role score is non-decreasing: weighting affects magnitude, not direction. Unweighted threshold counts are provided in `data/sensitivity_counts.csv`.

## Interpretation

The defensible public conclusion is architectural convergence through time. The calculation does not identify its cause. A dated conceptual-ancestry statement and AI-context disclosure are requested.

## Reproduction

Run `python3 scripts/compute_structural_convergence.py`.
