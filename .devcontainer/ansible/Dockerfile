FROM ubuntu:24.04

# ロケール設定
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Ansibleコントローラー用設定
RUN apt-get update && apt-get install -y \
    ansible \
    ansible-lint \
    openssh-client \
    python3 \
    python3-pip \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# SSH キー初期化スクリプト
RUN mkdir -p /tmp/ssh-keys && \
    printf '#!/bin/bash\nif [ ! -f /tmp/ssh-keys/ansible_key.pub ]; then\n  ssh-keygen -t ed25519 -f /tmp/ssh-keys/ansible_key -N ""\nfi\nmkdir -p /root/.ssh\ncp /tmp/ssh-keys/ansible_key /root/.ssh/ansible_key\ncp /tmp/ssh-keys/ansible_key.pub /root/.ssh/ansible_key.pub\nchmod 600 /root/.ssh/ansible_key\nchmod 644 /root/.ssh/ansible_key.pub\nexec /bin/sh "$@"\n' > /entrypoint-init.sh && \
    chmod +x /entrypoint-init.sh

ENTRYPOINT ["/entrypoint-init.sh"]
