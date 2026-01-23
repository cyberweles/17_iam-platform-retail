# Decisions (IAM Platform — Retail Context)

Kurze, pragmatische Architekturentscheidungen (mini ADRs), um das Sandbox-Projekt technisch & fachlich einzuordnen.

---

## ADR-01 — Entra ID als Identity-Anker
**Decision:** Entra ID ist das Identity-System of Record.

**Context:** Retail-Umfeld mit M365, Store/HQ-Usern, Vendors/Guests und modernen SaaS-Anwendungen.

**Alternatives:**
- HR als SOR
- Custom IdP
- Federated Multi-IdP

**Why:** Entra ist im Retail/SME sehr häufig bereits vorhanden, Lifecycle & Policies gut integrierbar.

**Status:** Accepted

---

## ADR-02 — Business Roles vor App-Gruppen
**Decision:** Business-Rollengruppen (Store/HQ/Vendor/Guest) mappen auf App-Gruppen.

**Context:** Lifecycle-Änderungen passieren auf Business-Ebene (Mover!); Anwendungen sollen nur Rollen konsumieren.

**Alternatives:**
- Per-App-Berechtigungen direkt an User
- Application-first RBAC

**Why:** Reduziert Overprivilege, erleichtert Mover/Leaver und Audit, bessere Governance.

**Status:** Accepted

---

## ADR-03 — Vendors als eigene Lifecycle-Spur
**Decision:** Vendors laufen auf separatem Lifecycle (Add → Review → Removal).

**Context:** Vendors haben keinen HR-Trigger; typische Retail-Risiken: vergessen, zu lange aktiv, falsche Rechte.

**Alternatives:**
- Gleichbehandlung mit Store/HQ
- Tickets only (manuell)

**Why:** Andere Risikolandschaft, verschiedene Owner, andere Compliance-Anforderungen.

**Status:** Accepted

---

## ADR-04 — Policies vor Features
**Decision:** IAM wird policy-first modelliert (MFA/CA/Guest/Vendor), nicht feature-first.

**Context:** Retail braucht klare Security-Guardrails, Lifecycle ändert sich oft schneller als Features.

**Alternatives:**
- Feature-first (Tools/Capabilities)
- App-first (POS/M365)

**Why:** Policies sind stabil, Features nicht. Governance schlägt Technik.

**Status:** Accepted

---

## ADR-05 — Terraform als IaC-Mindestschicht
**Decision:** Terraform modelliert Gruppen/Rollen und Mapping (IAM as Code — minimal).

**Context:** Brownfield/Greenfield-Konvergenz ist einfacher mit IaC; Audit/History durch Git.

**Alternatives:**
- Portal-only (manuell)
- PowerShell-Skripte
- SCIM/HR-Automation (für später)

**Why:** Terraform ermöglicht Review, Audit, Wiederholbarkeit und Ownership.

**Status:** Accepted

---

## ADR-06 — Audit/Review als Pflicht, nicht Luxus
**Decision:** Leaver-, Vendor- und Admin-Reviews sind Teil des Modells.

**Context:** Retail hat hohe Fluktuation und Vendor-Abhängigkeit; Overprivilege wächst sonst leise.

**Alternatives:**
- Kein Review (häufig in KMU)
- Nur Leaver-Review

**Why:** Review = Risiko-Senke, Audit = Nachweisbarkeit.

**Status:** Accepted
