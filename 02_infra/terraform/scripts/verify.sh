#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

# ----- Config (minimal, hard-coded for now) -----
PREFIX="retail-iam"
RG_NAME="rg-${PREFIX}"
EXPECTED_READER_GROUP="${PREFIX}-GRP_APP_AZ_BASELINE_READ"
EXPECTED_CONTRIB_GROUP="${PREFIX}-GRP_APP_AZ_BASELINE_CONTRIBUTOR"

# ----- Azure baseline -----
echo "[Azure] Checking Resource Group: ${RG_NAME}"
RG_ID="$(az group show -n "$RG_NAME" --query id -o tsv)"
echo "[OK] RG exists: ${RG_NAME}"

echo "[Azure] Checking Log Analytics Workspace: law-${PREFIX}"
az monitor log-analytics workspace show -g "$RG_NAME" -n "law-${PREFIX}" >/dev/null
echo "[OK] LAW exists: law-${PREFIX}"

# ----- RBAC -----
echo "[Azure] Checking RBAC assignments on scope: ${RG_ID}"
ASSIGNMENTS="$(az role assignment list --scope "$RG_ID" --query "[].{role:roleDefinitionName,principal:principalName}" -o json)"

echo "[OK] RBAC assignments fetched"
echo "$ASSIGNMENTS" | jq -r '.[] | "\(.role)\t\(.principal)"' | column -t || true

echo "[Azure] Validating expected RBAC principals..."
echo "$ASSIGNMENTS" | jq -e --arg g "$EXPECTED_READER_GROUP" '
  any(.[]; .role=="Reader" and (.principal|tostring|contains($g)))
' >/dev/null
echo "[OK] Reader assigned to: ${EXPECTED_READER_GROUP} (name match)"

echo "$ASSIGNMENTS" | jq -e --arg g "$EXPECTED_CONTRIB_GROUP" '
  any(.[]; .role=="Contributor" and (.principal|tostring|contains($g)))
' >/dev/null
echo "[OK] Contributor assigned to: ${EXPECTED_CONTRIB_GROUP} (name match)"

# ----- Entra groups (existence) -----
echo "[Entra] Checking group existence (via Microsoft Graph CLI)..."
if ! command -v az >/dev/null; then
  echo "[X] az CLI not found"
  exit 1
fi

# Graph queries (requires: az extension add --name account OR built-in; but we will use: az ad group show works with Azure CLI AAD)
# Note: az ad uses legacy AAD Graph in older setups; in many tenants it still works.
# We keep it minimal: check that groups can be resolved.

for g in \
  "${PREFIX}-GRP_BR_STORE_EMPLOYEE" \
  "${PREFIX}-GRP_BR_HQ_FINANCE" \
  "${PREFIX}-GRP_BR_IAM_PLATFORM_ENGINEER" \
  "${PREFIX}-GRP_BR_VENDOR_USER" \
  "${PREFIX}-GRP_APP_POS_USER" \
  "${PREFIX}-GRP_APP_FINANCE_READ" \
  "${PREFIX}-GRP_APP_M365_STORE_TEAM" \
  "${PREFIX}-GRP_APP_AZ_BASELINE_READ" \
  "${PREFIX}-GRP_POL_INTERNAL_USERS" \
  "${PREFIX}-GRP_POL_ADMIN_ELEVATED"
do
  az ad group show --group "$g" >/dev/null
  echo "[OK] Group exists: $g"
done

echo
echo "[OK] verify.sh OK"
