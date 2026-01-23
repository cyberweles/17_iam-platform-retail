# Audit & Compliance (Retail IAM)

IAM ohne Audit ist operational nicht steuerbar und compliance-seitig nicht haltbar.
Retail hat dabei eine besondere Lage: viele User, hohe Fluktuation, externe Vendoren, wenig Toleranz für Friktion.

Diese Dokument beschreibt, was sinnvoll **geloggt, reviewed und dokumentriert** wird.

---

## 1. Audit – Was wird geloggt?

### 1.1 Identity Lifecycle
- Joiner (Anlage)
- Mover (Rollenwechsel)
- Leaver (Deaktivierung)

Wichtig: Lifecycle muss **tracebar** sein:
- wer hat angelegt/entfernt?
- wann?
- welche Rolle?

---

### 1.2 Vendor & Guest Events
- Vendor Add
- Vendor Change
- Vendor Removal
- Guest Invite
- Guest Removal / Auto-Expire

Vendor/Guests = **höchstes Risiko** → daher eigene Auditpunkte.

---

### 1.3 Admin Events
Admin-Ebene verdient immer dedizierte Events:

- Admin-Login
- Admin-Elevation (PIM/JIT)
- Admin-Role-Assignment
- Admin-Role-Removal
- Break-Glass-Nutzung

Break-Glass muss **explizit** geloggt werden → selten + auditiert.

---

### 1.4 Access Changes
Änderungen bei:
- Gruppen
- Rollen
- App-Berechtigungen

Nicht jedes Detail → aber jede **Änderung am Modell**.

---

## 2. Compliance – Was wird reviewed?

Compliance ≠ "Security Theater". Reviews sollen **Probleme wirklich finden**.

### 2.1 Leaver Review (monatlich)
Prüft:
- sind ehemalige Mitarbeitende entfernt worden?
- existieren noch Konten ohne HR-Zuordnung?

---

### 2.2 Vendor Review (monatlich/vierteljährlich)
Prüft:
- sind Vendoren aktiv?
- haben sie noch gültige Verträge/Zwecke?
- existieren verwaiste Vendor Accounts?

Vendor Review = Retail Pflicht (realistisch).

---

### 2.3 Elevated Roles Review (vierteljährlich)
Prüft:
- wer hat Admin-/IAM-Rechte?
- wurden sie wirklich benötigt?
- PIM-Elevations vs. tatsächliche Nutzung

---

### 2.4 Guest Review (90 Tage)
Ziel: Minimierung von „Guest-Friedhof“.

---

## 3. Reporting – Was wird reported?

### 3.1 Identity Lifecycle Report
- Joiner/Mover/Leaver Zahlen pro Monat
- optional: Zeit bis Provisioning/Deprovisioning

---

### 3.2 Vendor & Guest Report
- Anzahl aktiver Vendoren
- Anzahl aktiver Guests
- Anzahl abgelaufener / expired Accounts

---

### 3.3 Admin & Elevated Access Report
- Admin-Konten
- PIM-Elevations
- Break-Glass-Ereignisse

---

## 4. Verantwortlichkeiten (Ownership Model)

IAM kann nur funktionieren, wenn klar ist, **wer was verantwortet**.

Retail Beispielmodell:

| Bereich | Verantwortung |
|--------|---------------|
| HR | Joiner/Mover/Leaver Trigger |
| Store Manager | Bestätigung Store-Rollen |
| HQ | fachliche Rollen |
| IT Support | Passwort / technischer Support |
| IAM | Rollenmodell & Policies |
| Security | Audit & Review & Guidelines |
| Vendor Owner | Vendor Lifecycle |
| Revision | unabhängiger Audit |

---

## 5. Integration in Terraform / IaC (light)

Audit/Compliance kann durch IaC unterstützt werden:

- Rollen/Groups als Code → nachprüfbar
- keine "Manual Admin"-Änderungen
- PR-Review als Security/Kontrolle
- Git-Historie = Audit-Log light

Very powerful für Retail, ohne Overkill.

---

## 6. Minimaler Compliance Outcome

Das Ziel ist **nicht Perfektion**, sondern ein Zustand, in dem:

- Konten nicht vergessen werden
- Vendoren nicht ewig hängen
- Admins nicht „always-admin“ sind
- Gäste regelmäßig auslaufen
- Lifecycle nachvollziehbar ist
- Reviews realistische Fehler finden

---

## 7. Entscheidender Satz (IAM in Retail)

> "IAM muss hier nicht fancy sein – es muss funktionieren, nachvollziehbar sein und den Betrieb nicht behindern."