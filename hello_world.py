#!/usr/bin/env python3
# hello_world.py - Ein einfaches Beispielskript

import datetime

def main():
    print("Hallo von meinem Python-Skript!")
    print(f"Aktuelle Zeit: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("Dieses Skript kann über die Admin-Oberfläche ausgeführt werden.")
    print("Sie können eigene Skripte erstellen und verwalten.")

if __name__ == "__main__":
    main()
