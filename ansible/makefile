.PHONY: ssh lint deploy

# .env ファイルから YAML 変数を抽出
SSH_IP = $(shell grep '^ssh_ip:' .env 2>/dev/null | sed 's/ssh_ip:[[:space:]]*//; s/"//g' || echo "minecraft-server")

ssh:
	ssh -i ~/.ssh/ansible_key -p 22 ansible@$(SSH_IP)

lint:
	ansible-lint --write

ENV=development
deploy:
	ansible-playbook -i inventories/$(ENV)/hosts $(ENV).yml
