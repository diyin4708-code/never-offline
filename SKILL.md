---
name: 永不断连
description: |
  网络连接自动恢复技能。代理断连、TG离线、undici版本异常 → 自动检测+自动修复。
  每个OpenClaw用户都需要的最基础技能。
  Auto-reconnect for proxy, Telegram, and undici version issues.
license: MIT
metadata:
  author: "@lingmunaixue"
  version: "1.0.0"
  keywords: [network, reconnect, watchdog, proxy, telegram, undici, 断连, 恢复]
user-invocable: true
---

# 永不断连

> WSL 环境下代理和 TG 频繁断连？每60秒自动检测+修复。

## 背景

在 WSL + Clash 代理的环境下，三个问题高频发生：
1. 代理偶尔挂 → TG 收不到消息
2. npm install 覆盖 undici 8.x → ProxyAgent 失效
3. OpenClaw gateway 需要重启才能加载新插件

这个技能解决这三个问题。

## 功能

| 检查项 | 检测间隔 | 自动修复 |
|--------|---------|----------|
| Clash 代理 | 60秒 | 标记不可用 |
| TG Bot 连通 | 60秒 | 自动重启 gateway |
| undici 版本 | 60秒 | 降级到 7.25 + 重启 gateway |

## 安装

```bash
# 克隆 + 安装
git clone https://github.com/diyin4708-code/never-offline.git ~/.openclaw/workspace/skills/never-offline

# 后台启动守护
bash ~/.openclaw/workspace/skills/never-offline/guard.sh &
```

## 工作原理

每 60 秒一个循环：
```
检查代理 → 不通？标记
检查 TG → 不通？重启 gateway
检查 undici → 不对？替换文件 + 重启 gateway
```

不在用户聊天里刷屏告警。只在日志里记录，由「吾日三省吾身」定时汇总汇报。

## 配合其他技能

与 [吾日三省吾身](https://github.com/diyin4708-code/daily-review) 配合使用：
- 永不断连 → 实时修复
- 三省吾身 → 定时汇报

Made with ❤️ by [@lingmunaixue](https://x.com/lingmunaixue)
