const express = require('express');
const session = require('express-session');
const bodyParser = require('body-parser');
const path = require('path');
const fs = require('fs');
const bcrypt = require('bcrypt');
const { exec } = require('child_process');

// Initialisiere Express App
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, '../public')));

// Session-Konfiguration
app.use(session({
  secret: 'admin-server-secret-key',
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false, maxAge: 3600000 } // 1 Stunde
}));

// View Engine Setup
app.set('views', path.join(__dirname, '../src/views'));
app.set('view engine', 'ejs');

// Benutzer-Datenbank (für Entwicklungszwecke in einer Datei)
const USERS_FILE = path.join(__dirname, '../../data/users.json');

// Stelle sicher, dass das Datenverzeichnis existiert
if (!fs.existsSync(path.join(__dirname, '../../data'))) {
  fs.mkdirSync(path.join(__dirname, '../../data'));
}

// Initialisiere Benutzer-Datei, wenn sie nicht existiert
if (!fs.existsSync(USERS_FILE)) {
  // Admin-Benutzer erstellen (admin:changeme)
  const adminPasswordHash = bcrypt.hashSync('changeme', 10);
  const initialUsers = {
    users: [
      {
        id: 1,
        username: 'admin',
        password: adminPasswordHash,
        role: 'admin',
        createdAt: new Date().toISOString()
      }
    ]
  };
  fs.writeFileSync(USERS_FILE, JSON.stringify(initialUsers, null, 2));
}

// Benutzer laden
const loadUsers = () => {
  try {
    const data = fs.readFileSync(USERS_FILE, 'utf8');
    return JSON.parse(data);
  } catch (err) {
    console.error('Fehler beim Laden der Benutzer:', err);
    return { users: [] };
  }
};

// Benutzer speichern
const saveUsers = (users) => {
  try {
    fs.writeFileSync(USERS_FILE, JSON.stringify(users, null, 2));
    return true;
  } catch (err) {
    console.error('Fehler beim Speichern der Benutzer:', err);
    return false;
  }
};

// Middleware für Authentifizierung
const requireAuth = (req, res, next) => {
  if (req.session && req.session.user) {
    return next();
  } else {
    return res.redirect('/login');
  }
};

// Middleware für Admin-Rechte
const requireAdmin = (req, res, next) => {
  if (req.session && req.session.user && req.session.user.role === 'admin') {
    return next();
  } else {
    return res.status(403).send('Zugriff verweigert: Admin-Rechte erforderlich');
  }
};

// Routen

// Login-Seite
app.get('/login', (req, res) => {
  res.render('login', { error: null });
});

// Login-Verarbeitung
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  const userData = loadUsers();
  
  const user = userData.users.find(u => u.username === username);
  
  if (user && bcrypt.compareSync(password, user.password)) {
    // Passwort aus Session entfernen
    const sessionUser = { ...user };
    delete sessionUser.password;
    
    req.session.user = sessionUser;
    res.redirect('/dashboard');
  } else {
    res.render('login', { error: 'Ungültiger Benutzername oder Passwort' });
  }
});

// Logout
app.get('/logout', (req, res) => {
  req.session.destroy();
  res.redirect('/login');
});

// Dashboard
app.get('/dashboard', requireAuth, (req, res) => {
  res.render('dashboard', { user: req.session.user });
});

// Benutzerverwaltung (nur Admin)
app.get('/users', requireAuth, requireAdmin, (req, res) => {
  const userData = loadUsers();
  res.render('users', { users: userData.users, user: req.session.user });
});

// Benutzer erstellen (nur Admin)
app.post('/users', requireAuth, requireAdmin, (req, res) => {
  const { username, password, role } = req.body;
  const userData = loadUsers();
  
  // Prüfen, ob Benutzer bereits existiert
  if (userData.users.some(u => u.username === username)) {
    return res.status(400).send('Benutzername existiert bereits');
  }
  
  // Neuen Benutzer erstellen
  const newUser = {
    id: userData.users.length > 0 ? Math.max(...userData.users.map(u => u.id)) + 1 : 1,
    username,
    password: bcrypt.hashSync(password, 10),
    role: role || 'user',
    createdAt: new Date().toISOString()
  };
  
  userData.users.push(newUser);
  saveUsers(userData);
  
  res.redirect('/users');
});

// Benutzer löschen (nur Admin)
app.post('/users/delete/:id', requireAuth, requireAdmin, (req, res) => {
  const userId = parseInt(req.params.id);
  const userData = loadUsers();
  
  // Admin-Benutzer kann nicht gelöscht werden
  if (userId === 1) {
    return res.status(400).send('Der Admin-Benutzer kann nicht gelöscht werden');
  }
  
  userData.users = userData.users.filter(u => u.id !== userId);
  saveUsers(userData);
  
  res.redirect('/users');
});

// Passwort ändern
app.post('/change-password', requireAuth, (req, res) => {
  const { currentPassword, newPassword } = req.body;
  const userData = loadUsers();
  
  const userIndex = userData.users.findIndex(u => u.id === req.session.user.id);
  
  if (userIndex === -1) {
    return res.status(404).send('Benutzer nicht gefunden');
  }
  
  // Aktuelles Passwort überprüfen
  if (!bcrypt.compareSync(currentPassword, userData.users[userIndex].password)) {
    return res.status(400).send('Aktuelles Passwort ist falsch');
  }
  
  // Passwort aktualisieren
  userData.users[userIndex].password = bcrypt.hashSync(newPassword, 10);
  saveUsers(userData);
  
  res.redirect('/dashboard');
});

// Python-Skripte-Verwaltung
app.get('/scripts', requireAuth, (req, res) => {
  // Skripte aus dem scripts-Verzeichnis lesen
  const scriptsDir = path.join(__dirname, '../../scripts');
  
  if (!fs.existsSync(scriptsDir)) {
    fs.mkdirSync(scriptsDir);
  }
  
  fs.readdir(scriptsDir, (err, files) => {
    if (err) {
      console.error('Fehler beim Lesen des Skriptverzeichnisses:', err);
      return res.status(500).send('Fehler beim Lesen der Skripte');
    }
    
    const scripts = files.filter(file => file.endsWith('.py'));
    res.render('scripts', { scripts, user: req.session.user });
  });
});

// Python-Skript ausführen
app.post('/scripts/run/:script', requireAuth, (req, res) => {
  const scriptName = req.params.script;
  const scriptPath = path.join(__dirname, '../../scripts', scriptName);
  
  if (!fs.existsSync(scriptPath)) {
    return res.status(404).send('Skript nicht gefunden');
  }
  
  exec(`python3 ${scriptPath}`, (error, stdout, stderr) => {
    if (error) {
      console.error(`Fehler bei der Ausführung: ${error}`);
      return res.status(500).send(`Fehler bei der Ausführung: ${stderr}`);
    }
    
    res.send({ output: stdout });
  });
});

// Skript hochladen
app.post('/scripts/upload', requireAuth, (req, res) => {
  // Hier würde normalerweise ein File-Upload-Handler stehen
  // Für dieses Beispiel vereinfacht
  const { scriptName, scriptContent } = req.body;
  
  if (!scriptName || !scriptContent) {
    return res.status(400).send('Skriptname und Inhalt sind erforderlich');
  }
  
  const scriptPath = path.join(__dirname, '../../scripts', scriptName);
  
  fs.writeFile(scriptPath, scriptContent, (err) => {
    if (err) {
      console.error('Fehler beim Speichern des Skripts:', err);
      return res.status(500).send('Fehler beim Speichern des Skripts');
    }
    
    res.redirect('/scripts');
  });
});

// VNC-Zugriff
app.get('/vnc', requireAuth, (req, res) => {
  res.render('vnc', { user: req.session.user });
});

// n8n-Integration
app.get('/n8n', requireAuth, (req, res) => {
  res.render('n8n', { user: req.session.user });
});

// Startseite - Umleitung zum Dashboard oder Login
app.get('/', (req, res) => {
  if (req.session && req.session.user) {
    res.redirect('/dashboard');
  } else {
    res.redirect('/login');
  }
});

// Server starten
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Admin-Server läuft auf http://0.0.0.0:${PORT}`);
});
