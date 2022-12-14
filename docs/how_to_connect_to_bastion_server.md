# 踏み台サーバーへの接続方法

## 前提

- [Session Manager Plugin](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-macos)がローカルPCにインストールされていること

## 手順

環境変数の設定

```bash
PROFILE='hoge'
ENV_ABBR='prd'
NAME='example'
INSTANCE_NAME="${ENV_ABBR}-${NAME}-bastion"
INSTANCE_ID=$(
    aws --profile "${PROFILE}" \
        ec2 describe-instances \
        --filter "Name=tag:Name,Values="${INSTANCE_NAME}"" \
        --query 'Reservations[].Instances[].InstanceId' \
        --output text
)
```

踏み台サーバーへの接続

```bash
aws --profile "${PROFILE}" \
    ssm start-session \
    --target "${INSTANCE_ID}"
```
