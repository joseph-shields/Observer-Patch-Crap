#!/usr/bin/env bash
set -euo pipefail

COMMIT="40b13bb4bc56261f84fd515701916c388c42fe83"
EXPECTED_SCRIPT_SHA="4cd1bcdcc491b7d50cc7c06d42af83dc3dca668b7b4cba8f63c704bb4a64244c"
WORK="${TMPDIR:-/tmp}/oph-theorem-count-$COMMIT"

rm -rf "$WORK"
git clone --quiet https://github.com/FloatingPragma/observer-patch-holography.git "$WORK"
git -C "$WORK" checkout --quiet "$COMMIT"

ACTUAL_SCRIPT_SHA=$(sha256sum "$WORK/tools/check_lean_theorem_count.py" | awk '{print $1}')
if [[ "$ACTUAL_SCRIPT_SHA" != "$EXPECTED_SCRIPT_SHA" ]]; then
  echo "Counting-script hash mismatch:" >&2
  echo " expected: $EXPECTED_SCRIPT_SHA" >&2
  echo " actual:   $ACTUAL_SCRIPT_SHA" >&2
  exit 1
fi

printf 'Lean source files under Lean/: '
find "$WORK/Lean" -type f -name '*.lean' | wc -l
python "$WORK/tools/check_lean_theorem_count.py"
