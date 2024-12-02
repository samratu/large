#!/bin/bash
# My Telegram : https://t.me/zerossl
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
# Getting
MYIP=$(wget -qO- ipinfo.io/ip);
clear
source /var/lib/wisnucs/ipvps.conf
if [[ "$IP2" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP2
fi
IP=$(wget -qO- ipinfo.io/ip);
sstp="$(cat ~/log-install.txt | grep -i SSTP | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Usernew : " -e user
		CLIENT_EXISTS=$(grep -w $user /var/lib/wisnucs/data-user-sstp | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${user}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
read -p "Password : " pass
read -p "Expired (Days) : " masaaktif
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
cat >> /home/sstp/sstp_account <<EOF
$user * $pass *
EOF
echo -e "### $user $exp">>"/var/lib/wisnucs/data-user-sstp"
clear
cat <<EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  | tee -a /etc/log-create-user.log
 🔰 AKUN SSTP 🔰"  | tee -a /etc/log-create-user.log
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  | tee -a /etc/log-create-user.log
echo -e "IP/Host   : $IP"  | tee -a /etc/log-create-user.log
echo -e "Domain    : $domain"  | tee -a /etc/log-create-user.log
echo -e "Username  : $user"  | tee -a /etc/log-create-user.log
echo -e "Password  : $pass"  | tee -a /etc/log-create-user.log
echo -e "Port      : $sstp"  | tee -a /etc/log-create-user.log
echo -e "Cert      : http://$domain:88/server.crt"  | tee -a /etc/log-create-user.log
echo -e "Created   : $hariini"  | tee -a /etc/log-create-user.log
echo -e "Expired   : $exp"  | tee -a /etc/log-create-user.log
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  | tee -a /etc/log-create-user.log
 🔰LUXURY EDITION BY ZEROSSL🔰"  | tee -a /etc/log-create-user.log
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  | tee -a /etc/log-create-user.log
echo "" | tee -a /etc/log-create-user.log
read -n 1 -s -r -p "Press any key to back on menu"
menu
