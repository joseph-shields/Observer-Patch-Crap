# Reproduce

## Structural analysis

```bash
python3 scripts/compute_structural_convergence.py
```

This recomputes every score and verifies cellwise monotonicity without modifying tracked artifacts. Regenerate the deterministic chart explicitly with:

```bash
python3 scripts/compute_structural_convergence.py --write-figures
```

## Lean

```bash
lake build
```

The pinned toolchain is in `lean-toolchain`. GitHub Actions runs the same command and rejects `sorry`/`admit` placeholders.

## Full repository verification

```bash
bash scripts/verify.sh
```

This checks required files, recomputes the structural analysis, checks anonymity, scans the Lean source for placeholders and verifies the SHA-256 manifest.

## Paper

From `paper/`:

```bash
latexmk -pdf -interaction=nonstopmode -halt-on-error OPH_Bare_Screen_Closure_Audit.tex
```
