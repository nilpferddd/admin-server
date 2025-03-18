#!/bin/bash

# Skript zum Testen der Benutzerauthentifizierung
echo "=== Teste Benutzerauthentifizierung ==="

# Prüfe, ob die Benutzerdatei existiert
if [ -f "../../data/users.json" ]; then
    echo "✓ Benutzerdatei gefunden"
    cat ../../data/users.json
else
    echo "✗ Benutzerdatei nicht gefunden"
    exit 1
fi

# Prüfe, ob der Admin-Benutzer existiert
if grep -q "admin" ../../data/users.json; then
    echo "✓ Admin-Benutzer gefunden"
else
    echo "✗ Admin-Benutzer nicht gefunden"
    exit 1
fi

echo "=== Benutzerauthentifizierung erfolgreich eingerichtet ==="
