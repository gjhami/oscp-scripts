#!/usr/bin/zsh
cd /home/kali/oscp/external/scan-tcp-all
sudo nmap -sSV -O -Pn -p- --script=default --open -vvv -oA tcp-all -iL /home/kali/oscp/external/targets.txt

# Manually review results
less ./tcp-all.nmap

# Parse common host files that can be enumerated for low hanging fruit
# cat tcp-all.gnmap | grep 21/open/tcp | cut -d " " -f 2 >> ftp-hosts.txt
# cat tcp-all.gnmap | grep 80/open/tcp | cut -d " " -f 2 >> http-hosts.txt
# cat tcp-all.gnmap | grep 443/open/tcp | cut -d " " -f 2 >> https-hosts.txt
# cat tcp-all.gnmap | grep 445/open/tcp | cut -d " " -f 2 >> smb-hosts.txt
# cat tcp-all.gnmap | grep 3389/open/tcp | cut -d " " -f 2 >> rdp-hosts.txt
# cat tcp-all.gnmap | grep 2222/open/tcp | cut -d " " -f 2 >> ssh-alt-hosts.txt
# cat tcp-all.gnmap | grep 8000/open/tcp | cut -d " " -f 2 >> http-alt-hosts.txt

# Check what services exist to begin creating markdown files for them in obsidian
# cat ./*-hosts.txt
