#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
HOOK="${1:-$HERE/../user-install/hooks/precheck.sh}"

bash -n "$HOOK"
python3 "$HERE/test_precheck.py" --no-danger "$HOOK"
