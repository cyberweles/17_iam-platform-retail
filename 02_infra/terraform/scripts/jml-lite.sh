#!/usr/bin/env bash
set -euo pipefail

PREFIX="retail-iam"

USER_ID=$(az ad signed-in-user show --query id -o tsv)
G_EMP=$(az ad group show --group "${PREFIX}-GRP_BR_STORE_EMPLOYEE" --query id -o tsv)
G_MGR=$(az ad group show --group "${PREFIX}-GRP_BR_STORE_MANAGER"  --query id -o tsv)

echo "USER_ID: $USER_ID"
echo "JOINER: add -> ${PREFIX}-GRP_BR_STORE_EMPLOYEE"
az ad group member add --group "$G_EMP" --member-id "$USER_ID" || true

echo "MOVER: employee -> manager"
az ad group member remove --group "$G_EMP" --member-id "$USER_ID" || true
az ad group member add    --group "$G_MGR" --member-id "$USER_ID" || true

echo "LEAVER: remove -> manager"
az ad group member remove --group "$G_MGR" --member-id "$USER_ID" || true

echo "Done. Check AuditLogs in ~2-5 minutes."
