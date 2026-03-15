# Ansible Docker Learning Environment

Ansible学習用のDocker環境です。ローカルでAnsibleをテストしてからEC2に適用できます。

## セットアップ

### 前提条件

- Docker & Docker Compose がインストール済み
- SSH クライアント がインストール済み

### 初回のみ: 初期セットアップ

```bash
chmod +x docker-init.sh
./docker-init.sh
```

このスクリプトは以下の処理を実行します：

1. SSH鍵生成（~/.ssh/ansible_key）
2. Dockerコンテナ起動
3. 公開鍵をコンテナに登録

### 毎回: 環境起動

```bash
docker-compose up -d
```

### 環境停止

```bash
docker-compose down
```

## 使用方法

### Ansibleコントローラーに接続

```bash
docker exec -it ansible-controller bash
```

### テストプレイブック実行（コントローラー内）

```bash
ansible-playbook -i inventories/docker/hosts docker-test.yml
```

### カスタムプレイブック実行

```bash
ansible-playbook -i inventories/docker/hosts your-playbook.yml
```

### 対話的にコマンド実行

```bash
ansible -i inventories/docker/hosts minecraft_servers -m command -a "uname -a"
```

## ディレクトリ構成

```sh
.
├── Dockerfile                          # ターゲットノード定義
├── docker-compose.yml                  # Docker環境定義
├── docker-setup.sh                     # セットアップスクリプト
└── ansible/
    ├── docker-test.yml                 # テストプレイブック
    └── inventories/
        └── docker/
            └── hosts                   # Docker環境用インベントリ
```

## トラブルシューティング

### SSH接続できない

```bash
# ホストキーの確認
ssh-keyscan -p 2222 localhost

# 手動接続テスト
ssh -i ~/.ssh/ansible_key -p 2222 ansible@localhost
```

### コンテナ内でansibleユーザーが見つからない

```bash
docker exec minecraft-server id ansible
```

### SSH鍵の権限エラー

```bash
chmod 600 ~/.ssh/ansible_key
chmod 700 ~/.ssh
```

## クリーンアップ

```bash
docker-compose down
rm ~/.ssh/ansible_key ~/.ssh/ansible_key.pub
```

## 次のステップ

1. **学習用プレイブック作成**: `ansible/` 配下で新しいプレイブックを作成
2. **EC2への適用**: `inventories/production/hosts` を更新して本番環境に対応
3. **ロール化**: `rules/` 配下でAnsibleロールを整備

## 参考リンク

- [Ansible 公式ドキュメント](https://docs.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
