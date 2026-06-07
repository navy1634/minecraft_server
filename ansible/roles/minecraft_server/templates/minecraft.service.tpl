[Unit]
Description=Minecraft NeoForge Server
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/common_mods_server

ExecStart=java \
  @user_jvm_args.txt \
  @libraries/net/neoforged/neoforge/21.11.26-beta/unix_args.txt \
  nogui

ExecStop=/bin/bash -c '/usr/local/bin/backup-minecraft-world.sh {{ s3_backup_bucket_name | default("") }}'

Restart=always
RestartSec=10
StandardInput=null
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
