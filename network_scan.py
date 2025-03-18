#!/usr/bin/env python3
# network_scan.py - Ein Skript zum Scannen des lokalen Netzwerks

import socket
import subprocess
import platform
import ipaddress

def get_network_info():
    """Ermittelt die lokale IP-Adresse und das Netzwerk"""
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    
    # Einfache Annahme für die Netzwerkmaske (könnte in einer realen Umgebung angepasst werden)
    network = '.'.join(ip_address.split('.')[:3]) + '.0/24'
    
    return ip_address, network

def ping_host(ip):
    """Pingt einen Host an und gibt zurück, ob er erreichbar ist"""
    param = '-n' if platform.system().lower() == 'windows' else '-c'
    command = ['ping', param, '1', ip]
    
    try:
        output = subprocess.check_output(command, stderr=subprocess.STDOUT, universal_newlines=True)
        return True
    except subprocess.CalledProcessError:
        return False

def scan_network(network):
    """Scannt das angegebene Netzwerk nach aktiven Hosts"""
    print(f"Scanne Netzwerk: {network}")
    print("Dies kann einige Zeit dauern...")
    
    network_obj = ipaddress.IPv4Network(network)
    active_hosts = []
    
    # Begrenze auf die ersten 20 Hosts für schnellere Demonstration
    hosts_to_scan = list(network_obj.hosts())[:20]
    
    for i, host in enumerate(hosts_to_scan):
        ip = str(host)
        print(f"Prüfe {ip} ({i+1}/{len(hosts_to_scan)})...", end="\r")
        
        if ping_host(ip):
            print(f"Host gefunden: {ip}           ")
            active_hosts.append(ip)
    
    return active_hosts

def main():
    try:
        local_ip, network = get_network_info()
        print(f"Lokale IP-Adresse: {local_ip}")
        print(f"Netzwerk: {network}")
        
        active_hosts = scan_network(network)
        
        print("\n=== Scan-Ergebnisse ===")
        print(f"Aktive Hosts im Netzwerk: {len(active_hosts)}")
        for i, host in enumerate(active_hosts):
            print(f"{i+1}. {host}")
            
    except Exception as e:
        print(f"Fehler: {e}")

if __name__ == "__main__":
    main()
