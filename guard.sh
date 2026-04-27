#!/bin/bash
# 永不断连守护进程 - 每60s检查并修复
LOG=~/.openclaw/workspace/never_offline.log
UNDICI_OK=~/.npm-global/lib/node_modules/clawhub/node_modules/undici
UNDICI_FIX=~/.npm-global/lib/node_modules/openclaw/node_modules/undici
PROXY="172.19.208.1:7897"

echo "[$(date '+%H:%M:%S')] 🟢 守护启动" > $LOG

while true; do
  # 1. undici 版本
  VER=$(node -e "require('$UNDICI_FIX/package.json').version" 2>/dev/null)
  if [ "$VER" != "7.25.0" ]; then
    echo "[$(date '+%H:%M:%S')] ⚠️ undici=$VER → 修复" >> $LOG
    rm -rf "$UNDICI_FIX" && cp -r "$UNDICI_OK" "$UNDICI_FIX"
    source ~/.bashrc && openclaw gateway restart 2>/dev/null &
    echo "[$(date '+%H:%M:%S')] ✅ undici已修复+gateway重启" >> $LOG
  fi
  
  # 2. 代理检查
  if ! curl -s --max-time 3 "http://$PROXY" >/dev/null 2>&1; then
    echo "[$(date '+%H:%M:%S')] ⚠️ 代理不通" >> $LOG
  fi
  
  # 3. TG检查
  TOKEN=$(grep -oP 'botToken":\s*"[^"]+' ~/.openclaw/openclaw.json | tail -1 | cut -d'"' -f4)
  if [ -n "$TOKEN" ]; then
    RESP=$(curl -s --max-time 5 "https://api.telegram.org/bot$TOKEN/getMe" 2>/dev/null)
    if ! echo "$RESP" | grep -q '"ok":true'; then
      echo "[$(date '+%H:%M:%S')] ⚠️ TG断连 → 重启gateway" >> $LOG
      source ~/.bashrc && openclaw gateway restart 2>/dev/null &
    fi
  fi
  
  sleep 60
done
