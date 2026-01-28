[Unit]
Description=Minecraft Server Observer
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/common_mods_server
Type=simple
Environment="base_dir=/home/ec2-user/common_mods_server"
Environment="webhooks_url=${webhooks_url}"
ExecStart=/usr/local/bin/observe.sh

Restart=always
RestartSec=10
StandardInput=null
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
