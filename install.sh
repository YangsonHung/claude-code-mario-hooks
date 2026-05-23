#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
manifest="$repo_dir/manifest/sounds.tsv"
sounds_dir="$repo_dir/sounds"
force=false
required_only=false

usage() {
  cat <<'EOF'
Usage: ./install.sh [--force] [--required-only] [--help]

Downloads sound files listed in manifest/sounds.tsv into ./sounds/.

Options:
  --force          Re-download files even if they already exist.
  --required-only  Download only files used by the default Claude Code hooks.
  --help           Show this help.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --force) force=true ;;
    --required-only) required_only=true ;;
    --help) usage; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; usage >&2; exit 1 ;;
  esac
done

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required but was not found." >&2
  exit 1
fi

mkdir -p "$sounds_dir"

tail -n +2 "$manifest" | while IFS=$'\t' read -r filename url required; do
  if [[ "$required_only" == true && "$required" != true ]]; then
    continue
  fi

  target="$sounds_dir/$filename"
  if [[ -s "$target" && "$force" != true ]]; then
    echo "Skip existing: $filename"
    continue
  fi

  echo "Download: $filename"
  curl -fL --retry 3 --output "$target" "$url"
done

cat <<'EOF'

Done.

Next:
  ./scripts/verify-install.sh
  ./scripts/render-settings.sh
EOF
