#!/bin/bash
set -e

WORLD_PATH="/home/ec2-user/common_mods_server"
S3_BUCKET="$1"
BACKUP_DIR="/tmp/minecraft_backup"
BACKUP_FILENAME="minecraft_world.tar.gz"

if [ -z "$S3_BUCKET" ]; then
    echo "エラー: S3バケット名が引数で指定されていません"
    exit 1
fi

echo "Minecraftワールドバックアップを開始します"
mkdir -p "$BACKUP_DIR"
cd "$WORLD_PATH"
tar -czf "$BACKUP_DIR/$BACKUP_FILENAME" \
    --exclude='*.log' \
    --exclude='.cache' \
    --exclude='crash-reports' \
    --warning=no-file-changed \
    ./world

aws s3 cp "$BACKUP_DIR/$BACKUP_FILENAME" "s3://$S3_BUCKET/backups/$BACKUP_FILENAME"
rm -rf "$BACKUP_DIR"
echo "バックアップが完了しました"
