# IAM as Code (Terraform, AzureAD)

This folder contains a **minimal Terraform example** that treats IAM building blocks as code:

- Business role groups (e.g. `GRP_BR_STORE_EMPLOYEE`)
- Application groups (e.g. `GRP_APP_POS_USER`)
- Simple mapping between business roles and app groups

The goal is **not** to build a full tenant, but to show how the identity model from `00_docs/` can be expressed as Terraform.

---

## 1. Requirements

- Terraform installed (>= 1.5)
- Azure CLI logged in (`az login`)
- Permissions in the tenant to:
  - read and create Azure AD groups

---

## 2. Providers

This example uses the **AzureAD provider**:

```hcl
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.48"
    }
  }
}

provider "azuread" {
  # Uses your current Azure CLI context
}
```

You may need to set the tenant explicitly:
```hcl
provider "azuread" {
  tenant_id = "<your-tenant-id>"
}
```

## 3. What this code does

- Creates a few business role groups:
  - `GRP_BR_STORE_EMPLOYEE`
  - `GRP_BR_STORE_MANAGER`
  - `GRP_BR_VENDOR_USER`
- Creates a few application groups:
  - `GRP_APP_POS_USER`
  - `GRP_APP_M365_STORE_TEAM`
- Demonstrates nested group assignments:
  - business role groups are members of app groups
→ `STORE_EMPLOYEE` → POS + M365 Store Team

There are **no users defined** here – in a real setup, joiner/mover/leaver logic would add users to the business-role groups.

## 4. Usage

```bash
cd 02_infra/terraform

# init
terraform init

# see what would be created
terraform plan

# apply (if you want to create the groups)
terraform apply
```

To clean up again:
```bash
terraform destroy
```

## 5. Safety note
This code **will create real groups** in your Azure AD tenant if you run `terraform apply`.

If you only want to use it as a conceptual example for an interview, `terraform plan` is enough to demonstrate how IAM could be handled as code.


## Runbook (local)

### Prereqs
- Azure CLI logged in: `az login`
- Terraform >= 1.6
- jq (WSL): `sudo apt-get install -y jq`

### Deploy
```bash
terraform init
terraform plan
terraform apply
```

### Verify
```bash
./scripts/verify.sh
```

### Destroy
```bash
./scripts/destroy.sh
```