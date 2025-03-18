#!/bin/bash
# Test Script for Admin Server

echo "=== Admin Server Test Script ==="
echo "This script will test the functionality of the Admin Server components"
echo ""

# Test directory structure
echo "Testing directory structure..."
if [ -d ~/admin-server ]; then
  echo "✓ Main directory exists"
else
  echo "✗ Main directory not found"
  exit 1
fi

# Test web server files
echo "Testing web server files..."
if [ -d ~/admin-server/web ]; then
  echo "✓ Web directory exists"
  if [ -f ~/admin-server/web/package.json ]; then
    echo "✓ package.json exists"
  else
    echo "✗ package.json not found"
  fi
  if [ -f ~/admin-server/web/server/index.js ]; then
    echo "✓ Server index.js exists"
  else
    echo "✗ Server index.js not found"
  fi
else
  echo "✗ Web directory not found"
fi

# Test user authentication
echo "Testing user authentication..."
if [ -f ~/admin-server/data/users.json ]; then
  echo "✓ Users file exists"
  if grep -q "admin" ~/admin-server/data/users.json; then
    echo "✓ Admin user exists"
  else
    echo "✗ Admin user not found"
  fi
else
  echo "✗ Users file not found"
fi

# Test Python scripts
echo "Testing Python scripts..."
if [ -d ~/admin-server/scripts ]; then
  echo "✓ Scripts directory exists"
  SCRIPT_COUNT=$(ls -1 ~/admin-server/scripts/*.py 2>/dev/null | wc -l)
  if [ $SCRIPT_COUNT -gt 0 ]; then
    echo "✓ Found $SCRIPT_COUNT Python scripts"
  else
    echo "✗ No Python scripts found"
  fi
else
  echo "✗ Scripts directory not found"
fi

# Test VNC setup
echo "Testing VNC setup..."
if [ -d ~/.vnc ]; then
  echo "✓ VNC directory exists"
  if [ -f ~/.vnc/passwd ]; then
    echo "✓ VNC password file exists"
  else
    echo "✗ VNC password file not found"
  fi
else
  echo "✗ VNC directory not found"
fi

# Test n8n setup
echo "Testing n8n setup..."
if [ -d ~/admin-server/n8n ]; then
  echo "✓ n8n directory exists"
  if [ -f ~/admin-server/n8n/install_n8n.sh ]; then
    echo "✓ n8n installation script exists"
  else
    echo "✗ n8n installation script not found"
  fi
else
  echo "✗ n8n directory not found"
fi

# Test security setup
echo "Testing security setup..."
if [ -d ~/admin-server/security ]; then
  echo "✓ Security directory exists"
  if [ -d ~/admin-server/security/ssl ]; then
    echo "✓ SSL directory exists"
    if [ -f ~/admin-server/security/ssl/server.crt ] && [ -f ~/admin-server/security/ssl/server.key ]; then
      echo "✓ SSL certificates exist"
    else
      echo "✗ SSL certificates not found"
    fi
  else
    echo "✗ SSL directory not found"
  fi
else
  echo "✗ Security directory not found"
fi

# Test documentation
echo "Testing documentation..."
if [ -f ~/admin-server/documentation.md ]; then
  echo "✓ Documentation exists"
else
  echo "✗ Documentation not found"
fi

# Test installation script
echo "Testing installation script..."
if [ -f ~/admin-server/install.sh ]; then
  echo "✓ Installation script exists"
else
  echo "✗ Installation script not found"
fi

echo ""
echo "=== Test Summary ==="
echo "The Admin Server components have been tested."
echo "Please review any warnings or errors above."
echo "For a complete test, you should also manually verify:"
echo "1. Web server functionality by starting the server and accessing it"
echo "2. User authentication by logging in with the admin user"
echo "3. Python script execution by running a script through the web interface"
echo "4. VNC access by connecting to the VNC server"
echo "5. n8n functionality by starting the n8n server and creating a workflow"
