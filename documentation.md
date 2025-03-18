# Admin Server Dokumentation

## Inhaltsverzeichnis
1. [Einführung](#einführung)
2. [Installationsanleitung](#installationsanleitung)
3. [Benutzerhandbuch](#benutzerhandbuch)
4. [API-Dokumentation](#api-dokumentation)
5. [Sicherheitsrichtlinien](#sicherheitsrichtlinien)
6. [Fehlerbehebung](#fehlerbehebung)

## Einführung

Der Admin Server ist eine umfassende Lösung zur Verwaltung Ihres Homeservers. Er bietet eine zentrale Weboberfläche, über die Sie verschiedene Funktionen und Dienste steuern können:

- **Benutzerverwaltung**: Erstellen und verwalten Sie Benutzerkonten mit verschiedenen Berechtigungsstufen
- **Python-Skript-Ausführung**: Verwalten und führen Sie Python-Skripte direkt über die Weboberfläche aus
- **VNC-Fernzugriff**: Greifen Sie remote auf Ihren Server zu
- **n8n Workflow-Automatisierung**: Erstellen und verwalten Sie Automatisierungs-Workflows

Die Lösung wurde mit Fokus auf Sicherheit und Benutzerfreundlichkeit entwickelt und bietet eine intuitive Oberfläche für alle administrativen Aufgaben.

## Installationsanleitung

### Systemvoraussetzungen

- Ubuntu 20.04 LTS oder neuer
- Node.js 14 oder neuer
- Python 3.8 oder neuer
- 2 GB RAM (empfohlen: 4 GB)
- 10 GB freier Festplattenspeicher

### Installation

1. **Herunterladen und Entpacken**

   Laden Sie das Admin Server Paket herunter und entpacken Sie es:

   ```bash
   mkdir -p ~/admin-server
   cd ~/admin-server
   # Kopieren Sie alle Dateien in dieses Verzeichnis
   ```

2. **Basis-Setup ausführen**

   Führen Sie das Basis-Setup-Skript aus, um alle erforderlichen Abhängigkeiten zu installieren:

   ```bash
   cd ~/admin-server
   chmod +x setup_base.sh
   ./setup_base.sh
   ```

3. **Web-Server einrichten**

   Installieren Sie die Node.js-Abhängigkeiten und richten Sie den Webserver ein:

   ```bash
   cd ~/admin-server/web
   npm install
   ```

4. **Benutzerauthentifizierung konfigurieren**

   Die Benutzerauthentifizierung ist bereits vorkonfiguriert mit einem Admin-Benutzer:
   - Benutzername: `admin`
   - Passwort: `changeme`

   **Wichtig**: Ändern Sie das Standardpasswort nach der ersten Anmeldung!

5. **VNC-Server einrichten**

   Folgen Sie den Anweisungen in der VNC-Setup-Anleitung:

   ```bash
   cat ~/admin-server/vnc_setup_instructions.sh
   ```

6. **n8n installieren**

   Führen Sie das n8n-Setup-Skript aus:

   ```bash
   cd ~/admin-server
   chmod +x setup_n8n.sh
   ./setup_n8n.sh
   ```

   Folgen Sie dann den Anweisungen zur Installation von n8n.

7. **Sicherheitsmaßnahmen implementieren**

   Führen Sie das Sicherheits-Setup-Skript aus:

   ```bash
   cd ~/admin-server
   chmod +x setup_security.sh
   ./setup_security.sh
   ```

   Implementieren Sie dann die Sicherheitsmaßnahmen:

   ```bash
   chmod +x implement_security.sh
   ./implement_security.sh
   ```

8. **Server starten**

   Starten Sie den Admin Server:

   ```bash
   cd ~/admin-server/web
   npm start
   ```

   Der Server ist nun unter `https://ihre-server-ip:3000` erreichbar.

## Benutzerhandbuch

### Anmeldung

1. Öffnen Sie einen Webbrowser und navigieren Sie zu `https://ihre-server-ip:3000`
2. Geben Sie Ihre Anmeldedaten ein:
   - Standardbenutzername: `admin`
   - Standardpasswort: `changeme`
3. Klicken Sie auf "Anmelden"

### Dashboard

Das Dashboard bietet einen Überblick über alle verfügbaren Funktionen:

- **Python-Skripte**: Verwalten und ausführen Sie Python-Skripte
- **VNC-Zugriff**: Starten und steuern Sie den VNC-Server
- **n8n Workflows**: Zugriff auf die n8n Workflow-Automatisierung
- **Benutzerverwaltung**: Verwalten Sie Benutzerkonten (nur für Administratoren)

### Benutzerverwaltung

#### Benutzer erstellen

1. Navigieren Sie zur "Benutzerverwaltung"
2. Klicken Sie auf "Neuer Benutzer"
3. Geben Sie Benutzername, Passwort und Rolle ein
4. Klicken Sie auf "Benutzer erstellen"

#### Passwort ändern

1. Klicken Sie auf Ihren Benutzernamen in der oberen rechten Ecke
2. Wählen Sie "Passwort ändern"
3. Geben Sie Ihr aktuelles Passwort und das neue Passwort ein
4. Klicken Sie auf "Passwort ändern"

### Python-Skripte

#### Skript ausführen

1. Navigieren Sie zu "Python-Skripte"
2. Wählen Sie ein Skript aus der Liste
3. Klicken Sie auf "Ausführen"
4. Die Ausgabe wird im Ausgabebereich angezeigt

#### Neues Skript erstellen

1. Navigieren Sie zu "Python-Skripte"
2. Klicken Sie auf "Neues Skript"
3. Geben Sie einen Namen für das Skript ein (mit .py-Endung)
4. Schreiben Sie den Skriptinhalt
5. Klicken Sie auf "Skript speichern"

### VNC-Zugriff

#### VNC-Server starten

1. Navigieren Sie zu "VNC-Zugriff"
2. Klicken Sie auf "VNC-Server starten"
3. Warten Sie, bis der Server gestartet ist
4. Die Verbindungsinformationen werden angezeigt

#### Mit VNC verbinden

1. Verwenden Sie einen VNC-Client (z.B. VNC Viewer, RealVNC)
2. Geben Sie die Adresse ein: `ihre-server-ip:5901`
3. Geben Sie das VNC-Passwort ein (Standard: `changeme`)

### n8n Workflows

#### n8n starten

1. Navigieren Sie zu "n8n Workflows"
2. Klicken Sie auf "n8n-Server starten"
3. Warten Sie, bis der Server gestartet ist
4. Klicken Sie auf "n8n-Editor öffnen", um den n8n-Editor zu öffnen

#### Workflow erstellen

1. Im n8n-Editor, klicken Sie auf "New Workflow"
2. Fügen Sie Nodes hinzu und konfigurieren Sie sie
3. Verbinden Sie die Nodes, um den Workflow zu erstellen
4. Klicken Sie auf "Save", um den Workflow zu speichern
5. Klicken Sie auf "Execute Workflow", um ihn auszuführen

## API-Dokumentation

Der Admin Server bietet eine REST-API für die Automatisierung und Integration mit anderen Systemen.

### Authentifizierung

Alle API-Anfragen erfordern eine Authentifizierung mit JWT (JSON Web Token).

**Token erhalten:**

```
POST /api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "ihr-passwort"
}
```

Antwort:

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

Verwenden Sie dieses Token in nachfolgenden Anfragen im Authorization-Header:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Benutzer-API

#### Benutzer auflisten

```
GET /api/users
```

#### Benutzer erstellen

```
POST /api/users
Content-Type: application/json

{
  "username": "neuer-benutzer",
  "password": "passwort",
  "role": "user"
}
```

#### Benutzer löschen

```
DELETE /api/users/:id
```

### Skript-API

#### Skripte auflisten

```
GET /api/scripts
```

#### Skript ausführen

```
POST /api/scripts/run/:script
```

#### Skript hochladen

```
POST /api/scripts/upload
Content-Type: application/json

{
  "scriptName": "mein_skript.py",
  "scriptContent": "print('Hallo Welt')"
}
```

### VNC-API

#### VNC-Server starten

```
POST /api/vnc/start
```

#### VNC-Server stoppen

```
POST /api/vnc/stop
```

### n8n-API

#### n8n-Server starten

```
POST /api/n8n/start
```

#### n8n-Server stoppen

```
POST /api/n8n/stop
```

## Sicherheitsrichtlinien

### Passwörter

- Ändern Sie alle Standardpasswörter nach der Installation
- Verwenden Sie starke Passwörter (mindestens 12 Zeichen, Groß- und Kleinbuchstaben, Zahlen, Sonderzeichen)
- Ändern Sie Passwörter regelmäßig (empfohlen: alle 90 Tage)

### Netzwerksicherheit

- Verwenden Sie immer HTTPS für den Zugriff auf den Admin Server
- Konfigurieren Sie die Firewall, um nur notwendige Ports zu öffnen
- Erwägen Sie die Verwendung eines VPN für den Zugriff auf den Admin Server
- Beschränken Sie den Zugriff auf vertrauenswürdige IP-Adressen, wenn möglich

### Datensicherheit

- Führen Sie regelmäßige Backups der Konfiguration und Daten durch
- Überprüfen Sie regelmäßig die Protokolle auf verdächtige Aktivitäten
- Halten Sie alle Komponenten des Systems aktuell

Weitere Sicherheitsrichtlinien finden Sie in der Datei `~/admin-server/security/security_best_practices.md`.

## Fehlerbehebung

### Server startet nicht

**Problem**: Der Admin Server startet nicht.

**Lösung**:
1. Überprüfen Sie die Protokolle: `cat ~/admin-server/logs/server.log`
2. Stellen Sie sicher, dass alle Abhängigkeiten installiert sind: `cd ~/admin-server/web && npm install`
3. Überprüfen Sie, ob der Port bereits verwendet wird: `sudo lsof -i :3000`

### Anmeldeprobleme

**Problem**: Sie können sich nicht anmelden.

**Lösung**:
1. Überprüfen Sie, ob Sie die richtigen Anmeldedaten verwenden
2. Setzen Sie das Passwort zurück:
   ```bash
   cd ~/admin-server/web/server
   node reset_password.js admin neues-passwort
   ```

### VNC-Verbindungsprobleme

**Problem**: Sie können keine VNC-Verbindung herstellen.

**Lösung**:
1. Stellen Sie sicher, dass der VNC-Server läuft: `ps aux | grep vnc`
2. Überprüfen Sie, ob der Port 5901 geöffnet ist: `sudo lsof -i :5901`
3. Starten Sie den VNC-Server neu: `cd ~/admin-server/scripts && python3 start_vnc.py`

### n8n-Probleme

**Problem**: n8n startet nicht oder ist nicht erreichbar.

**Lösung**:
1. Überprüfen Sie, ob n8n installiert ist: `which n8n`
2. Starten Sie n8n manuell: `n8n start`
3. Überprüfen Sie, ob der Port 5678 geöffnet ist: `sudo lsof -i :5678`

Bei weiteren Problemen konsultieren Sie bitte die Protokolldateien im Verzeichnis `~/admin-server/logs/` oder wenden Sie sich an den Support.
