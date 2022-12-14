# 作成対象

SSMパラメータストアに保存したパラメータの更新

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

## パラメータの更新

```bash
aws --profile "${PROFILE}" \
    ssm put-parameter \
    --name "${ENV_ABBR}-${NAME}-rds-password" \
    --type SecureString \
    --value 'ModifiedPassword!' \ # 本当のパスワードはソースコード外で管理する
    --overwrite
```
