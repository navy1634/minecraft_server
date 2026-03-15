#!/bin/bash
# サーバーのログを監視してDiscordに通知する

: "${base_dir:=/home/ec2-user/common_mods_server}"
: "${webhooks_url:=}"

tail -f "$base_dir/logs/latest.log" | while read -r line
do
  if [[ $line == *joined\ the\ game* ]]; then
    # ログイン通知
    message=$(echo "$line" | sed -n 's/.*: \([^ ]*\) joined the game.*/\1 がログインしました。/p')
    curl -X POST -H "Content-Type: application/json" -d "{\"content\":\"$message\"}" "$webhooks_url"
  elif [[ $line == *left\ the\ game* ]]; then
    # ログアウト通知
    message=$(echo "$line" | sed -n 's/.*: \([^ ]*\) left the game.*/\1 がログアウトしました。/p')
    curl -X POST -H "Content-Type: application/json" -d "{\"content\":\"$message\"}" "$webhooks_url"
  fi
done
