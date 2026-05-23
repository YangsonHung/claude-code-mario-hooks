# claude-code-mario-hooks

[English](README.md) | 简体中文

一套 Claude Code hooks 音效模板，可在 Claude Code 常见生命周期事件发生时播放经典 SMB 风格 WAV 音效。

本项目优先支持 macOS，默认使用 `afplay` 播放声音。仓库不内置任何 Nintendo 或 Mario 音效文件；安装脚本会在设置时下载音效。

## 法律声明

本仓库**不包含** Nintendo、Mario 或 Super Mario 音频资产。

本仓库中的 MIT 许可证仅适用于本项目编写的代码、脚本、模板和文档。`install.sh` 下载的声音文件来自第三方来源，仍归其各自权利方所有。下载或使用这些资产时，你需要自行遵守适用法律和第三方条款。

## 功能

- 覆盖全部 9 个 Claude Code hook 事件的模板
- macOS 下通过 `afplay` 播放音效
- 安装时下载音效，仓库不提交音频资产
- 安全的模板渲染脚本：只输出 JSON，不自动修改 Claude Code 配置
- 中英双语文档

## 前置要求

- macOS
- Bash
- `curl`
- `afplay`（macOS 内置）
- Claude Code

## 安装

```sh
git clone git@github.com:YangsonHung/claude-code-mario-hooks.git
cd claude-code-mario-hooks
./install.sh
./scripts/verify-install.sh
```

默认情况下，`install.sh` 会把 `manifest/sounds.tsv` 中列出的所有声音下载到 `sounds/`。

可选参数：

```sh
./install.sh --required-only  # 只下载默认 hook 模板使用的音效
./install.sh --force          # 重新下载已存在文件
./install.sh --help
```

## 配置 Claude Code

为你的本地 clone 渲染 hook 配置：

```sh
./scripts/render-settings.sh
```

把输出中的 `hooks` 字段复制到你希望生效的 Claude Code 配置文件中：

- 用户级配置：`~/.claude/settings.json`
- 项目级配置：某个项目内的 `.claude/settings.json`

安装脚本有意不自动修改你的配置，避免覆盖已有设置。

## Hook 映射

| Claude Code 事件 | Matcher | 音效 |
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

## 文件说明

```text
install.sh                     下载声音文件到 ./sounds/
manifest/sounds.tsv            下载清单
scripts/play-sound.sh          适合 hook 调用的 macOS 音效播放器
scripts/render-settings.sh     用本地路径渲染 templates/claude-settings.json
scripts/verify-install.sh      验证下载文件和渲染配置
templates/claude-settings.json Claude Code hooks 模板
sounds/.gitkeep                保留空目录；下载后的声音文件会被 git 忽略
```

## Linux 和 Windows

本项目默认支持 macOS，因为 Claude Code hooks 以 shell 命令运行，且 macOS 内置 `afplay`。

Linux 可将 `scripts/play-sound.sh` 改为调用 `paplay`、`aplay` 或 `ffplay`。

Windows 可将 hook 命令改为 PowerShell，例如使用 `System.Media.SoundPlayer` 播放 WAV。

## 许可证

本仓库的代码、脚本、模板和文档使用 MIT 许可证。下载的声音资产不在该许可证覆盖范围内。
