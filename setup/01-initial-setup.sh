#!/usr/bin/zsh
# Note: Requires root privileges
# Installs useful programs and mounts a shared folder

# Setup zsh to track all commands across tmux
echo 'setopt append_history' | sudo tee -a /root/.zshrc >> /home/kali/.zshrc   # append to history file
echo 'setopt extended_history' | sudo tee -a /root/.zshrc >> /home/kali/.zshrc # write the history file in the ':start:elapsed;command' format

# Update the sysetem and install some commonly used tools
apt update --quiet && apt upgrade --assume-yes --quiet
apt autoremove --assume-yes --quiet
apt install neo4j --assume-yes --quiet
apt install peass --assume-yes --quiet
apt install libreoffice --assume-yes --quiet
apt install snmp-mibs-downloader --assume-yes --quiet

# Install autorecon dependencies
apt install python3 --assume-yes --quiet
apt install python3-pip --assume-yes --quiet
apt install python3-venv --assume-yes --quiet
apt install seclists curl dnsrecon enum4linux feroxbuster gobuster impacket-scripts nbtscan nikto nmap onesixtyone oscanner redis-tools smbclient smbmap snmp sslscan sipvicious tnscmd10g whatweb wkhtmltopdf --assume-yes --quiet

# Create a virtual environment and install python modules
if [[ ! -d "/home/kali/.venv" ]]; then
  python -m venv /home/kali/.venv
fi
source /home/kali/.venv/bin/activate
python -m pip install uploadserver
python -m pip install bloodhound

# Install vscode
cd /home/kali/Downloads/
if [[ -f "vscode.deb" ]]; then
  rm -rf vscode.deb
fi
wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O vscode.deb --quiet
apt install ./vscode.deb --assume-yes --quiet

# Setup, mount, and symlink the shared folder
if [[ ! -d "/mnt/hgfs" ]]; then
  mkdir /mnt/hgfs
  echo 'vmhgfs-fuse /mnt/hgfs fuse defaults,allow_other,nofail 0 0' >> /etc/fstab
  ln -s /mnt/hgfs/Exclusions /home/kali/Desktop/shared
fi

# Modify proxychains TCP timeouts to optimize for nmap scanning
sudo sed -i 's/tcp_read_time_out.*/tcp_read_time_out 150/g' /etc/proxychains4.conf
sudo sed -i 's/tcp_connect_time_out.*/tcp_connect_time_out 80/g' /etc/proxychains4.conf

# Modify tmux to preserve sessions and windows after commands complete
echo 'set -g remain-on-exit on' | sudo tee -a /root/.tmux.conf >> /home/kali/.tmux.conf