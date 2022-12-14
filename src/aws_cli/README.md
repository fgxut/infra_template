# 概要

AWS CLIで作成したリソースの内容と作成手順について記載する。
AWSリソースは基本的にTerraformで作成するが、Terraformで作成できなかったり作成しづらかったりするリソースはAWS CLIで作成する。

`before_terraform/`にはTerraformをapplyする前に実行する必要があるAWS CLIを格納し、
`after_terraform/`にはTerraformをapplyした後に実行する必要があるAWS CLIを格納する。