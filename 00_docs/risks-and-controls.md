# Risks & Controls (IAM im Retail-Umfeld)

IAM hat im Retail-Umfeld eine besondere Risikolandschaft: viele User, hohe Fluktuation, Vendoren, interne/externe Rollen und oft wenig Zeit für tiefes Security-Design.

Das Ziel dieses Dokuments ist, die wichtigsten Risiken **konkret zu bennenen** und ihnen passende **Kontrollen** gegenüberzustellen

---

## 1. Lifecycle-Risiken (Joiner / Mover / Leaver)

### Risiko 1: **Leaver behalten Zugriffe**
- Ursache:
  - fehlende HR- oder Ticket-Schnittstelle
  - manuelle Prozesse
- Folgen:
  - Risiko des Missbrauchs durch ehemalige Mitarbeitende
  - Compliance- und Auditrisk
- Kontrolle"
  - klare Leaver-Kopplung HR → IAM
  - sofortige Deaktivierung am Enddatum
  - dokumentiertes Offboarding
  - periodische Access Reviews

---

### Risiko 2: **Mover sammelt Alt-Rechte**
- Ursache:
  - Rollenwechsel ohne Rechteenzug
  - keine "Rechte-Clean-Ups"
- Folgen:
  - Overprivilege / Shadow Admin Light
- Kontrolle:
  - Rollenwechsel = Entzug + Zuweisung
  - Lifecycle-Checks
  - least privilege Prinzip
  - Access Review bei Rollenwechsel

---

### Risiko 3: **Joiner startet ohne Zugriffe**
- Ursache:
  - verspätete HR-Daten
  - kein automatisiertes Provisioning
- Folgen:
  - Schwächen im operativen Betrieb
  - Workarounds / Schattenprozesse
- Kontrolle:
  - Pre-Provisioning (vor Startdatum)
  - Kurze Provisioning-Chain
  - Automatisierung wo möglich

---

## 2. Vendor- & Guest-Risiken

### Risiko 4: *Vendor-Accounts bleiben aktiv**
- Ursache:
  - kein HR als Trigger
  - kein Enddatum
  - "vergessene" externe Accounts
- Folgen:
  - kritische Zugriffe von außen
  - Compliance-Problem
- Kontrolle:
  - Enddatum Pflicht
  - Vendor Lifecycle
  - Access Reviews (Vendor spezifisch)
  - technische Auto-Expiration

---

### Risiko 5: **Vendor bekommt technische Admin-Rechte**
- Ursache:
  - fehlende Trennung Store/HQ vs IT
  - Vendor als "hilfreicher Alleskönner"
- Folgen:
  - kritische Admin-Pfade liegen extern
  - Haftungs-/Auditrisko
- Kontrolle:
  - Rollenmodell für Vendoren
  - keine dauerhaft hohen Admin-Rechte
  - JIT/PIM für Admin-Rechte
  - Logging / Nachvollziehbarkeit

---

### Risiko 6: **Guests bleiben im Tenant**
- Ursache:
  - Projektende nicht synchronisiert
  - kein Enddatum
  - keine Auto-Expiration
- Folgen:
  - unnötige Tenant-Breite
  - Datenexfiltration möglich
- Kontrolle:
  - Auto-Expirer (z.B. 90 Tage)
  - Projekt-Endkopplung
  - Guest Review

---

## 3. Admin- & Privilegien-Risiken

### Risiko 7: **Dauerhafte Admin-Rechte**
- Ursache:
  - kein PIM / JIT
  - Admin > Convenience > Governance
- Folgen:
  - Missbrauch / Fehler
  - Audit-Fund in 100% der Fälle
- Kontrolle:
  - JIT/PIM ("Elevation on Demand")
  - getrennte Admin-Identitäten
  - Logging/Alerting

---

### Risiko 8: **Break-Glass ohne Governance**
- Ursache:
  - Passwort im Kopf / Post-It
- Folgen:
  - Nichtbenutzbarkeit im Notfall
  - Missbrauch im Alltag
- Kontrolle:
  - Passwort im physischen Tresor
  - klar definierter Notfallprozess
  - Audits auf Nutzungshäufigkeit

---

### Risiko 9: **Shadow-Admin**
- Ursache:
  - indirekte Berechtigungsvererbung
  - zu breite Gruppen
- Folgen:
  - Admin-Rechte durch Hintertür
- Kontrolle:
  - explizite Admin-Gruppen
  - Trennung von Business und Admin
  - Roles/Groups-Review

---

## 4. Daten- & App-Risiken (Retail typisch)

### Risiko 10: **Finance-Daten zu breit verteilt**
- Kontrolle:
  - App-spezifische Gruppen
  - Finance Access Reviews

### Risiko 11: **POS-System als Mittelpunkte**
- Kontrolle:
  - Vendor-Admin reduzieren
  - Betriebsseitige Approval-Prozesse

---

## 5. Operational & Compliance Risks

### Risiko 12: **Kein Audit -> kein Nachweis**
Retail hat oft Revision / Prüfung → IAM ohne Audit ist unhaltbar.

- Kontrolle:
  - Logging von Joiner/Mover/Leaver
  - Logging von Admin-Elevation
  - Logging von Vendor/Guest-Add/Remove

---

## 6. Zusammenfassung – Control-Matrix (Kurzform)

| Risiko | Control | Typ |
|--------|---------|-----|
| Leaver bleiben aktiv | HR→IAM + Offboarding | Lifecycle |
| Mover sammelt Rechte | Rollenwechsel-Clean-Up | Lifecycle |
| Vendor bleibt aktiv | Enddatum + Review | Vendor |
| Guest bleibt aktiv | Auto-Expiry | Guest |
| Dauer-Admin | PIM/JIT | Privilege |
| Break-Glass | Tresor + Prozess | Notfall |
| Shadow-Admin | Gruppenmodell | RBAC |
| Finance-Leak | Finance-RBAC | App |
| Kein Audit | Logging+Review | Compliance |

---

## 7. Zielbild in diesem Projekt

Wir wollen kein „Zero Trust“ verkaufen, sondern ein IAM-Modell, das:

- **umsetzbar**
- **auditierbar**
- **retail-kompatibel**
- **lifecycle-getrieben**
- **least-privilege**
- **externe Vendoren berücksichtigt**

und technisch so strukturiert ist, dass man es später automatisieren kann (z.B. via Terraform / HR-Schnittstelle / SCIM).