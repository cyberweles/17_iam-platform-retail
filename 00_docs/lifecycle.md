# Lifecycle (Joiner / Mover / Leaver)

In diesem Dokument wird bechrieben, **wie Identitäten über die Zeit "leben"**:
vom Eintritt (Joiner) über Rollenwechsel (Mover) bis zum Austriff (Leaver).
Zusätzlich betrachten wir einen eigenen Lifecycle für **Vendors** und **Guests**.

---

## 1. Grundprinzip

Lifecycle wird immer von zwei Seiten getrieben:

- **HR / Organisation** - entscheidet, wer welche Rolle hat und wann jemand kommt/geht.
- **IAM / IT** - setzt diese Entscheidungen technisch sauber, nachvollziehbar und rechtzeitig um.

Ziel:
- Zugriffe sind **zeitnah vorhanden**, wenn jemand startet.
- Zugriffe sind **korrekt**, wenn jemand die Rolle ändert.
- Zugriffe sind **weg**, wenn jemand geht.

---

## 2. Lifecycle - interne Mitarbeitende

### 2.1 Joiner (Eintritt)

**Beispiel: neue Store-Mitarbeiterin**

1. **HR legt Datensatz an**
   - Personaldaten, Startdatum, Standort (Filiale), Rolle (`STORE_EMPLOYEE`).
2. **Identity-Anlage in Entra ID**
   - User-Konto wird erstellt (User Principal Name, Mailadresse).
   - Business-Rolle wird zugewiesen (z.B. `STORE_EMPLOYEE`).
3. **Gruppenzuordnungen**
   - User wird Mitglied von `GRP_BR_STORE_EMPLOYEE`.
   - Über Gruppenzuordnung erhält sie Zugriffe auf:
     - `GRP_APP_POS_USER`
     - `GRP_APP_M365_STORE_TEAM`
4. **Initiale Security-Setups**
   - MFA-Registrierung.
   - Default-Policies (Conditional Access) greifen.
5. **Dokumentation / Audit**
   - Joiner-Vorgang wird protokolliert (wer hat angelegt, wann, welche Rolle).

Wichtig:
Der Joiner-Prozess sollte **möglichst automatisiert** sein (z.B. HR → IAM-Sync), damit keine manuellen Fehler entstehen und niemand "leer" startet.

---

### 2.2 Mover (Rollenwechsel)

**Beispiel: Store-Mitarbeiter wird Store Manager**

1. **HR-Änderung**
   - HR ändert Rolle von `STORE_EMPLOYEE` auf `STORE_MANAGER`.
2. **IAM reagiert**
   - `GRP_BR_STORE_EMPLOYEE` wird entfernt.
   - `GRP_BR_STORE_MANAGER` wird zugewiesen.
3. **App-Zugriffe**
   - Zugriff auf zusätzliche Reporting- / Planungs-Tools.
   - Evtl. erweiterte Rechte in M365 / Teams.
4. **Kontrollpunkt**
   - Review, ob keine "Alt-Rechte" aus vorherigen Rollen übrig bleiben.
5. **Audit**
   - Rollenwechsel wird nachvollziehbar geloggt.

**Besonderheit:**
Mover ist oft **kritischer** als Joiner, weil sich hier **Rechte verschieben** - wenn Alt-Rechte nicht entzogen werden, entstehen schleichend **Überprivilegien**.

---

### 2.3 Leaver (Austritt)

**Beispiel: HQ-Mitarbeiter verlässt das Unternehmen**

1. **HR markiert Enddatum**
   - Klar definierter letzter Arbeitstag.
2. **Identity-Deaktivierung** (spätestens zum Enddatum)
   - Konto wird deaktivierung oder gesperrt.
   - Anmeldung wird unterbunden.
3. **Gruppen- und Rollenentzug**
   - Entfernung aus allen Business-Rollen-Gruppen.
   - Indirekt: Entzug aller App-Gruppen.
4. **Zweitfaktor & Geräte**
   - Tokens, FIDO-Keys, mobile Geräte entziehen / aus MDM entfernen.
5. **Postfach / Datenzugriff**
   - Übergabe an Vorgesetzte / Sammelpostfach gemäß Policy.
6. **Audit / Nachvollziehbarkeit**
   - Leaver-Vorgang wird dokumentiert:
     - wann,
     - durch wen,
     - welche Schritte durchgeführt wurden.

**Ziel:**
Nach Enddatum darf es **keine aktiven Zugang** mehr geben - weder interaktiv noch über technische Accounts.

---

## 3. Lifecycle - Vendors und Guests

Externe sind im Retail-Kontext besonders kritisch, da sie häufig:

- erhöhte Rechte haben (z.B. POS-Admin, Remote-Wartung),
- nicht im HR-System geführt werden,
- gerne "vergessen" werden (Schattenkonten).

Deshalb erhalten Vendors/Guests einen **eigenen Lifecycle**.

---

### 3.1 Vendor Joiner

**Beispiel: externer IT-Dienstleister für Kassensysteme**

1. **Business-Verantwortliche*r beantragt Vendor-Zugang**
   - Definiert:
     - Firma
     - Person(en)
     - Zweck
     - Start- und Enddatum
2. **IAM legt Vendor-Account an**
   - Typ: `VENDOR_USER` (Guest im Entra, o.ä.)
   - Zuweisung zu `GRP_BR_VENDOR_USER`
   - App-Gruppen (z.B. `GRP_APP_POS_ADMIN`) nach Freigabe
3. **Security-Baseline**
   - MFA **zwingend**
   - Zugriffe nur von definierten Kontexten (z.B. bestimmte Länder/IPs, falls sinnvoll)
4. **Dokumentation**
   - Ticket / Request-Nummer
   - Verantwortliche Person im Unternehmen

---

### 3.2 Vendor Mover

**Beispiel: Vendor übernimmt mehr/weniger Verantwortung**

- Rechte werden angepasst:
  - zusätzliche App-Gruppen oder
  - Entzug bestimmter Berechtigungen.
- Immer mit:
  - dokumentierter Begründung,
  - Freigabe durch Verantwortliche,
  - Nachvollziehbarkeit im Audit.

---

### 3.3 Vendor Leaver

**Kritischste Phase für Vendor-Accounts.**

1. **Ende der Zusammenarbeit**
   - Vertrag / Projekt endet.
2. **Sofortige Deaktivierung**
   - Vendor-Accounts deaktivieren oder löschen.
   - Entfernung aus allen Gruppen.
3. **Prüfung auf Rest-Zugriffe**
   - Keine Admin- oder Service-Accounts mit Vendor-Zugriff mehr existent.
4. **Review**
   - Optional: Access Review im Nachgang.
5. **Audit**
   - Dokumentation, wenn Vendor-Zugriffe beendet wurden.

---

### 3.4 Guest Lifecycle (Kurzform)

Guests haben in der Regel **noch kürzere Lifecycles**:

- **Joiner**: Einladung als Guest + Zuweisung zu kleinsten notwendigen Gruppen (z.B. 1-2 Teams).
- **Mover**: selten - eher Anpassung von Zugriffszeitraum oder Projekten.
- **Leaver**: automatisches Entfernen nach:
  - Ablaufdatum
  - Inaktivität (z.B. 90 Tage)
  - Projektende

**Policy-Empfehlung:**
Guests sollten **standardmäßig auto-expiren**, z.B. nach 90 Tagen, wenn kein aktiver Bedarf dokumentiert ist.

---

## 4. Typische Probleme im Lifecycle

- HR übermittelt **spät oder unvollständig** (Joiner/Leaver).
- Rollenwechsel (Mover) führen zu **Rechte-Sammelsurium**.
- Vendor-Accounts werden nicht sauber beendet.
- Guests bleiben „ewig“ im Tenant.
- Manuelle Prozesse → fehleranfällig, keine klare Zuständigkeit.

---

## 5. Ansatz für Verbesserungen

- Klare **Schnittstelle HR → IAM** (mindestens einfache CSV / Datei-Exports als Start).
- **Standardformulare** für Vendor-/Guest-Anträge (Zweck, Dauer, Verantwortliche).
- Regelmäßige **Access Reviews**:
  - Vendors
  - Elevated Roles
  - kritische Gruppen
- Soweit möglich: Automatisierung (z.B. via Terraform / Scripts / Identity Governance).

Dieses Lifecycle-Modell ist die Basis dafür, im nächsten Schritt **Access Policies** und **Risiko-/Kontrollmechanismen** sinnvoll zu definieren.