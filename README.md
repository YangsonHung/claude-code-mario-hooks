# claude-code-mario-hooks

English | [简体中文](README.zh-CN.md)

Claude Code hook sound templates that play classic SMB-style WAV files for common Claude Code lifecycle events.

This project is macOS-first and uses `afplay` by default. It does not bundle any Nintendo or Mario sound files in the repository; the install script downloads sound files at setup time.

## Legal notice

This repository does **not** include Nintendo, Mario, or Super Mario audio assets.

The MIT license in this repository applies only to the code, scripts, templates, and documentation authored for this project. Sound files downloaded by `install.sh` come from third-party sources and remain the property of their respective owners. You are responsible for complying with applicable laws and third-party terms when downloading or using those assets.

## Features

- Full 9-event Claude Code hook template
- macOS sound playback through `afplay`
- Download-on-install sounds, with no audio assets committed to git
- Safe renderer that prints JSON without modifying your Claude Code settings
- English and Chinese documentation

## Prerequisites

- macOS
- Bash
- `curl`
- `afplay` (built into macOS)
- Claude Code

## Installation

```sh
git clone git@github.com:YangsonHung/claude-code-mario-hooks.git
cd claude-code-mario-hooks
./install.sh
./scripts/verify-install.sh
```

By default, `install.sh` downloads all sounds listed in `manifest/sounds.tsv` into `sounds/`.

Options:

```sh
./install.sh --required-only  # download only sounds used by the default hook template
./install.sh --force          # re-download existing files
./install.sh --help
```

## Configure Claude Code

Render the hook settings for your local clone:

```sh
./scripts/render-settings.sh
```

Copy the rendered `hooks` block into the Claude Code settings file where you want this behavior:

- User-level settings: `~/.claude/settings.json`
- Project-level settings: `.claude/settings.json` inside a project

The installer intentionally does not edit your settings automatically.

## Hook mapping

| Claude Code event | Matcher | Sound |
|---|---|---|
| `SessionStart` |  | `smb_pipe.wav` |
| `SessionEnd` |  | `smb_gameover.wav` |
| `UserPromptSubmit` |  | `smb_coin.wav` |
| `PreToolUse` | `*` | `smb_jump-small.wav` |
| `PostToolUse` | `*` | `smb_stomp.wav` |
| `Notification` |  | `smb_powerup.wav` |
| `Stop` |  | `smb_stage_clear.wav` |
| `SubagentStop` |  | `smb_flagpole.wav` |
| `PreCompact` |  | `smb_warning.wav` |

## Files

```text
install.sh                    Download sound files into ./sounds/
manifest/sounds.tsv           Download manifest
scripts/play-sound.sh         Hook-safe macOS sound player
scripts/render-settings.sh    Render templates/claude-settings.json with your local path
scripts/verify-install.sh     Verify downloaded files and rendered settings
templates/claude-settings.json Claude Code hooks template
sounds/.gitkeep               Empty tracked directory; downloaded sounds are ignored
```

## Linux and Windows

This project supports macOS by default because Claude Code runs hooks as shell commands and macOS ships with `afplay`.

For Linux, adapt `scripts/play-sound.sh` to call `paplay`, `aplay`, or `ffplay`.

For Windows, adapt the hook command to use PowerShell, for example `System.Media.SoundPlayer` for WAV playback.

## License

MIT for this repository's code, scripts, templates, and documentation only. Downloaded sound assets are not covered by this license.
