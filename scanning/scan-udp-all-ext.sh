#!/usr/bin/zsh

# Scan all tcp ports with OS discovery, versioning, and default scripts
cd /home/kali/oscp/external/scan-tcp-all
sudo nmap -sUV -Pn -p- --script=default --open -vvv -oA udp-all -iL /home/kali/oscp/external/targets.txt

less udp-all.nmap
