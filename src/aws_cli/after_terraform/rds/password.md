# 作成対象

RDSのマスターユーザーのパスワードの更新

# 作成手順

## 環境変数の設定

設定

```bash
PROFILE='hoge'
ENV_ABBR='prd'
NAME='example'
```

確認

```bash
echo "${PROFILE}"
echo "${ENV_ABBR}"
echo "${NAME}"
```

## パスワードの更新

```bash
aws --profile "${PROFILE}" \
    rds modify-db-instance \
    --db-instance-identifier "${var.common["env_abbr"]}-${var.common["name"]}-rds"
    --name "${ENV_ABBR}-${NAME}-rds-password" \
    --master-user-password 'ModifiedPassword!' \ # 本当のパスワードはソースコード外で管理する
```
