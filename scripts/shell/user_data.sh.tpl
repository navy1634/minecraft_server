#!/bin/bash
set -e

cat > /etc/systemd/system/minecraft.service <<'SERVICEFILE'
${minecraft_service}
SERVICEFILE
systemctl daemon-reload
systemctl enable minecraft

cat > /usr/local/bin/backup-minecraft-world.sh <<'BACKUPSCRIPT'
${backup_world_script}
BACKUPSCRIPT
chmod +x /usr/local/bin/backup-minecraft-world.sh
