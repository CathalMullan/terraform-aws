#!/usr/bin/env bash
set -euxo pipefail

# terraform
terraform validate
terraform fmt -recursive .

# tflint
tflint --init
tflint environment/prod
