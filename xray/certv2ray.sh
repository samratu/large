#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
clear
echo start
sleep 0.5
source /var/lib/wisnucs/ipvps.conf
domain=$IP
systemctl stop xray

/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.cer --keypath /etc/xray/xray.key --ecc
systemctl start xray
echo Done
