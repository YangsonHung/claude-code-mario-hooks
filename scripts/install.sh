#!/usr/bin/env bash
set -euo pipefail

readonly PROJECT_ARCHIVE_URL="${CLAUDE_CODE_MARIO_HOOKS_ARCHIVE_URL:-https://github.com/YangsonHung/claude-code-mario-hooks/archive/refs/heads/main.tar.gz}"
readonly DEFAULT_INSTALL_DIR="$HOME/.claude/claude-code-mario-hooks"

SCRIPT_PATH="${BASH_SOURCE[0]:-$0}"
INSTALL_DIR="${CLAUDE_CODE_MARIO_HOOKS_DIR:-$DEFAULT_INSTALL_DIR}"
OUTPUT_PATH=""
FORCE=false
REQUIRED_ONLY=true

usage() {
  cat <<'EOF'
Usage:
  ./scripts/install.sh [options]
  curl -fsSL https://raw.githubusercontent.com/YangsonHung/claude-code-mario-hooks/main/scripts/install.sh | bash
  curl -fsSL https://raw.githubusercontent.com/YangsonHung/claude-code-mario-hooks/main/scripts/install.sh | bash -s -- --dir ~/.claude/claude-code-mario-hooks

Options:
  --dir DIR       Install directory for curl mode. Defaults to ~/.claude/claude-code-mario-hooks.
  --output FILE   Generated settings JSON path. Defaults to ./claude-settings.generated.json.
  --all-sounds    Download every sound in manifest/sounds.tsv, not just required sounds.
  --force         Re-download sound files even if they already exist.
  --help          Show this help.
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dir)
        [[ $# -ge 2 ]] || { echo "Missing value for --dir" >&2; exit 1; }
        INSTALL_DIR="$2"
        shift 2
        ;;
      --output)
        [[ $# -ge 2 ]] || { echo "Missing value for --output" >&2; exit 1; }
        OUTPUT_PATH="$2"
        shift 2
        ;;
      --all-sounds)
        REQUIRED_ONLY=false
        shift
        ;;
      --force)
        FORCE=true
        shift
        ;;
      --help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown option: $1" >&2
        usage >&2
        exit 1
        ;;
    esac
  done
}

# Pipe execution has no reliable script file path, so it must bootstrap first.
is_pipe_mode() {
  [[ "$SCRIPT_PATH" == "bash" || "$SCRIPT_PATH" == "sh" || "$SCRIPT_PATH" == "-bash" || "$SCRIPT_PATH" == "-sh" || "$SCRIPT_PATH" == "/dev/fd/"* || ! -f "$SCRIPT_PATH" ]]
}

find_repo_dir() {
  if is_pipe_mode; then
    echo ""
    return
  fi

  local script_dir
  script_dir="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
  if [[ -f "$script_dir/../manifest/sounds.tsv" ]]; then
    cd "$script_dir/.." && pwd
  else
    echo ""
  fi
}

# Download the repository archive, then run this same installer from the real project directory.
bootstrap_from_archive() {
  local target="$1"
  shift

  if [[ -x "$target/scripts/install.sh" ]]; then
    echo "Using existing installation: $target"
    "$target/scripts/install.sh" "$@"
    return
  fi

  if [[ -e "$target" ]]; then
    echo "Install directory exists but does not look like this project: $target" >&2
    echo "Choose another directory with --dir, or remove that directory first." >&2
    exit 1
  fi

  local tmp_dir cleanup_cmd extracted
  tmp_dir="$(mktemp -d)"
  cleanup_cmd="rm -rf '$tmp_dir'"
  trap "$cleanup_cmd" EXIT

  echo "Downloading project archive..."
  curl -fL --retry 3 "$PROJECT_ARCHIVE_URL" | tar -xz -C "$tmp_dir"

  extracted="$(find "$tmp_dir" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
  [[ -n "$extracted" ]] || { echo "Failed to unpack project archive." >&2; exit 1; }

  mkdir -p "$(dirname "$target")"
  mv "$extracted" "$target"

  echo "Installed project to: $target"
  "$target/scripts/install.sh" "$@"
}

check_dependencies() {
  command -v curl >/dev/null 2>&1 || { echo "Missing dependency: curl" >&2; exit 1; }
  if [[ "$(uname -s)" == "Darwin" ]]; then
    command -v afplay >/dev/null 2>&1 || { echo "Missing dependency: afplay" >&2; exit 1; }
  fi
}

# Download and rename each remote WAV to the event-prefixed local filename in manifest/sounds.tsv.
download_sounds() {
  local manifest="$1"
  local sounds_dir="$2"

  mkdir -p "$sounds_dir"
  tail -n +2 "$manifest" | while IFS=$'\t' read -r filename url required; do
    if [[ "$REQUIRED_ONLY" == true && "$required" != true ]]; then
      continue
    fi

    local target="$sounds_dir/$filename"
    if [[ -s "$target" && "$FORCE" != true ]]; then
      echo "Skip existing: $filename"
      continue
    fi

    echo "Download: $filename"
    curl -fL --retry 3 --output "$target" "$url"
  done
}

settings_root_for_install_dir() {
  local install_dir="$1"
  if [[ "$install_dir" == "$HOME"/* ]]; then
    printf '$HOME/%s\n' "${install_dir#"$HOME"/}"
  else
    printf '%s\n' "$install_dir"
  fi
}

# Render the Claude Code settings template with a shell-expandable path.
generate_settings() {
  local template="$1"
  local settings_root="$2"
  local output="$3"

  mkdir -p "$(dirname "$output")"
  while IFS= read -r line || [[ -n "$line" ]]; do
    printf '%s\n' "${line//\{\{INSTALL_DIR\}\}/$settings_root}"
  done < "$template" > "$output"
  echo "Generated: $output"
}

# Verify sound files, generated settings content, gitignore behavior when applicable, and a sample playback.
verify_install() {
  local source_dir="$1"
  local install_dir="$2"
  local manifest="$3"
  local settings_file="$4"

  tail -n +2 "$manifest" | while IFS=$'\t' read -r filename _url required; do
    if [[ "$required" == true && ! -s "$install_dir/sounds/$filename" ]]; then
      echo "Missing required sound: sounds/$filename" >&2
      exit 1
    fi
  done

  [[ -s "$settings_file" ]] || { echo "Generated settings file is empty: $settings_file" >&2; exit 1; }
  if grep -q '{{INSTALL_DIR}}' "$settings_file"; then
    echo "Generated settings still contains template placeholder: {{INSTALL_DIR}}" >&2
    exit 1
  fi
  grep -q '"hooks"' "$settings_file" || { echo "Generated settings does not contain a hooks block." >&2; exit 1; }

  afplay "$install_dir/sounds/03_UserPromptSubmit_smb_coin.wav" >/dev/null 2>&1 &
}

fail() {
  local line="$1"
  echo "Install failed at line $line." >&2
  echo "Check the error above, then rerun: ./scripts/install.sh" >&2
  echo "Common fixes: install curl, run on macOS with afplay, or retry if a sound download failed." >&2
}

main() {
  parse_args "$@"

  local source_dir
  source_dir="$(find_repo_dir)"

  if [[ -z "$source_dir" ]]; then
    bootstrap_from_archive "$INSTALL_DIR" "$@"
    return
  fi

  trap 'fail $LINENO' ERR

  mkdir -p "$(dirname "$INSTALL_DIR")"
  local install_dir="$(cd "$(dirname "$INSTALL_DIR")" && pwd)/$(basename "$INSTALL_DIR")"
  local settings_root
  settings_root="$(settings_root_for_install_dir "$install_dir")"
  local manifest="$source_dir/manifest/sounds.tsv"
  local template="$source_dir/templates/claude-settings.json"
  local output="${OUTPUT_PATH:-$install_dir/claude-settings.generated.json}"

  check_dependencies

  mkdir -p "$install_dir"

  echo "[1/3] Downloading sound files..."
  download_sounds "$manifest" "$install_dir/sounds"

  echo "[2/3] Generating Claude Code settings JSON..."
  generate_settings "$template" "$settings_root" "$output"

  echo "[3/3] Verifying installation..."
  verify_install "$source_dir" "$install_dir" "$manifest" "$output"

  cat <<EOF

Done.
Generated settings file:
  $output

Next:
  Copy the generated hooks block into ~/.claude/settings.json or a project's .claude/settings.json.
  In Claude Code, run /hooks to confirm the hooks are loaded.
EOF
}

main "$@"
