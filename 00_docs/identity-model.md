# Identity Model

Dieses Dokument beschreibt, **wer** im System existiert und **welche Rollen* es gibt.
Fokus: Retail-Umfeld mit Filialen, Zentrale, IT und externen Dienstleidtern (Vendors).

---

## 1. Identitätstypen (User Types)

### 1.1 Interne Mitarbeitende - Store

- **Store Employee**
  - Arbeiten in der Filiale (Verkauf, Kasse, Vorbereitung).
  - Brauchen nur Zugriff auf:
    - Kassensystem (indirekt, über Rollen)
    - wenige M365-Bereiche (z.B. Filial-Infos)
  - **Kein** Admin, kein Zugriff auf zentrale Systeme.

- **Store Manager**
  - Verantwortlich für eine oder mehrere Filialen.
  - Zusätzlich zu Store Employee:
    - Reporting / Auswerungen
    - Kommunikation mit HQ
    - ggf. Freigaben (z.B. Urlaube, einfache Workflows)

---

### 1.2 Interne Mitarbeitende - HQ (Zentrale)

- **HQ Operations**
  - Planen und steuern Filialbetrieb (Aktionen, Preise, Prozesse).
  - Zugriff auf:
    - M365 (Teams, SharePoint)
    - Fachanwendungen (z.B. Warenwirtschaft, Planung)
  - Keine technischen Admin-Rechte.

- **HQ Finance / Controlling**
  - Arbeiten mit Finanz- / Controlling-Daten.
  - Zugriff auf:
    - Finance-Systeme
    - bestimmte Berichte / Auswertungen
  - Kein Zugriff auf technische IAM-Funktionen.

- **HQ IT / Support**
  - 1st/2nd Level IT-Support.
  - Zugriffe auf:
    - Ticketsystem
    - Basis-Adminaktionen (z.B. Passwort-Reset, Lizenzzuweisung im Rahmen von Policies)
  - **Kein Vollzugriff** auf Security-Einstellungen.

---

### 1.3 IAM / Admin

- **IAM Platform Engineer**
  - Implementiert IAM-Policies und Automatisierung.
  - Zugriff auf:
    - Entra ID-Konfiguration (Gruppen, Rollen, Policies - im Rahmen des Modells)
    - Logs / Audit (Read)
  - Kein genereller Global Admin.

- **Entra / M365 Admin (Elevated)**
  - Stark eingeschränkt, idealerweise:
    - Break-glass-Account
    - PIM / JIT aktiviert (Just-in-Time Elevation)
  - Wird nur im Notfall verwendet.

---

### 1.4 Externe

- **Vendor User**
  - Externe Dienstleiser (z.B. IT-Partner, Kassensystem-Betreuer).
  - Brauchen:
    - Zugriff auf bestimmte Systeme (Ticketsystem, Monitoring, ggf. Remote Maintenance)
    - **zeitlich begrenzten** Zugriff
  - Strenger Lifecycle (Start-/Enddatum, regelmäßige Reviews).

- **Guest User**
  - Kurzfristige Zugriffe, z.B.:
    - Projektpartner
    - Berater
  - Zugriff auf:
    - Einzelne M365-Ressourcen (Teams, SharePoint)
  - Noch stärker begrenzter Lifecycle als Vendor.

---

## 2. Rollenmodell (Business Roles)

Busines Roles beschreiben **was jemand fachlich macht**, nicht wie Rechte technisch zugeordnet werden.

### 2.1 Übersicht Business Roles

- `STORE_EMPLOYEE`
- `STORE_MANAGER`
- `HQ_OPERATIONS`
- `HQ_FINANCE`
- `HQ_IT_SUPPORT`
- `IAM_PLATFORM_ENGINEER`
- `GLOBAL_ADMIN_EMERGENCY` (Break Glass)
- `VENDOR_USER`
- `GUEST_USER`

Diese Rollen dienen als Basis, um später Gruppen / rechnische Rollen zu definiren.

---

## 3. Technische Rollen / Gruppen (RBAC)

Technisch werden Berechtigungen über **Gruppen** und **Rollen** zugewiesen.
Vereinfacht: **User → (Business Role) → Gruppen → Rechte**.

### 3.1 Namenskonvention (Beispiel)

- **Business-Rollen-Gruppen**:
  - `GRP_BR_STORE_EMPLOYEE`
  - `GRP_BR_STORE_MANAGER`
  - `GRP_BR_HQ_OPERATIONS`
  - `GRP_BR_HQ_FINANCE`
  - `GRP_BR_HQ_IT_SUPPORT`
  - `GRP_BR_IAM_PLATFORM_ENGINEER`
  - `GRP_BR_VENDOR_USER`
  - `GRP_BR_GUEST_USER`

- **Applikationsspezifische Gruppen (Rollen in Apps)**:
  - `GRP_APP_POS_USER` (Kassensystem - regulärer Nutzer)
  - `GRP_APP_POS_ADMIN` (Kassensystem - Admin / Vendor)
  - `GRP_APP_M365_STORE_TEAM` (Teams/SharePoint für Stores)
  - `GRP_APP_M365_HQ_TEAM` (Teams/SharePoint für HQ)
  - `GRP_APP_FINANCE_READ`
  - `GRP_APP_FINANCE_ADMIN`

---

### 3.2 Mapping Business Role → Gruppen

| Business Role           | Basis-Gruppen                             | Typische App-Gruppen                      |
|-------------------------|-------------------------------------------|-------------------------------------------|
| STORE_EMPLOYEE          | `GRP_BR_STORE_EMPLOYEE`                   | `GRP_APP_POS_USER`, `GRP_APP_M365_STORE_TEAM` |
| STORE_MANAGER           | `GRP_BR_STORE_MANAGER`                    | `GRP_APP_POS_USER`, `GRP_APP_M365_STORE_TEAM`, Reporting-Gruppen |
| HQ_OPERATIONS           | `GRP_BR_HQ_OPERATIONS`                    | `GRP_APP_M365_HQ_TEAM`, fachliche Apps    |
| HQ_FINANCE              | `GRP_BR_HQ_FINANCE`                       | `GRP_APP_FINANCE_READ`, `GRP_APP_M365_HQ_TEAM` |
| HQ_IT_SUPPORT           | `GRP_BR_HQ_IT_SUPPORT`                    | ITSM/Ticketsystem-Gruppen                 |
| IAM_PLATFORM_ENGINEER   | `GRP_BR_IAM_PLATFORM_ENGINEER`            | IAM-bezogene Admin-/Reader-Gruppen        |
| VENDOR_USER             | `GRP_BR_VENDOR_USER`                      | z.B. `GRP_APP_POS_ADMIN`, Support-Gruppen |
| GUEST_USER              | `GRP_BR_GUEST_USER`                       | spezifische M365-Teams / SharePoint-Sites |

**Wichtig:**  
- Business-Rollen-Gruppen enthalten **nur User**, keine Rechte direkt.  
- App-Gruppen enthalten **Rechte** und werden von Business-Rollen referenziert (z.B. verschachtelte Gruppen oder Role Assignments).

---

## 4. RBAC-Grundprinzipien in diesem Modell

1. **Least Privilege**
   - Jede Business Role bekommt nur die Rechte, die sie fachlich braucht.
   - Vendor- und Guest-Rollen sind **strenger** als interne Rollen.

2. **Trennung von Usern und Rechten**
   - User → Business-Rollen-Gruppen
   - Business-Rollen-Gruppen → App-/Ressourcen-Gruppen
   - Erleichtert Audit und Lifecycle.

3. **Kein "All-in-One-Admin"**
   - Admin-Rechte sind:
     - stark begrenzt,
     - idealerweise JIT (PIM),
     - sauber auditiert.

4. **Retail-spezifische Besonderheit**
   - Store-Mitarbeitende haben nur **funtionale Rechte**.
   - Zentrale (HQ) hat fachlich breitere, aber immer noch klar abgetrennte Rollen.

---

## 5. Wie dieses Modell später im Code auftaucht

In `02_infra/terraform` werden wir exemplarisch:

- einige **Business-Rollen-Gruppen** definieren (z.B. `GRP_BR_STORE_EMPLOYEE`, `GRP_BR_VENDOR_USER`),
- eine oder zwei **App-Gruppen** (z.B. `GRP_APP_POS_USER`),
- und zeigen, wie man **User → Gruppen → Rechte** modellieren könnte.

Ziel ist **nicht**, den ganzen Tenant abzubilden, sondern zu zeigen:

> "IAM kann man wie Infrastruktur behandeln - mit klaren Namen, Strukturen und Zuordnungen."