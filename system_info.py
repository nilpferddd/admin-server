#!/usr/bin/env python3
# system_info.py - Ein Beispielskript, das Systeminformationen anzeigt

import platform
import psutil
import os
import datetime
import socket

def get_system_info():
    print("=== Systeminformationen ===")
    print(f"Datum und Zeit: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"Hostname: {socket.gethostname()}")
    print(f"Betriebssystem: {platform.system()} {platform.release()}")
    print(f"Architektur: {platform.machine()}")
    print(f"Prozessor: {platform.processor()}")
    
    # CPU-Informationen
    print("\n=== CPU-Informationen ===")
    print(f"Physische Kerne: {psutil.cpu_count(logical=False)}")
    print(f"Logische Kerne: {psutil.cpu_count()}")
    print(f"CPU-Auslastung: {psutil.cpu_percent(interval=1)}%")
    
    # Speicherinformationen
    memory = psutil.virtual_memory()
    print("\n=== Speicherinformationen ===")
    print(f"Gesamter Speicher: {memory.total / (1024**3):.2f} GB")
    print(f"Verfügbarer Speicher: {memory.available / (1024**3):.2f} GB")
    print(f"Speicherauslastung: {memory.percent}%")
    
    # Festplatteninformationen
    print("\n=== Festplatteninformationen ===")
    disk = psutil.disk_usage('/')
    print(f"Gesamter Speicherplatz: {disk.total / (1024**3):.2f} GB")
    print(f"Freier Speicherplatz: {disk.free / (1024**3):.2f} GB")
    print(f"Festplattenauslastung: {disk.percent}%")
    
    # Netzwerkinformationen
    print("\n=== Netzwerkinformationen ===")
    try:
        hostname = socket.gethostname()
        ip_address = socket.gethostbyname(hostname)
        print(f"IP-Adresse: {ip_address}")
    except:
        print("IP-Adresse konnte nicht ermittelt werden")
    
    # Laufende Prozesse
    print("\n=== Top 5 Prozesse nach CPU-Auslastung ===")
    processes = []
    for proc in psutil.process_iter(['pid', 'name', 'cpu_percent']):
        try:
            processes.append(proc.info)
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass
    
    processes = sorted(processes, key=lambda x: x['cpu_percent'], reverse=True)
    for i, proc in enumerate(processes[:5]):
        print(f"{i+1}. PID: {proc['pid']}, Name: {proc['name']}, CPU: {proc['cpu_percent']}%")

if __name__ == "__main__":
    try:
        get_system_info()
    except Exception as e:
        print(f"Fehler: {e}")
