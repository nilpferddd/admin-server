#!/bin/bash

# Admin Server Setup Script
# This script will install and configure all necessary components for the admin server

echo "=== Starting Admin Server Setup ==="

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install essential packages
echo "Installing essential packages..."
sudo apt-get install -y build-essential curl wget git nginx python3 python3-pip python3-venv nodejs npm

# Install Node.js and npm if not already installed
if ! command -v node &> /dev/null; then
    echo "Installing Node.js and npm..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Install VNC server
echo "Installing VNC server..."
sudo apt-get install -y tigervnc-standalone-server tigervnc-common

# Create directories
echo "Creating directory structure..."
mkdir -p ~/admin-server/web
mkdir -p ~/admin-server/scripts
mkdir -p ~/admin-server/logs
mkdir -p ~/admin-server/data

echo "=== Base environment setup completed ==="
