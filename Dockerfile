FROM amazonlinux:2023

# Ansibleターゲットノード用設定
RUN yum install -y \
    openssh-server \
    openssh-clients \
    sudo \
    python3

# SSHディレクトリ作成
RUN mkdir -p /run/sshd /root/.ssh

# Ansibleユーザー作成
RUN useradd -m -s /bin/bash ansible && \
    mkdir -p /home/ansible/.ssh && \
    chmod 700 /home/ansible/.ssh && \
    chown -R ansible:ansible /home/ansible/.ssh

# sudoers設定（パスワード不要）
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# SSH ホストキー生成
RUN ssh-keygen -A

# SSHデーモン起動スクリプト
RUN printf '#!/bin/sh\n# ボリュームマウント後に実行するため、ループで待機\nfor i in $(seq 1 30); do\n  if [ -f /home/ansible/.ssh/ansible_key.pub ]; then\n    cat /home/ansible/.ssh/ansible_key.pub > /home/ansible/.ssh/authorized_keys\n    chmod 600 /home/ansible/.ssh/authorized_keys\n    chown ansible:ansible /home/ansible/.ssh/authorized_keys\n    break\n  fi\n  sleep 0.5\ndone\n/usr/sbin/sshd -D\n' > /entrypoint.sh && \
    chmod +x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
