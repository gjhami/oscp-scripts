#!/usr/bin/zsh
# Note: Proxychains must be configured before scanning internal hosts

cd /home/kali/oscp/internal/scan-tcp-1000
sudo proxychains -q nmap -sT -Pn --top-ports=1000 --open -vvv -oA tcp-1000 -iL /home/kali/oscp/internal/targets.txt

# Parse common host files that can be enumerated for low hanging fruit
cat tcp-1000.gnmap | grep 21/open/tcp | cut -d " " -f 2 >> ftp-hosts.txt
cat tcp-1000.gnmap | grep 22/open/tcp | cut -d " " -f 2 >> ssh-hosts.txt
cat tcp-1000.gnmap | grep 80/open/tcp | cut -d " " -f 2 >> http-hosts.txt
cat tcp-1000.gnmap | grep 443/open/tcp | cut -d " " -f 2 >> https-hosts.txt
cat tcp-1000.gnmap | grep 445/open/tcp | cut -d " " -f 2 >> smb-hosts.txt
cat tcp-1000.gnmap | grep 3389/open/tcp | cut -d " " -f 2 >> rdp-hosts.txt
cat tcp-1000.gnmap | grep 2222/open/tcp | cut -d " " -f 2 >> ssh-alt-hosts.txt
cat tcp-1000.gnmap | grep 8000/open/tcp | cut -d " " -f 2 >> http-alt-hosts.txt

# Check what services exist to begin creating markdown files for them in obsidian
cat ./*-hosts.txt
