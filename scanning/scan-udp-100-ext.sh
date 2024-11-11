#!/usr/bin/zsh
cd /home/kali/oscp/external/scan-udp-100
sudo nmap -sU -Pn --top-ports=100 --open -vvv -oA udp-100 -iL /home/kali/oscp/external/targets.txt

# Parse common host files that can be enumerated for low hanging fruit
cat udp-100.gnmap | grep 53/open/udp | cut -d " " -f 2 >> dns-hosts.txt
cat udp-100.gnmap | grep 123/open/udp | cut -d " " -f 2 >> ntp-hosts.txt
cat udp-100.gnmap | grep 161/open/udp | cut -d " " -f 2 >> snmp-hosts.txt
cat udp-100.gnmap | grep 500/open/udp | cut -d " " -f 2 >> ike-hosts.txt

# Check what services exist to begin creating markdown files for them in obsidian
cat ./*-hosts.txt
