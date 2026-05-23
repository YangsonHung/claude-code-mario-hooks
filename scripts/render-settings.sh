#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
template="$repo_dir/templates/claude-settings.json"

python3 - "$template" "$repo_dir" <<'PY'
import json
import sys
from pathlib import Path

template = Path(sys.argv[1]).read_text()
repo_dir = sys.argv[2]
rendered = template.replace("{{REPO_DIR}}", repo_dir)
print(json.dumps(json.loads(rendered), indent=2))
PY
