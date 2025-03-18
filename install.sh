#!/bin/bash
# Installation Script for Admin Server

echo "=== Admin Server Installation Script ==="
echo "This script will install and configure all components of the Admin Server"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
  echo "Please run this script as a regular user with sudo privileges, not as root."
  exit 1
fi

# Create main directory
echo "Creating directory structure..."
mkdir -p ~/admin-server
cd ~/admin-server

# Clone or copy files from repository
echo "Copying files..."
# In a real scenario, this would be a git clone or download command
# For this example, we assume files are already in place

# Run base setup
echo "Installing base dependencies..."
if [ -f "./setup_base.sh" ]; then
  chmod +x ./setup_base.sh
  ./setup_base.sh
else
  echo "Error: setup_base.sh not found!"
  exit 1
fi

# Set up web server
echo "Setting up web server..."
cd ~/admin-server/web
npm install

# Set up Python environment
echo "Setting up Python environment..."
pip3 install psutil

# Set up VNC
echo "Setting up VNC server..."
if [ -f "../vnc_setup_instructions.sh" ]; then
  cat ../vnc_setup_instructions.sh
  echo "Please follow the instructions above to set up VNC manually."
else
  echo "Warning: VNC setup instructions not found!"
fi

# Set up n8n
echo "Setting up n8n workflow automation..."
if [ -f "../setup_n8n.sh" ]; then
  chmod +x ../setup_n8n.sh
  ../setup_n8n.sh
else
  echo "Warning: n8n setup script not found!"
fi

# Set up security
echo "Configuring security measures..."
if [ -f "../setup_security.sh" ]; then
  chmod +x ../setup_security.sh
  ../setup_security.sh
  
  if [ -f "../implement_security.sh" ]; then
    chmod +x ../implement_security.sh
    ../implement_security.sh
  fi
else
  echo "Warning: Security setup script not found!"
fi

# Start the server
echo "Starting Admin Server..."
cd ~/admin-server/web
npm start &

echo ""
echo "=== Installation Complete ==="
echo "You can access the Admin Server at: https://your-server-ip:3000"
echo "Default login: admin / changeme"
echo ""
echo "IMPORTANT: Change the default password immediately after first login!"
echo "For more information, see the documentation at: ~/admin-server/documentation.md"
