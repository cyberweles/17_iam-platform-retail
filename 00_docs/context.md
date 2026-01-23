# Kontext

Branche: **Retail / Food Service** (Filialen + Zentrale)
Identitätsplattform: **Entra ID / M365** als primäres Identity-System
Region: EU / Deutschland (Datenschutz, Revision, Betriebsrat im Hinterkopf)

---

## Organisation - grob

- **Stores / Filialen**
  - Store-Mitarbeitende (Kasse, Verkauf)
  - Store-Leitung (Filialleitung)

- **Zentrale (HQ)**
  - Operations / Bereichleitung
  - IT / IAM / Security
  - Finance / Controlling
  - HR

- **Externe**
  - **Vendors** (z.B. IT-Dienstleister, Kassensysteme, Wartung)
  - **Guests** (kurzfristige Zugriffe, Partner)

---

## Identity-Landschaft (vereinfacht)

- **Entra ID / M365**
  - Primäre Identitäten (User Accounts)
  - Gruppen / Rollen / RBAC
  - Conditional Access / MFA
  - Guest Accounts

- **HR-System (Upstream)**
  - Stammdaten: wer, Rolle, Start-/Enddatum
  - Triggert Joiner / Mover / Leaver

- **Fachanwendungen (Downstream)**
  - M365 (Teams, SharePoint, Exchange)
  - Backoffice / ERP (z.B. Warenwirtschaft)
  - Klassensysteme / POS (indirekt, über Rollen)
  - Ticketsystem / ITSM

---

## Warum IAM hier kritisch ist

- Viele Mitarbeitende mit **hoher Fluktuation** (Retail-typisch).
- Unterschiedliche Rollen und Verantworlichkeiten zwischen **Store** und **HQ**.
- Externe Dienstleister (Vendors) mit potenziell **kritischen Rechten**.
- Anforderungen aus **Compliance, Revision, Datenschutz**:
  - Wer hatte wann worauf Zugriff?
  - Wurden Rechte nach Austritt entfernt?
  - Sind Vendor-Accounts zeitlich begrenzt?

Dieses Projekt fokussiert sich auf **Identitäten, Rollen, Lifecycle und Governance** in genau so einem Umfeld.