#!/usr/bin/zsh
# Note: Requires root privileges
# Installs useful programs and mounts a shared folder

# Update the sysetem and install some commonly used tools
apt update && apt upgrade --assume-yes --quiet
apt install neo4j --assume-yes --quiet
apt install peass --assume-yes --quiet
apt install libreoffice --assume-yes --quiet

# Globally install python modules
python -m pip install uploadserver
python -m pip install bloodhound
python -m pip install json.tool

# Install vscode
cd /home/kali/Downloads/
wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O vscode.deb
apt install ./vscode.deb --assume-yes --quiet

# Setup, mount, and symlink the shared folder
mkdir /mnt/hgfs
echo 'vmhgfs-fuse /mnt/hgfs fuse defaults,allow_other,nofail 0 0' >> /etc/fstab
ln -s /etc/hgfs/Exclusions /home/kali/Desktop/shared
