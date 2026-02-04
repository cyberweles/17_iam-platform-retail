# 17 – IAM Platform (Retail, Entra ID)

This repo contains a small but realistic **Identity & Access Management (IAM) platform sketch** for a retail-like environment (stores + HQ) built around **Entra ID / M365**.

Goal:
- Model **identities, roles and lifecycle** (Joiner / Mover / Leaver).
- Show **how retail IAM actually lives**: employees, store managers, HQ, vendors, guests.
- Add a small **Terraform layer** to treat IAM as code (groups, roles, assignments).

The project is designed as:
- preparation for an **IAM Platform Engineer** role,
- a bridge between **Cloud / Security / Platform** thinking,
- and a portfolio-ready example of **IAM as a system, not just “logins”.**

---

## 1. Structure

```text
.
├── README.md
├── 00_docs
│   ├── context.md
│   ├── scope.md
│   ├── identity-model.md
│   ├── lifecycle.md
│   ├── access-policies.md
│   ├── risks-and-controls.md
│   ├── audit-and-compliance.md
│   └── decisions.md
├── 01_design
│   ├── diagrams
│   │   ├── iam-overview.drawio
│   │   └── iam-lifecycle.drawio
│   └── iam-design-notes.md
├── 02_infra
│   └── terraform
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
└── 99_meta
    └── notes.md
```

## 2. What this project covers
- Retail context: stores, HQ, vendors, guests.
- Identity model: user types + roles + RBAC.
- Lifecycle: Joiner / Mover / Leaver (including vendors/guests).
- Access policies: MFA, Conditional Access surface, guest/vendor governance.
- Risk & audit: typical IAM risks and how to control them.
- Infra as code (minimal): Terraform to model some identity objects.

What it does **not** cover:
- Full-blown Zero Trust design.
- Full SCIM implementation.
- Any real production secrets or configs (this is a concept sandbox, not a live setup).

## 3. How to read this repo
1. Start with `00_docs/context.md` and `scope.md` to understand the scenario.
2. Move to `identity-model.md` and `lifecycle.md` to see who exists and how they live.
3. Check `access-policies.md`, `risks-and-controls.md`, `audit-and-compliance.md` for governance.
4. Look at `01_design/diagrams` for a visual overview.
5. Finally, open `02_infra/terraform` to see how parts of IAM could be codified.

```sql
IAM Overview (Retail)

    HR System
        |
        v
   +-----------+
   | Identity  |  (Entra ID / M365)
   +-----------+
        |
        +--> Business Roles (Store/HQ/Vendor/Guest)
        |
        +--> Groups (RBAC)
        |
        +--> Policies (MFA / CA / Guest/Vendor)
        |
        v
   +----------------+
   | Applications   |
   |  (M365 / POS / |
   |   Finance / IT |
   |    Support)    |
   +----------------+
        |
        v
     Audit & Review
```

# 17 – IAM Platform (Retail, Entra ID) (v2.0)

This iteration translates the documented IAM architecture into a reproducible greenfield implementation in Azure using Terraform.

## What v2.0 implements
- **Entra ID group catalog (1:1 with the design docs):**
  - Business Roles (BR), Application/Access groups (APP), and Policy scope groups (POL)
- **Deterministic mappings:**
  - BR → APP nested membership (role-to-access)
  - BR → POL nested membership (targeting for Conditional Access policies)
- **Azure baseline:**
  - Resource Group + Log Analytics Workspace with a small tag baseline
- **Azure RBAC (group-based):**
  - `GRP_APP_AZ_BASELINE_READ` → Reader on the baseline RG
  - `GRP_APP_AZ_BASELINE_CONTRIBUTOR` → Contributor on the baseline RG
- **Lifecycle control:**
  - `scripts/verify.sh` validates baseline + RBAC + key Entra groups
  - `scripts/destroy.sh` provides a safe cleanup path

## What is intentionally out of scope (for now)
- User provisioning (joiner/mover/leaver)
- PIM / JIT elevation flows
- Access packages / entitlement management
- Full landing zone (policies, budgets, networking, MG hierarchy)
