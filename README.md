# Minecraft Server

## 実行コマンド

```sh
terraform init
terraform plan
terraform apply
```

## ログインコマンド

```sh
aws sso login --profile <account>
```

## tflint

```sh
tflint --recursive --config="~/.tflint.hcl"
```

## Secrets Manager

Terraform の変数値は Secrets Manager の `/minecraft/terraform-prd` に JSON で保存します。

```json
{
  "ssh_ip": ["0.0.0.0"],
  "slack_channel_id": "C0123456789",
  "slack_team_id": "T0123456789",
  "slack_bot_token": "xoxb-your-token-here"
}
```

## terraform-docs

```sh
terraform-docs markdown table --output-file README.md
```

<!-- BEGIN_TF_DOCS -->


## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
