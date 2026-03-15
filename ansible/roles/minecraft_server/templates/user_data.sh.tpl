#!/bin/bash
set -e

# マイクラ本体
cat > /etc/systemd/system/minecraft.service <<'SERVICEFILE'
${minecraft_service}
SERVICEFILE
systemctl daemon-reload
systemctl enable minecraft

# ログイン通知スクリプト
cat > /etc/systemd/system/minecraft_observer.service <<'SERVICEFILE'
${minecraft_observer_service}
SERVICEFILE
systemctl daemon-reload
systemctl enable minecraft_observer

# 監視スクリプト
cat > /usr/local/bin/observe.sh <<'BACKUPSCRIPT'
${observe_script}
BACKUPSCRIPT
chmod +x /usr/local/bin/observe.sh

# ワールドバックアップスクリプト
cat > /usr/local/bin/backup-minecraft-world.sh <<'BACKUPSCRIPT'
${backup_world_script}
BACKUPSCRIPT
chmod +x /usr/local/bin/backup-minecraft-world.sh

# javaのインストール
sudo dnf install java-25-amazon-corretto-headless -y

# CloudWatch Agent のインストール
sudo dnf install -y amazon-cloudwatch-agent

# CloudWatch Agent 用ログディレクトリを作成
sudo mkdir -p /var/log/minecraft

# CloudWatch Agent 設定ファイルを作成
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -s \
  -c "ssm:${ssm_parameter_name}"
