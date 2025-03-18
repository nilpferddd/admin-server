#!/usr/bin/env python3
# stop_vnc.py - Script to stop the VNC server

import subprocess

def stop_vnc():
    print("Stopping VNC server...")
    
    # Kill VNC server instance
    result = subprocess.run(["vncserver", "-kill", ":1"], capture_output=True, text=True)
    
    if result.returncode == 0:
        print("VNC server stopped successfully!")
    else:
        print("Failed to stop VNC server or no server was running")
        print(result.stderr)

if __name__ == "__main__":
    stop_vnc()
