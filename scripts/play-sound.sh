#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <sound-file.wav>" >&2
  exit 2
fi

filename="$1"
if [[ "$filename" == *"/"* || "$filename" == *".."* || "$filename" != *.wav ]]; then
  echo "Invalid sound filename: $filename" >&2
  exit 2
fi

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
sound_path="$repo_dir/sounds/$filename"

if [[ ! -s "$sound_path" ]]; then
  echo "Sound file not found: $sound_path" >&2
  exit 1
fi

if ! command -v afplay >/dev/null 2>&1; then
  echo "afplay was not found. This script supports macOS by default; see README for Linux/Windows adaptation notes." >&2
  exit 1
fi

afplay "$sound_path" >/dev/null 2>&1 &
