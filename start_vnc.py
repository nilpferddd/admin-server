#!/usr/bin/env python3
# start_vnc.py - Script to start the VNC server

import os
import subprocess
import socket

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

def start_vnc():
    print("Starting VNC server...")
    
    # Kill any existing VNC server instances
    try:
        subprocess.run(["vncserver", "-kill", ":1"], check=False)
    except:
        pass
    
    # Start VNC server with simplified options to avoid hostname issues
    # First set a hostname in /etc/hosts to avoid the hostname lookup issue
    with open('/etc/hosts', 'r') as f:
        hosts_content = f.read()
    
    if 'admin-server' not in hosts_content:
        try:
            subprocess.run(['sudo', 'sh', '-c', 'echo "127.0.0.1 admin-server" >> /etc/hosts'], check=True)
        except:
            print("Warning: Could not update /etc/hosts file. VNC might not work properly.")
    
    os.environ['DISPLAY'] = ':1'
    # Use a simpler command with fewer options
    result = subprocess.run(["vncserver", "-geometry", "1024x768", "-depth", "24"], capture_output=True, text=True)
    
    if result.returncode == 0:
        ip = get_ip()
        print(f"VNC server started successfully!")
        print(f"You can connect to the VNC server at: {ip}:5901")
        print(f"Password: changeme (you should change this)")
    else:
        print("Failed to start VNC server")
        print(result.stderr)

if __name__ == "__main__":
    start_vnc()
