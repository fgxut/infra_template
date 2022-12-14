# 作成対象

Terraformのtfstateを保存するS3バケット

# 作成手順

## 環境変数の設定

設定

```bash
PROFILE='hoge'
AWS_ACCOUNT='123456789123'
ENV='production'
ENV_ABBR='prd'
NAME='example'
BUCKET="${ENV_ABBR}-${NAME}-tfstate-${AWS_ACCOUNT}"
```

確認

```bash
echo "${PROFILE}"
echo "${AWS_ACCOUNT}"
echo "${ENV}"
echo "${ENV_ABBR}"
echo "${NAME}"
echo "${BUCKET}"
```

## バケットの作成

```bash
aws --profile "${PROFILE}" \
    s3api create-bucket \
    --bucket "${BUCKET}" \
    --create-bucket-configuration LocationConstraint=ap-northeast-1
```

## パブリックアクセスブロックの有効化

```bash
aws --profile "${PROFILE}" \
    s3api put-public-access-block \
    --bucket "${BUCKET}" \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

## バケットの暗号化

```bash
aws --profile "${PROFILE}" \
    s3api put-bucket-encryption \
    --bucket "${BUCKET}" \
    --server-side-encryption-configuration '{
        "Rules":[
            {
                "ApplyServerSideEncryptionByDefault":{
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }'
```

## SSLのリクエストのみを許可するバケットポリシーの設定

```bash
cat << EOF > policy.json
{
    "Id": "AllowSSLRequestsOnlyPolicy",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowSSLRequestsOnly",
            "Action": "s3:*",
            "Effect": "Deny",
            "Resource": [
                "arn:aws:s3:::${BUCKET}",
                "arn:aws:s3:::${BUCKET}/*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            },
            "Principal": "*"
        }
    ]
}
EOF

aws --profile "${PROFILE}" \
    s3api put-bucket-policy \
    --bucket "${BUCKET}" \
    --policy file://policy.json
```

## バケットへのタギング

```bash
aws --profile "${PROFILE}" \
    s3api put-bucket-tagging \
    --bucket "${BUCKET}" \
    --tagging "TagSet=[{Key=Name,Value=${BUCKET}},{Key=env,Value=${ENV}}]"
```

## バージョニングの有効化

```bash
aws --profile "${PROFILE}" \
    s3api put-bucket-versioning \
    --bucket "${BUCKET}" \
    --versioning-configuration Status=Enabled
```
