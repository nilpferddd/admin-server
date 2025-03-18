#!/bin/bash
# Security Configuration Script

echo "=== Configuring Security Measures ==="

# Create security directory
mkdir -p ~/admin-server/security

# Create SSL certificate generation script
cat > ~/admin-server/security/generate_ssl.sh << 'EOF'
#!/bin/bash

# Generate self-signed SSL certificate for HTTPS
echo "Generating self-signed SSL certificate..."
mkdir -p ~/admin-server/security/ssl
cd ~/admin-server/security/ssl

# Generate private key
openssl genrsa -out server.key 2048

# Generate certificate signing request
openssl req -new -key server.key -out server.csr -subj "/C=DE/ST=State/L=City/O=Organization/CN=admin-server"

# Generate self-signed certificate (valid for 365 days)
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

echo "SSL certificate generated successfully!"
echo "Certificate location: ~/admin-server/security/ssl/server.crt"
echo "Key location: ~/admin-server/security/ssl/server.key"
EOF

chmod +x ~/admin-server/security/generate_ssl.sh

# Create firewall configuration script
cat > ~/admin-server/security/configure_firewall.sh << 'EOF'
#!/bin/bash

# Configure firewall using ufw (Uncomplicated Firewall)
echo "Configuring firewall..."

# Check if ufw is installed
if ! command -v ufw &> /dev/null; then
    echo "Installing ufw..."
    sudo apt-get update
    sudo apt-get install -y ufw
fi

# Reset firewall rules
sudo ufw --force reset

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (port 22)
sudo ufw allow 22/tcp

# Allow HTTP and HTTPS (ports 80 and 443)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow admin server port (3000)
sudo ufw allow 3000/tcp

# Allow VNC port (5901)
sudo ufw allow 5901/tcp

# Allow n8n port (5678)
sudo ufw allow 5678/tcp

# Enable firewall
echo "y" | sudo ufw enable

echo "Firewall configured successfully!"
echo "Allowed ports: 22 (SSH), 80 (HTTP), 443 (HTTPS), 3000 (Admin Server), 5901 (VNC), 5678 (n8n)"
EOF

chmod +x ~/admin-server/security/configure_firewall.sh

# Create HTTPS configuration for Express
cat > ~/admin-server/security/https_config.js << 'EOF'
// HTTPS Configuration for Express Server
const fs = require('fs');
const path = require('path');
const https = require('https');

// Function to configure HTTPS for Express app
function configureHttps(app, port = 3000) {
    try {
        // Check if SSL certificates exist
        const sslDir = path.join(__dirname, '..', 'security', 'ssl');
        const keyPath = path.join(sslDir, 'server.key');
        const certPath = path.join(sslDir, 'server.crt');
        
        if (fs.existsSync(keyPath) && fs.existsSync(certPath)) {
            // SSL certificates exist, configure HTTPS
            const httpsOptions = {
                key: fs.readFileSync(keyPath),
                cert: fs.readFileSync(certPath)
            };
            
            // Create HTTPS server
            const server = https.createServer(httpsOptions, app);
            
            // Start HTTPS server
            server.listen(port, '0.0.0.0', () => {
                console.log(`HTTPS Admin Server running on https://0.0.0.0:${port}`);
            });
            
            return server;
        } else {
            // SSL certificates don't exist, log warning and return null
            console.warn('SSL certificates not found. HTTPS not configured.');
            console.warn('Run the generate_ssl.sh script to create SSL certificates.');
            return null;
        }
    } catch (error) {
        console.error('Error configuring HTTPS:', error);
        return null;
    }
}

module.exports = { configureHttps };
EOF

# Create security best practices document
cat > ~/admin-server/security/security_best_practices.md << 'EOF'
# Security Best Practices for Admin Server

This document outlines security best practices for your admin server deployment.

## Authentication and Authorization

1. **Change Default Passwords**: Immediately change the default admin password (`changeme`) after installation.

2. **Strong Password Policy**: Use strong passwords with a mix of uppercase, lowercase, numbers, and special characters.

3. **Regular Password Rotation**: Change passwords periodically (every 90 days recommended).

4. **Limit Admin Users**: Only create admin accounts for users who absolutely need administrative access.

## Network Security

1. **Firewall Configuration**: Use the provided firewall script to restrict access to only necessary ports.

2. **VPN Access**: Consider placing the admin server behind a VPN for an additional layer of security.

3. **IP Restrictions**: If possible, restrict access to the admin interface to specific IP addresses.

4. **HTTPS**: Always use HTTPS with valid SSL certificates for encrypted communication.

## Server Hardening

1. **Regular Updates**: Keep the server operating system and all installed packages up to date.

2. **Disable Unnecessary Services**: Only run services that are required for the admin server.

3. **File Permissions**: Ensure proper file permissions are set on all configuration files.

4. **Monitoring**: Implement monitoring to detect and alert on suspicious activities.

## Data Protection

1. **Backups**: Regularly backup configuration and important data.

2. **Encryption**: Ensure sensitive data is encrypted both in transit and at rest.

3. **Data Minimization**: Only collect and store data that is necessary for operation.

## Incident Response

1. **Logging**: Enable comprehensive logging for all system and application events.

2. **Audit Trail**: Maintain an audit trail of administrative actions.

3. **Incident Response Plan**: Develop a plan for responding to security incidents.

## Implementation Instructions

### Enabling HTTPS

1. Generate SSL certificates:
   ```
   cd ~/admin-server/security
   ./generate_ssl.sh
   ```

2. Modify the server code to use HTTPS:
   - Edit `~/admin-server/web/server/index.js`
   - Add the following at the top:
     ```javascript
     const { configureHttps } = require('../../security/https_config');
     ```
   - Replace the server start code with:
     ```javascript
     const server = configureHttps(app, PORT);
     if (!server) {
       // Fallback to HTTP if HTTPS configuration fails
       app.listen(PORT, '0.0.0.0', () => {
         console.log(`HTTP Admin Server running on http://0.0.0.0:${PORT}`);
       });
     }
     ```

### Configuring Firewall

1. Run the firewall configuration script:
   ```
   cd ~/admin-server/security
   ./configure_firewall.sh
   ```

2. Verify firewall status:
   ```
   sudo ufw status
   ```
EOF

# Create security implementation script
cat > ~/admin-server/implement_security.sh << 'EOF'
#!/bin/bash

# Script to implement security measures

echo "=== Implementing Security Measures ==="

# Generate SSL certificates
echo "Generating SSL certificates..."
cd ~/admin-server/security
./generate_ssl.sh

# Update server code to use HTTPS
echo "Updating server code to use HTTPS..."
cd ~/admin-server/web/server

# Backup original index.js
cp index.js index.js.bak

# Modify index.js to use HTTPS
sed -i '1s/^/const { configureHttps } = require("..\/..\/security\/https_config");\n/' index.js
sed -i 's/app.listen(PORT, .*/const server = configureHttps(app, PORT);\nif (!server) {\n  \/\/ Fallback to HTTP if HTTPS configuration fails\n  app.listen(PORT, "0.0.0.0", () => {\n    console.log(`HTTP Admin Server running on http:\/\/0.0.0.0:${PORT}`);\n  });\n}/' index.js

echo "Security measures implemented successfully!"
echo "To configure the firewall, run: cd ~/admin-server/security && ./configure_firewall.sh"
echo "Review security best practices at: ~/admin-server/security/security_best_practices.md"
EOF

chmod +x ~/admin-server/implement_security.sh

echo "=== Security configuration scripts created ==="
echo "To implement security measures, run: ~/admin-server/implement_security.sh"
echo "To configure the firewall, run: ~/admin-server/security/configure_firewall.sh"
echo "Security best practices document: ~/admin-server/security/security_best_practices.md"
