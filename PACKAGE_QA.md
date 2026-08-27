# Package quality-assurance report

Generated: 26 August 2026  
Public identity mode: anonymous  
Frozen OPH comparison head: `05207466cf63461c683bf1b8543d7c4a5feea4fa`

## Repository completeness

The repository includes:

- a GitHub-ready README and issue body;
- the full LaTeX article and compiled PDF;
- the Lean 4 no-go kernel;
- the Mr Tickle reductio, No Semantic Alchemy and holographic-typing notes;
- theorem-volume, rebuttal and resolution matrices;
- a version-locked public commit ledger;
- an anonymized prior-artifact hash ledger;
- role definitions, dependency edges, snapshot coding and score tables in JSON/CSV;
- deterministic structural-convergence figures;
- reproduction and verification scripts;
- a pinned Lean toolchain and GitHub Actions workflow;
- public/private evidence-custody rules;
- CC BY 4.0 terms for prose/original figures and MIT terms for code.

TOML, JSON, YAML and CFF configuration files parsed successfully. Shell scripts passed `bash -n`.

## Public anonymity gate

A recursive scan excludes the verification script's own test pattern and rejects the withheld author's full-name, username, abbreviated-name and CFF-surname forms. No matching personal author identity remains in the public repository or extracted paper text. Unredacted source originals, private messages and access evidence are intentionally absent.

## Lean source

- File: `PhysicalNonDefinability.lean`
- SHA-256: `f8b95243fa10373a3db894af879c8abd5cbb95c5663a593aa85f852f52bec327`
- Public `theorem`/`lemma` declarations: **26**
- `sorry`/`admit` placeholders: **0**
- Pinned toolchain: `leanprover/lean4:v4.33.1`

The kernel includes:

- `no_semantic_alchemy`;
- `no_source_only_enrichment_spawns_physics`;
- `physical_distinction_blocks_public_factorization`;
- `same_screen_distinct_boundary_theories_refute_screen_selector`;
- `same_screen_different_bulk_refutes_bare_screen_holography`;
- `mr_tickle_screen_reductio`;
- count-independent theorem-family discrimination results and concrete 5,000 / 8,400 / 8,449 / 8,800 corollaries.

No Lean executable was available in the packaging environment, so no local kernel-compilation claim is made. GitHub Actions is configured to run `lake build` and the repository verification script on push and pull request.

## Article build

- LaTeX source: `paper/OPH_Bare_Screen_Closure_Audit.tex`
- LaTeX SHA-256: `64384bfee09052497368b2bf2882b7cd138c6b977ab3e5c5bab1b181aa960cef`
- PDF: `paper/OPH_Bare_Screen_Closure_Audit.pdf`
- PDF SHA-256: `8d1f69fccaef7e8e3fc7f75b309b52d40381317b2f133772371399b3322df652`
- Pages: **34**
- Page size: A4
- Encrypted: no
- Forms/XFA/JavaScript: none
- Fonts: embedded
- Deterministic rebuild: identical PDF SHA-256 across two consecutive builds with a fixed source date

Final LaTeX diagnostics contain:

- zero unresolved references or citations;
- zero overfull boxes;
- one non-fatal microtype footnote-patch warning;
- two underfull boxes in bibliography material.

Ghostscript interpreted every page successfully with the null device. `pdfinfo`, `pdffonts`, PyMuPDF inspection and the project PDF preflight script all passed. `qpdf` was not installed and is therefore not claimed as an executed check.

All 34 pages rendered at 150 dpi. A full contact sheet and the title, structural-convergence and final-reference pages were inspected at full size. No clipping, overlap, black squares or broken glyphs were observed. The final deterministic rebuild was pixel-identical to the prior inspected render.

The Mr Tickle figure is an original long-armed schematic used for criticism/reductio. No official *Mr. Men* artwork is reproduced.

Detailed build outputs are stored under `evidence/build/`.

## Structural-convergence ledger

The score script reproduces `data/alignment_scores.json` exactly. Frozen probative scores are:

| Snapshot | Probative role alignment | Probative edge alignment |
|---|---:|---:|
| S0 | 0.125821 | 0.089543 |
| S1 | 0.459232 | 0.406447 |
| S2 | 0.813042 | 0.757571 |
| S3 | 0.888218 | 0.842016 |
| S4 | 0.900188 | 0.854168 |
| S5 | 0.950826 | 0.922151 |
| S6 | 0.954725 | 0.928246 |

Every coded role is non-decreasing across the frozen snapshot sequence. Consequently every positive reweighting preserves the direction of the aggregate trend; weights change magnitude, not trend sign. This is an arithmetic property of the published coding, not evidence that the coding is uniquely correct.

The figures regenerate deterministically under:

```bash
python3 scripts/compute_structural_convergence.py --write-figures
```

The ledger explicitly states that these values are auditor-coded alignment indices, not plagiarism probabilities, legal conclusions or estimates of subjective intent.

## Evidence discipline

The package distinguishes:

1. **direct public fact** - immutable commit metadata or quoted public source;
2. **technical theorem** - a formal consequence of stated premises;
3. **auditor coding** - a published functional-role judgment open to cell-level correction;
4. **structural inference** - an interpretation of the frozen chronology;
5. **unresolved private evidence** - access or transmission records retained outside the public repository.

Known contrary evidence is preserved. Generic Born-rule, Lorentz/3D, broad Yukawa/mixing and ordinary icosahedral/golden mathematics are down-weighted or excluded as standalone provenance evidence.

The repository does not allege theft, plagiarism, fraud or subjective intent. It proves a source-to-physics no-go and asks for a dated conceptual-ancestry account or disclosure of material external influence.

## Reproduction status

The public verification command is:

```bash
bash scripts/verify.sh
```

It checks required files, score arithmetic, monotonicity, Lean placeholders, public anonymity and the final SHA-256 manifest. It runs `lake build` when Lean is available; otherwise it reports that CI will perform the build.
