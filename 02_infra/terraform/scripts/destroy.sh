#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "[WARNING]  This will DESTROY Azure resources and Entra groups created by this Terraform config."
echo "    Working dir: $(pwd)"
echo

read -r -p "Type DESTROY to continue: " CONFIRM
if [[ "$CONFIRM" != "DESTROY" ]]; then
  echo "Aborted."
  exit 1
fi

terraform destroy
