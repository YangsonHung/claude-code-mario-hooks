#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_dir"

required_sounds=(
  smb_pipe.wav
  smb_gameover.wav
  smb_coin.wav
  smb_jump-small.wav
  smb_stomp.wav
  smb_powerup.wav
  smb_stage_clear.wav
  smb_flagpole.wav
  smb_warning.wav
)

command -v curl >/dev/null 2>&1 || { echo "Missing curl" >&2; exit 1; }
if [[ "$(uname -s)" == "Darwin" ]]; then
  command -v afplay >/dev/null 2>&1 || { echo "Missing afplay" >&2; exit 1; }
fi

for sound in "${required_sounds[@]}"; do
  [[ -s "sounds/$sound" ]] || { echo "Missing required sound: sounds/$sound" >&2; exit 1; }
done

./scripts/render-settings.sh | python3 -m json.tool >/dev/null

git check-ignore sounds/smb_coin.wav >/dev/null || { echo "sounds/*.wav is not ignored by git" >&2; exit 1; }

./scripts/play-sound.sh smb_coin.wav

echo "OK: install verified. If your audio is on, you should hear a coin sound."
