#!/usr/bin/zsh

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

file_path="$1"

for host in $(cat "$file_path"); do
    echo "${host}" 2>&1 | tee -a enum-smb-out.txt

    # List shares
    smbclient --list //"${host}" 2>&1 | tee -a enum-smb-out.txt
    smbmap -H "${host}" 2>&1 | tee -a enum-smb-out.txt

    # List shares (implicit null creds)
    smbclient --no-pass --list //"${host}" 2>&1 | tee -a enum-smb-out.txt

    # List shares (explicit null creds)
    smbclient --user ''%'' --list //"${host}" 2>&1 | tee -a enum-smb-out.txt
    smbmap -u '' -p '' -H "${host}" -r 2>&1 | tee -a enum-smb-out.txt

    # List shares (invalid creds)
    smbmap -u 'test' -p '' -H "${host}" -r 2>&1 | tee -a enum-smb-out.txt

    echo "----------------------------" 2>&1 | tee -a enum-smb-out.txt
    echo "" 2>&1 | tee -a enum-smb-out.txt
done
