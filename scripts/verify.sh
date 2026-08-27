#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

required=(
  README.md
  OPEN_PROBLEM.md
  ISSUE_BODY.md
  PhysicalNonDefinability.lean
  EVIDENCE_LEDGER.md
  STRUCTURAL_CONVERGENCE.md
  ROLE_CORRESPONDENCE_MATRIX.md
  SENSITIVITY_AND_LIMITATIONS.md
  paper/OPH_Bare_Screen_Closure_Audit.pdf
)
for file in "${required[@]}"; do
  test -f "$file" || { echo "missing $file"; exit 1; }
done

python3 scripts/compute_structural_convergence.py

if rg -n '\b(sorry|admit)\b' -g '*.lean' .; then
  echo 'Lean placeholder found'
  exit 1
fi

# Public anonymity gate. The pattern itself is excluded from this scan.
if rg -n -i \
  'Joseph[[:space:]]+Shields|joseph-shields|J[.]?[[:space:]]+Shields|family-names:[[:space:]]*Shields' \
  . -g '!scripts/verify.sh' -g '!MANIFEST.sha256'; then
  echo 'personal author identity leaked'
  exit 1
fi

if test -f MANIFEST.sha256; then
  sha256sum -c MANIFEST.sha256
fi

if command -v lake >/dev/null 2>&1; then
  lake build
else
  echo 'lake absent locally; GitHub Actions will run the pinned Lean build'
fi

echo 'OK: package verified'
