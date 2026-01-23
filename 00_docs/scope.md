# Scope

Dieses Projekt definiert einen **vereinfachten IAM-Ansatz** für ein Retail-ähnliches Unternehmen mit Entra ID / M365 als zentralem Identity-System.

---

## Im Scope

- **Identitätstypen**
  - Store-Mitarbeitende
  - Store-Leitung
  - HQ-Mitarbeitende
  - IT / IAM / Admnin
  - Vendors / Guests (externe)

- **Rollen- und Berechtigungsmodell (RBAC)**
  - Basisrollen für Store / HQ
  - Admin-/Elevated-Rollen für IT/IAM
  - Abgrenzung Vendor / Guest

- **Lifecycle**
  - Joiner / Mover / Leaver für interne Mitarbeitende
  - Separater Lifeczcle für Vendors / Guests

- **Access Policies (High Level)**
  - MFA / Conditional Access Surface
  - Guest / Vendor Governance (zeitlich begrenzter Zugriff, Review)

- **Risken & Controls**
  - typische IAM-Risken benennen
  - passende Kontrollen skizzieren

- **Infra as Code (minimal)**
  - Terraform-Beispiele für:
    - Gruppen
    - Rollen / Role Assignments (vereinfacht)
    - ggf. dynamische Gruppen

---

## Out of Scope

- Vollständige Zero-Trust-Architektur
- Detaillierte technische Implementierung von:
  - SCIM-Provisioning
  - HR-Schnittstellen
  - Konkreten Saas-Integrationen
- Konkrete Produktkonfiguration (keine echten Tenant-Daten)
- SOC / SIEM / Incident Response

---

## Zielbild

Am Ende soll klar erkennbar sein:

- **Wer** existiert im System (Identity Model),
- **welche Rollen** und Zugriffe es gibt (RBAC),
- **wie Identitäten über die Zeit leben** (Lifecycle),
- **wie man Risken reduziert** (Controls, Policies),
- und **wie Teile davon als Code modelliert werden können** (Terraform).

Dieses Projekt ersetzt keine produktive IAM-Lösung, sondern dient als **Denk- und Gesprächsgrundlage** für eine IAM Platform Engineer Rolle.