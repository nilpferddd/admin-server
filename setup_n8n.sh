#!/bin/bash
# n8n Installation Script

# This script provides instructions and setup for n8n workflow automation
# Due to potential resource limitations in the sandbox environment, we provide
# both automated setup and manual instructions

echo "=== n8n Workflow Automation Setup ==="

# Create n8n directory if it doesn't exist
mkdir -p ~/admin-server/n8n

# Create n8n installation script
cat > ~/admin-server/n8n/install_n8n.sh << 'EOF'
#!/bin/bash

# Install n8n using npm
echo "Installing n8n..."
npm install n8n -g

# Create n8n configuration directory
mkdir -p ~/.n8n

# Create basic configuration file
cat > ~/.n8n/config << 'EOFCONFIG'
# n8n configuration file
PORT=5678
WEBHOOK_URL=http://localhost:5678/
EXECUTIONS_PROCESS=main
SECURITY_ENABLED=true
EOFCONFIG

echo "n8n installation completed!"
echo "You can start n8n by running: n8n start"
EOF

# Make the installation script executable
chmod +x ~/admin-server/n8n/install_n8n.sh

# Create n8n start script
cat > ~/admin-server/scripts/start_n8n.py << 'EOF'
#!/usr/bin/env python3
# start_n8n.py - Script to start the n8n server

import os
import subprocess
import socket
import time

def get_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't even have to be reachable
        s.connect(('10.255.255.255', 1))
        IP = s.getsockname()[0]
    except Exception:
        IP = '127.0.0.1'
    finally:
        s.close()
    return IP

def start_n8n():
    print("Starting n8n workflow automation server...")
    
    # Check if n8n is installed
    try:
        subprocess.run(["which", "n8n"], check=True, capture_output=True)
        print("n8n is installed, starting server...")
    except subprocess.CalledProcessError:
        print("n8n is not installed. Please run the installation script first:")
        print("cd ~/admin-server/n8n && ./install_n8n.sh")
        return
    
    # Start n8n in the background
    try:
        process = subprocess.Popen(
            ["n8n", "start"], 
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE,
            text=True
        )
        
        # Wait a bit for the server to start
        time.sleep(5)
        
        # Check if process is still running
        if process.poll() is None:
            ip = get_ip()
            print(f"n8n server started successfully!")
            print(f"You can access n8n at: http://{ip}:5678")
            print("To stop the server, run the stop_n8n.py script")
            
            # Write the process ID to a file for later termination
            with open(os.path.expanduser("~/admin-server/n8n/n8n.pid"), "w") as f:
                f.write(str(process.pid))
        else:
            stdout, stderr = process.communicate()
            print("Failed to start n8n server")
            print(f"Error: {stderr}")
    except Exception as e:
        print(f"Error starting n8n: {e}")

if __name__ == "__main__":
    start_n8n()
EOF

# Create n8n stop script
cat > ~/admin-server/scripts/stop_n8n.py << 'EOF'
#!/usr/bin/env python3
# stop_n8n.py - Script to stop the n8n server

import os
import subprocess
import signal

def stop_n8n():
    print("Stopping n8n workflow automation server...")
    
    # Check if PID file exists
    pid_file = os.path.expanduser("~/admin-server/n8n/n8n.pid")
    if os.path.exists(pid_file):
        with open(pid_file, "r") as f:
            pid = f.read().strip()
        
        try:
            # Try to terminate the process
            os.kill(int(pid), signal.SIGTERM)
            print("n8n server stopped successfully!")
            
            # Remove the PID file
            os.remove(pid_file)
        except ProcessLookupError:
            print("n8n server is not running or was already stopped")
            if os.path.exists(pid_file):
                os.remove(pid_file)
        except Exception as e:
            print(f"Error stopping n8n: {e}")
    else:
        # Try to find and kill n8n processes
        try:
            subprocess.run(["pkill", "-f", "n8n"], check=False)
            print("Attempted to stop n8n server by process name")
        except Exception as e:
            print(f"Error stopping n8n: {e}")

if __name__ == "__main__":
    stop_n8n()
EOF

# Make the scripts executable
chmod +x ~/admin-server/scripts/start_n8n.py
chmod +x ~/admin-server/scripts/stop_n8n.py

# Create manual installation instructions
cat > ~/admin-server/n8n/n8n_manual_setup.md << 'EOF'
# n8n Manual Installation Instructions

If the automated installation doesn't work in your environment, follow these manual steps to install n8n on your homeserver:

## Prerequisites
- Node.js 14 or newer
- npm (comes with Node.js)

## Installation Steps

1. Install n8n globally using npm:
   ```
   npm install n8n -g
   ```

2. Create a configuration directory:
   ```
   mkdir -p ~/.n8n
   ```

3. Create a basic configuration file:
   ```
   cat > ~/.n8n/config << 'EOFCONFIG'
   # n8n configuration file
   PORT=5678
   WEBHOOK_URL=http://localhost:5678/
   EXECUTIONS_PROCESS=main
   SECURITY_ENABLED=true
   EOFCONFIG
   ```

4. Start n8n:
   ```
   n8n start
   ```

5. Access n8n in your browser:
   ```
   http://your-server-ip:5678
   ```

## Running n8n as a Service

To run n8n as a service that starts automatically with your server, you can create a systemd service:

1. Create a service file:
   ```
   sudo nano /etc/systemd/system/n8n.service
   ```

2. Add the following content:
   ```
   [Unit]
   Description=n8n workflow automation
   After=network.target

   [Service]
   Type=simple
   User=your-username
   WorkingDirectory=/home/your-username
   ExecStart=/usr/bin/n8n start
   Restart=always
   RestartSec=10

   [Install]
   WantedBy=multi-user.target
   ```

3. Replace `your-username` with your actual username.

4. Enable and start the service:
   ```
   sudo systemctl enable n8n
   sudo systemctl start n8n
   ```

5. Check the status:
   ```
   sudo systemctl status n8n
   ```

## Integration with Admin Interface

The admin interface already includes a section for n8n access. Once n8n is running, you can access it through the admin interface or directly via the URL.
EOF

echo "n8n setup scripts and instructions have been created!"
echo "To install n8n, run: cd ~/admin-server/n8n && ./install_n8n.sh"
echo "After installation, you can start n8n with: python3 ~/admin-server/scripts/start_n8n.py"
echo "Manual installation instructions are available in: ~/admin-server/n8n/n8n_manual_setup.md"
