# 概要

Terraformを操作する際の事前準備と実行手順について記載する。

# 事前準備

## tfenv

`tfenv`によって指定の`terraform version`が使用される。
(<https://github.com/tfutils/tfenv#terraform-version-file>)

```bash
brew install tfenv
tfenv install $(cat environment/production/.terraform-version)
tfenv use $(cat environment/production/.terraform-version)
```

## AWS Profile

`hoge`という名前で[AWSプロファイル](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-profiles.html)を設定する。

## git-secretsの例外パターン設定

ローカル開発環境で`git-secrets`をインストールすることにより、`account_id = "XXXX"`が禁止パターンに合致し、コミットに失敗してしまう。
そのため、以下のコマンドを実行し、その文字列のみを例外パターンとして設定する。

```bash
git secrets --add --allowed "account_id\s=\s\".*\""
```

## 実行手順

### 各環境を操作する方法

```bash
# 操作する環境の選択
cd environment/production/

# 作業ディレクトリの初期化
terraform init
```

### 基本コマンド

```bash
# コードのバリデート
terraform validate

# インフラに加える変更の確認
terraform plan

# インフラに加える変更の実行
terraform apply
```

### formatter

```bash
terraform fmt -recursive
```
