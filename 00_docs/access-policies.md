# Access Policies (MFA / Conditional Access / Guest & Vendor Governance)

In diesem Dokument werden die wichtigsten **Access Policies** beschrieben, die in einem Retail-Umfeld mit Entra ID / M365 sinvoll sind.
Fokus: **pragmatisch + riskoorientiert**, nicht "Zero Trust deluxe".

---

## 1. MFA (Multi-Factor Authentication)

### 1.1 Standard-Policy

- **MFA obligatorisch** für alle internen User
- Registrierung bei Joiner-Prozess
- Unterstützte Faktoren:
  - Authenticator App
  - Hardware Tokens (optional)
  - Kein SMS als bevorzugter Faktor (nur Fallback)
- Kein genereller „MFA Skip“ für interne Mitarbeitende

**Begründung:** Retail hat viel Fluktuation → MFA schützt schwache Passwörter.

---

## 2. Conditional Access (CA)

Conditional Access wird als **Kontext-Schicht** verstanden:

- **Wer** (Identity)
- **Was** (App/Asset)
- **Womit** (Device)
- **Woher** (Location)
- **In welchem Zustand** (Risk Level)

---

### 2.1 CA – Minimales Baseline-Set

**CA-01 – Require MFA**
- Ziel: Alle internen User
- Exceptions: Service Accounts (falls notwendig)
- Enforcement: sofort / strenger

**CA-02 – Block Legacy Auth**
- Blockiert POP/IMAP/SMTP Basic Auth
- Kritisch für Retail mit M365-Nutzung

**CA-03 – Guest + Vendor Restriction**
- Guest/Vendor dürfen nur auf definierte Apps/Teams/SharePoint-Sites zugreifen
- Kein globaler Tenant Access

**CA-04 – Admin Elevation Guard**
- Admin-Rollen (IAM / M365) mit:
  - MFA strong
  - ggf. JIT (PIM)
  - keine unsicheren Standorte / riskanten Devices

---

### 2.2 CA – App-Surface (vereinfachtes Retail-Beispiel)

| App               | Policy                                    | User-Typen |
|------------------|-------------------------------------------|-----------|
| M365 (Teams/SpO) | Require MFA + Standard CA                  | alle      |
| POS (indirekt)   | Nicht direkt CA, aber Vendor-Kontrolle     | Vendor    |
| Finance-Tools    | Strong MFA + ggf. Device Compliance        | HQ/Finance|
| IAM Admin        | Strong MFA + PIM + Admin CA                | Admin     |

**Anmerkung:** Retail hat oft **POS-Systeme** mit Vendor-Zugriff → das ist eine Sonderzone.

---

## 3. Guest & Vendor Policies

Retail-Kontext macht externe Nutzer **kritischer als interne**:

- Vendor = oft erhöhte Tech-Rechte
- Guests = Datenzugriff (SharePoint/Teams)
- Beide ≠ HR-geführt → Gefahr von Forgotten Accounts

---

### 3.1 Vendor Access Policy

- Vendor immer als **Guest** oder **Vendor-User** im Tenant
- Pflichtangaben:
  - Firma
  - Zweck
  - Verantwortliche interne Person
  - Start-/Enddatum (mandatory)
- Zuweisung zu **Vendor-Business-Role** (`VENDOR_USER`)
- Keine vollwertigen internen Konten
- MFA verpflichtend
- CA aktiviert
- Kein „unlimited tenant visibility“
- Optional: Device- oder Location-Filter

---

### 3.2 Guest Access Policy

- Scope minimal → project-basiert
- Zugriff per Invite
- Standard-MFA
- Auto-Expire (z.B. 90 Tage Inaktivität)
- Nur SharePoint/Teams standardmäßig

Guests sind beratungs-/projektlastig → daher eher kurzzyklisch.

---

## 4. Device Policies (optional, aber realistisch)

Retail = viele nicht-verwaltete Geräte in Filialen + private Geräte bei HQ.

Minimaler Ansatz:

- Kein Device-Compliance-Zwang für Stores (realistisch!)
- Device-Compliance für:
  - Finance
  - Admin
  - IAM

**Admin ohne Compliance** → hohes Risiko → vermeiden.

---

## 5. Risk Policies (Identity Protection – high level)

Retail-Umfeld kann von **Risk-Signals** profitieren, z.B.:

- Sign-in Risk (z.B. impossible travel)
- User Risk (kompromittiertes Konto)
- MFA Enforce bei Risk Events

→ optional, aber modern.

---

## 6. Admin Access Policies (Elevated Roles)

Retail-IAM braucht klare Trennung:

**Admin-01 – Break-Glass Account**
- Passwort im Tresor
- Kein MFA (sonst Chicken-Egg)
- Nie nutzen außer Notfall

**Admin-02 – JIT Elevation (PIM)**
- Admin-Rechte **nicht dauerhaft**
- Freigabe + Audit

**Admin-03 – Separation of Duties**
- IT-Support ≠ IAM ≠ Security ≠ Finance

---

## 7. Minimaler Policy-Outcome

Ziel ist kein „Perfektionismus“, sondern **realer Betrieb**:

- MFA überall
- CA für kritische Apps/Rollen
- Vendor/Guest unter Kontrolle
- Admins nicht „always-admin“
- Kein Wild-West-Rechtezoo
- Kein Offboarding mit Restrechten

Dieses Set ist bewusst **umsetzbar**, nicht PowerPoint-Zero-Trust.