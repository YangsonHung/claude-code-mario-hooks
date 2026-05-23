# claude-code-mario-hooks

English | [简体中文](README.zh-CN.md)

Claude Code hook sound templates that play one SMB-style WAV sound for each hook event.

> Claude Code hook concepts, lifecycle events, matcher behavior, and configuration rules are documented in the official [Claude Code Hooks Guide](https://code.claude.com/docs/en/hooks-guide).

## ✨ Features

- Complete Claude Code hook lifecycle template.
- One distinct WAV sound for each hook event.
- One install script: `scripts/install.sh` downloads sounds, generates settings, and verifies the result.
- macOS-first playback through `afplay`.
- Downloads sounds during install; audio assets are not committed to git.
- Generates `claude-settings.generated.json`; does not edit Claude Code settings.

## ✅ Prerequisites

- macOS
- Bash
- `curl`
- `afplay` (built into macOS)
- Claude Code

## 🚀 Install

Run the installer:

```sh
curl -fsSL https://raw.githubusercontent.com/YangsonHung/claude-code-mario-hooks/main/scripts/install.sh | bash
```

The script downloads sounds to `~/.claude/claude-code-mario-hooks/sounds`, generates `~/.claude/claude-code-mario-hooks/claude-settings.generated.json`, and verifies the result.

Set a different install directory:

```sh
curl -fsSL https://raw.githubusercontent.com/YangsonHung/claude-code-mario-hooks/main/scripts/install.sh | bash -s -- --dir ~/tools/claude-code-mario-hooks
```

## 🛠️ Source Install

```sh
git clone git@github.com:YangsonHung/claude-code-mario-hooks.git
cd claude-code-mario-hooks
./scripts/install.sh
```

Options:

```sh
./scripts/install.sh --all-sounds  # download every sound in manifest/sounds.tsv
./scripts/install.sh --force       # re-download existing files
./scripts/install.sh --output /tmp/claude-settings.json
./scripts/install.sh --help
```

On failure, the installer prints the failed line and suggested fixes.

## ⚙️ Configure Claude Code

`./scripts/install.sh` generates `~/.claude/claude-code-mario-hooks/claude-settings.generated.json`. Copy the generated `hooks` block into a Claude Code settings file:

- User-level settings: `~/.claude/settings.json`
- Project-level settings: `.claude/settings.json` inside a project

The installer does not edit Claude Code settings. After copying the `hooks` block, run `/hooks` in Claude Code to check the loaded hooks.

## 📋 Hook Mapping

Events are ordered by the Claude Code hook lifecycle. Sound file format: `NN_EventName_original.wav`.

|No.|Category|Event|When it fires|Matcher|Sound|Sound note|
|---|---|---|---|---|---|---|
|01|Session and setup|`SessionStart`|Session starts or resumes||`01_SessionStart_smb_pipe.wav`|Pipe travel / power-down|
|02|Session and setup|`Setup`|Claude Code setup runs||`02_Setup_smb_1-up.wav`|1-Up extra life|
|03|Prompt and interaction|`UserPromptSubmit`|User submits a prompt||`03_UserPromptSubmit_smb_coin.wav`|Coin pickup|
|04|Prompt and interaction|`UserPromptExpansion`|Typed command expands into a prompt|`*`|`04_UserPromptExpansion_smb_fireball.wav`|Fireball shot|
|05|Tools and permissions|`PreToolUse`|Before a tool call runs|`*`|`05_PreToolUse_smb_jump-small.wav`|Small Mario jump|
|06|Tools and permissions|`PermissionRequest`|Permission dialog appears|`*`|`06_PermissionRequest_smb_jump-super.wav`|Super Mario jump|
|07|Tools and permissions|`PermissionDenied`|Permission is denied|`*`|`07_PermissionDenied_smb_bump.wav`|Block bump|
|08|Tools and permissions|`PostToolUse`|After a tool call succeeds|`*`|`08_PostToolUse_smb_stomp.wav`|Enemy stomp|
|09|Tools and permissions|`PostToolUseFailure`|After a tool call fails|`*`|`09_PostToolUseFailure_smb_warning.wav`|Running out of time warning|
|10|Tools and permissions|`PostToolBatch`|After a parallel tool batch resolves||`10_PostToolBatch_smb_world_clear.wav`|World clear music|
|11|Prompt and interaction|`Notification`|Claude Code needs attention|`*`|`11_Notification_smb_pause.wav`|Pause sound|
|12|Agents and tasks|`SubagentStart`|Subagent starts|`*`|`12_SubagentStart_smb_powerup_appears.wav`|Power-up appears|
|13|Agents and tasks|`SubagentStop`|Subagent finishes|`*`|`13_SubagentStop_smb_flagpole.wav`|Flagpole slide|
|14|Agents and tasks|`TaskCreated`|Task is created||`14_TaskCreated_smb2_cherry.wav`|SMB2 cherry / player select|
|15|Agents and tasks|`TaskCompleted`|Task is completed||`15_TaskCompleted_smb_stage_clear.wav`|Stage clear music|
|16|Stop and failure|`Stop`|Claude finishes responding||`16_Stop_smb_fireworks.wav`|Fireworks|
|17|Stop and failure|`StopFailure`|Turn ends because of an API error|`*`|`17_StopFailure_smb_mariodie.wav`|Mario dies|
|18|Agents and tasks|`TeammateIdle`|Agent-team teammate becomes idle||`18_TeammateIdle_smb_powerup.wav`|Power-up collected|
|19|Environment and config|`InstructionsLoaded`|CLAUDE.md or rules are loaded|`*`|`19_InstructionsLoaded_smb_vine.wav`|Vine growing|
|20|Environment and config|`ConfigChange`|Settings or skills config changes|`*`|`20_ConfigChange_smb_bowserfire.wav`|Bowser's fire|
|21|Environment and config|`CwdChanged`|Working directory changes||`21_CwdChanged_smb2_enter_door.wav`|SMB2 entering a door|
|22|Environment and config|`FileChanged`|Watched filenames change|`.env\|.envrc\|CLAUDE.md\|settings.json\|settings.local.json`|`22_FileChanged_smb_breakblock.wav`|Brick smash|
|23|Worktree and context|`WorktreeCreate`|Worktree is being created||`23_WorktreeCreate_smb2_door_appears.wav`|SMB2 door appears|
|24|Worktree and context|`WorktreeRemove`|Worktree is being removed||`24_WorktreeRemove_smb_bowserfalls.wav`|Bowser falls|
|25|Worktree and context|`PreCompact`|Before context compaction|`*`|`25_PreCompact_smb_kick.wav`|Shell kick|
|26|Worktree and context|`PostCompact`|After context compaction|`*`|`26_PostCompact_smb2_grow.wav`|SMB2 growing|
|27|MCP input|`Elicitation`|MCP server requests input|`*`|`27_Elicitation_smb2_pickup.wav`|SMB2 picking up item|
|28|MCP input|`ElicitationResult`|MCP input result returns|`*`|`28_ElicitationResult_smb2_boss_down.wav`|SMB2 boss down|
|29|Session and setup|`SessionEnd`|Session terminates|`*`|`29_SessionEnd_smb_gameover.wav`|Game over music|

The `FileChanged` matcher lists literal filenames to watch; Claude Code does not treat `*` as "all files" for this event.

## 🎵 Sound Assignment Principles

|No.|Intent|Sound|Sound note|Used by|
|---|---|---|---|---|
|01|Session entry|`01_SessionStart_smb_pipe.wav`|Pipe travel / power-down|`SessionStart`|
|02|Setup ready|`02_Setup_smb_1-up.wav`|1-Up extra life|`Setup`|
|03|Prompt submitted|`03_UserPromptSubmit_smb_coin.wav`|Coin pickup|`UserPromptSubmit`|
|04|Prompt expansion|`04_UserPromptExpansion_smb_fireball.wav`|Fireball shot|`UserPromptExpansion`|
|05|Tool about to run|`05_PreToolUse_smb_jump-small.wav`|Small Mario jump|`PreToolUse`|
|06|Permission prompt|`06_PermissionRequest_smb_jump-super.wav`|Super Mario jump|`PermissionRequest`|
|07|Permission denied|`07_PermissionDenied_smb_bump.wav`|Block bump|`PermissionDenied`|
|08|Tool success|`08_PostToolUse_smb_stomp.wav`|Enemy stomp|`PostToolUse`|
|09|Tool failure|`09_PostToolUseFailure_smb_warning.wav`|Running out of time warning|`PostToolUseFailure`|
|10|Tool batch complete|`10_PostToolBatch_smb_world_clear.wav`|World clear music|`PostToolBatch`|
|11|Attention needed|`11_Notification_smb_pause.wav`|Pause sound|`Notification`|
|12|Subagent starting|`12_SubagentStart_smb_powerup_appears.wav`|Power-up appears|`SubagentStart`|
|13|Subagent complete|`13_SubagentStop_smb_flagpole.wav`|Flagpole slide|`SubagentStop`|
|14|Task created|`14_TaskCreated_smb2_cherry.wav`|SMB2 cherry / player select|`TaskCreated`|
|15|Task complete|`15_TaskCompleted_smb_stage_clear.wav`|Stage clear music|`TaskCompleted`|
|16|Assistant stopped normally|`16_Stop_smb_fireworks.wav`|Fireworks|`Stop`|
|17|Assistant stopped with API error|`17_StopFailure_smb_mariodie.wav`|Mario dies|`StopFailure`|
|18|Teammate idle|`18_TeammateIdle_smb_powerup.wav`|Power-up collected|`TeammateIdle`|
|19|Instructions loaded|`19_InstructionsLoaded_smb_vine.wav`|Vine growing|`InstructionsLoaded`|
|20|Config changed|`20_ConfigChange_smb_bowserfire.wav`|Bowser's fire|`ConfigChange`|
|21|Directory changed|`21_CwdChanged_smb2_enter_door.wav`|SMB2 entering a door|`CwdChanged`|
|22|Watched file changed|`22_FileChanged_smb_breakblock.wav`|Brick smash|`FileChanged`|
|23|Worktree created|`23_WorktreeCreate_smb2_door_appears.wav`|SMB2 door appears|`WorktreeCreate`|
|24|Worktree removed|`24_WorktreeRemove_smb_bowserfalls.wav`|Bowser falls|`WorktreeRemove`|
|25|Before compaction|`25_PreCompact_smb_kick.wav`|Shell kick|`PreCompact`|
|26|After compaction|`26_PostCompact_smb2_grow.wav`|SMB2 growing|`PostCompact`|
|27|MCP input requested|`27_Elicitation_smb2_pickup.wav`|SMB2 picking up item|`Elicitation`|
|28|MCP input completed|`28_ElicitationResult_smb2_boss_down.wav`|SMB2 boss down|`ElicitationResult`|
|29|Session ended|`29_SessionEnd_smb_gameover.wav`|Game over music|`SessionEnd`|

## 📁 Project Files

```text
scripts/install.sh             Download sounds, generate settings JSON, and verify install
manifest/sounds.tsv            Download manifest
templates/claude-settings.json Claude Code hooks template
```

Generated files are written under `~/.claude/claude-code-mario-hooks/`.

## 🐧 Linux and Windows

This project uses macOS `afplay`.

- Linux: change the generated hook commands from `afplay` to `paplay`, `aplay`, or `ffplay`.
- Windows: adapt the generated hook command to use PowerShell, for example `System.Media.SoundPlayer` for WAV playback.

## ⚖️ Legal Notice

This repository does **not** include Nintendo, Mario, or Super Mario audio assets.

The MIT license in this repository applies only to the code, scripts, templates, and documentation authored for this project. Sound files downloaded by `scripts/install.sh` come from third-party sources and remain the property of their respective owners. You are responsible for complying with applicable laws and third-party terms when downloading or using those assets.

## 📄 License

MIT for this repository's code, scripts, templates, and documentation only. Downloaded sound assets are not covered by this license.
