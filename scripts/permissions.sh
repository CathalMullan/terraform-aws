#!/usr/bin/env bash
set -euxo pipefail

iamlive \
  --set-ini \
  --account-id "$(aws sts get-caller-identity | jq -r .Account)" \
  --sort-alphabetical \
  --refresh-rate 1 \
  --output-file permissions.json
