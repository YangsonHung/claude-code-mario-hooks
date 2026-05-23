# claude-code-mario-hooks

[English](README.md) | 简体中文

Claude Code hooks 音效模板，为每个 hook 事件播放一个 SMB 风格 WAV 音效。

> Claude Code hooks 的概念、生命周期事件、matcher 行为和配置规则见官方 [Claude Code Hooks 指南](https://code.claude.com/docs/zh-CN/hooks-guide)。

## ✨ 功能亮点

- 覆盖完整 Claude Code hook 生命周期。
- 每个 hook 事件都有独立 WAV 音效。
- 只有一个安装脚本：`scripts/install.sh` 负责下载音效、生成配置和验证结果。
- macOS 优先，默认使用 `afplay` 播放音效。
- 安装时下载音效；仓库不提交音频资产。
- 生成 `claude-settings.generated.json`；不修改 Claude Code settings。

## ✅ 前置要求

- macOS
- Bash
- `curl`
- `afplay`（macOS 内置）
- Claude Code

## 🚀 安装

运行安装脚本：

```sh
curl -fsSL https://raw.githubusercontent.com/YangsonHung/claude-code-mario-hooks/main/scripts/install.sh | bash
```

脚本会把音效下载到 `~/.claude/claude-code-mario-hooks/sounds`，生成 `~/.claude/claude-code-mario-hooks/claude-settings.generated.json`，并验证结果。

指定安装目录：

```sh
curl -fsSL https://raw.githubusercontent.com/YangsonHung/claude-code-mario-hooks/main/scripts/install.sh | bash -s -- --dir ~/tools/claude-code-mario-hooks
```

## 🛠️ 从源码安装

```sh
git clone git@github.com:YangsonHung/claude-code-mario-hooks.git
cd claude-code-mario-hooks
./scripts/install.sh
```

参数：

```sh
./scripts/install.sh --all-sounds  # 下载 manifest/sounds.tsv 中的全部音效
./scripts/install.sh --force       # 重新下载已存在文件
./scripts/install.sh --output /tmp/claude-settings.json
./scripts/install.sh --help
```

步骤失败时，脚本会输出失败行号和修复提示。

## ⚙️ 配置 Claude Code

`./scripts/install.sh` 会生成 `~/.claude/claude-code-mario-hooks/claude-settings.generated.json`。复制其中的 `hooks` 字段到 Claude Code 配置文件：

- 用户级配置：`~/.claude/settings.json`
- 项目级配置：某个项目内的 `.claude/settings.json`

脚本不修改 Claude Code 配置。复制 `hooks` 字段后，在 Claude Code 中运行 `/hooks` 检查加载结果。

## 📋 Hook 映射

事件按 Claude Code hook 生命周期排序。音效文件命名格式：`NN_EventName_original.wav`。

|序号|类别|Claude Code 事件|触发时机|Matcher|音效|音效说明|
|---|---|---|---|---|---|---|
|01|会话与设置|`SessionStart`|会话开始或恢复||`01_SessionStart_smb_pipe.wav`|水管移动 / 变小音效|
|02|会话与设置|`Setup`|Claude Code setup 运行||`02_Setup_smb_1-up.wav`|获得 1-Up 额外生命|
|03|提示与交互|`UserPromptSubmit`|用户提交提示词||`03_UserPromptSubmit_smb_coin.wav`|吃金币音效|
|04|提示与交互|`UserPromptExpansion`|输入命令展开为提示词|`*`|`04_UserPromptExpansion_smb_fireball.wav`|发射火球音效|
|05|工具与权限|`PreToolUse`|工具调用执行前|`*`|`05_PreToolUse_smb_jump-small.wav`|小 Mario 跳跃|
|06|工具与权限|`PermissionRequest`|出现权限确认框|`*`|`06_PermissionRequest_smb_jump-super.wav`|Super Mario 跳跃|
|07|工具与权限|`PermissionDenied`|权限被拒绝|`*`|`07_PermissionDenied_smb_bump.wav`|顶方块音效|
|08|工具与权限|`PostToolUse`|工具调用成功后|`*`|`08_PostToolUse_smb_stomp.wav`|踩敌人音效|
|09|工具与权限|`PostToolUseFailure`|工具调用失败后|`*`|`09_PostToolUseFailure_smb_warning.wav`|时间即将耗尽警告|
|10|工具与权限|`PostToolBatch`|一批并行工具调用结束后||`10_PostToolBatch_smb_world_clear.wav`|世界通关音乐|
|11|提示与交互|`Notification`|Claude Code 需要用户注意|`*`|`11_Notification_smb_pause.wav`|暂停音效|
|12|代理与任务|`SubagentStart`|子代理启动|`*`|`12_SubagentStart_smb_powerup_appears.wav`|强化道具出现|
|13|代理与任务|`SubagentStop`|子代理结束|`*`|`13_SubagentStop_smb_flagpole.wav`|滑下旗杆音效|
|14|代理与任务|`TaskCreated`|任务被创建||`14_TaskCreated_smb2_cherry.wav`|SMB2 樱桃 / 角色选择|
|15|代理与任务|`TaskCompleted`|任务被完成||`15_TaskCompleted_smb_stage_clear.wav`|关卡通关音乐|
|16|停止与失败|`Stop`|Claude 完成响应||`16_Stop_smb_fireworks.wav`|烟花音效|
|17|停止与失败|`StopFailure`|回合因 API 错误结束|`*`|`17_StopFailure_smb_mariodie.wav`|Mario 死亡音效|
|18|代理与任务|`TeammateIdle`|Agent team 队友即将空闲||`18_TeammateIdle_smb_powerup.wav`|获得强化道具|
|19|环境与配置|`InstructionsLoaded`|CLAUDE.md 或规则被加载|`*`|`19_InstructionsLoaded_smb_vine.wav`|藤蔓生长音效|
|20|环境与配置|`ConfigChange`|settings 或 skills 配置变化|`*`|`20_ConfigChange_smb_bowserfire.wav`|Bowser 喷火音效|
|21|环境与配置|`CwdChanged`|工作目录变化||`21_CwdChanged_smb2_enter_door.wav`|SMB2 进门音效|
|22|环境与配置|`FileChanged`|被监听的文件名发生变化|`.env\|.envrc\|CLAUDE.md\|settings.json\|settings.local.json`|`22_FileChanged_smb_breakblock.wav`|打碎砖块音效|
|23|工作树与上下文|`WorktreeCreate`|工作树即将创建||`23_WorktreeCreate_smb2_door_appears.wav`|SMB2 门出现音效|
|24|工作树与上下文|`WorktreeRemove`|工作树即将移除||`24_WorktreeRemove_smb_bowserfalls.wav`|Bowser 掉落音效|
|25|工作树与上下文|`PreCompact`|上下文压缩前|`*`|`25_PreCompact_smb_kick.wav`|踢龟壳音效|
|26|工作树与上下文|`PostCompact`|上下文压缩后|`*`|`26_PostCompact_smb2_grow.wav`|SMB2 变大音效|
|27|MCP 输入|`Elicitation`|MCP 服务器请求输入|`*`|`27_Elicitation_smb2_pickup.wav`|SMB2 拾取物品音效|
|28|MCP 输入|`ElicitationResult`|MCP 输入结果返回|`*`|`28_ElicitationResult_smb2_boss_down.wav`|SMB2 Boss 被击败|
|29|会话与设置|`SessionEnd`|会话终止|`*`|`29_SessionEnd_smb_gameover.wav`|Game Over 音乐|

`FileChanged` 的 matcher 是要监听的字面文件名列表；Claude Code 不会把 `*` 当作此事件的“全部文件”。

## 🎵 音效分配原则

|序号|意图|音效|音效说明|用于|
|---|---|---|---|---|
|01|会话进入|`01_SessionStart_smb_pipe.wav`|水管移动 / 变小音效|`SessionStart`|
|02|设置就绪|`02_Setup_smb_1-up.wav`|获得 1-Up 额外生命|`Setup`|
|03|提示词已提交|`03_UserPromptSubmit_smb_coin.wav`|吃金币音效|`UserPromptSubmit`|
|04|提示词展开|`04_UserPromptExpansion_smb_fireball.wav`|发射火球音效|`UserPromptExpansion`|
|05|工具即将运行|`05_PreToolUse_smb_jump-small.wav`|小 Mario 跳跃|`PreToolUse`|
|06|权限确认|`06_PermissionRequest_smb_jump-super.wav`|Super Mario 跳跃|`PermissionRequest`|
|07|权限被拒绝|`07_PermissionDenied_smb_bump.wav`|顶方块音效|`PermissionDenied`|
|08|工具成功|`08_PostToolUse_smb_stomp.wav`|踩敌人音效|`PostToolUse`|
|09|工具失败|`09_PostToolUseFailure_smb_warning.wav`|时间即将耗尽警告|`PostToolUseFailure`|
|10|工具批次完成|`10_PostToolBatch_smb_world_clear.wav`|世界通关音乐|`PostToolBatch`|
|11|需要注意|`11_Notification_smb_pause.wav`|暂停音效|`Notification`|
|12|子代理启动|`12_SubagentStart_smb_powerup_appears.wav`|强化道具出现|`SubagentStart`|
|13|子代理完成|`13_SubagentStop_smb_flagpole.wav`|滑下旗杆音效|`SubagentStop`|
|14|任务创建|`14_TaskCreated_smb2_cherry.wav`|SMB2 樱桃 / 角色选择|`TaskCreated`|
|15|任务完成|`15_TaskCompleted_smb_stage_clear.wav`|关卡通关音乐|`TaskCompleted`|
|16|助手正常停止|`16_Stop_smb_fireworks.wav`|烟花音效|`Stop`|
|17|助手因 API 错误停止|`17_StopFailure_smb_mariodie.wav`|Mario 死亡音效|`StopFailure`|
|18|队友空闲|`18_TeammateIdle_smb_powerup.wav`|获得强化道具|`TeammateIdle`|
|19|指令加载|`19_InstructionsLoaded_smb_vine.wav`|藤蔓生长音效|`InstructionsLoaded`|
|20|配置变化|`20_ConfigChange_smb_bowserfire.wav`|Bowser 喷火音效|`ConfigChange`|
|21|目录变化|`21_CwdChanged_smb2_enter_door.wav`|SMB2 进门音效|`CwdChanged`|
|22|被监听文件变化|`22_FileChanged_smb_breakblock.wav`|打碎砖块音效|`FileChanged`|
|23|工作树创建|`23_WorktreeCreate_smb2_door_appears.wav`|SMB2 门出现音效|`WorktreeCreate`|
|24|工作树移除|`24_WorktreeRemove_smb_bowserfalls.wav`|Bowser 掉落音效|`WorktreeRemove`|
|25|压缩前|`25_PreCompact_smb_kick.wav`|踢龟壳音效|`PreCompact`|
|26|压缩后|`26_PostCompact_smb2_grow.wav`|SMB2 变大音效|`PostCompact`|
|27|MCP 请求输入|`27_Elicitation_smb2_pickup.wav`|SMB2 拾取物品音效|`Elicitation`|
|28|MCP 输入完成|`28_ElicitationResult_smb2_boss_down.wav`|SMB2 Boss 被击败|`ElicitationResult`|
|29|会话结束|`29_SessionEnd_smb_gameover.wav`|Game Over 音乐|`SessionEnd`|

## 📁 项目文件

```text
scripts/install.sh             下载音效、生成 settings JSON 并验证安装
manifest/sounds.tsv            下载清单
templates/claude-settings.json Claude Code hooks 模板
```

生成文件会写入 `~/.claude/claude-code-mario-hooks/`。

## 🐧 Linux 和 Windows

本项目默认使用 macOS 的 `afplay`。

- Linux：可将生成配置中的 hook 命令从 `afplay` 改为 `paplay`、`aplay` 或 `ffplay`。
- Windows：可将 hook 命令改为 PowerShell，例如使用 `System.Media.SoundPlayer` 播放 WAV。

## ⚖️ 法律声明

本仓库**不包含** Nintendo、Mario 或 Super Mario 音频资产。

本仓库中的 MIT 许可证仅适用于本项目编写的代码、脚本、模板和文档。`scripts/install.sh` 下载的声音文件来自第三方来源，仍归其各自权利方所有。下载或使用这些资产时，你需要自行遵守适用法律和第三方条款。

## 📄 许可证

本仓库的代码、脚本、模板和文档使用 MIT 许可证。下载的声音资产不在该许可证覆盖范围内。
