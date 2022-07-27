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
domain=$(cat /etc/xray/domain)
sstls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 WS TLS" | cut -d: -f2|sed 's/ //g')"
sstcp="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 TCP" | cut -d: -f2|sed 's/ //g')"
ssnontls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 WS NON TLS" | cut -d: -f2|sed 's/ //g')"
ssgrpc="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 GRPC TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Password : " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/xss.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${CLIENT_NAME}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
passwd=$GESuWIqYcq34MSCDTOck0g==
uuid=$(cat /proc/sys/kernel/random/uuid)
password=$(openssl rand -base64 16)
read -p "Expired (Days) : " masaaktif
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#ss-tcp$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xss.json
sed -i '/#ss-tcp$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#ss-tls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xss.json
sed -i '/#ss-tls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#ss-nontls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xss.json
sed -i '/#ss-nontls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#ss-grpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xss.json
sed -i '/#ss-grpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
cat>/etc/xray/ss-$user-tcp.json<<EOF
{
  "inbounds": [
    {
      "port": 212,
      "protocol": "shadowsocks",
      "settings": {
        "method": "2022-blake3-aes-128-gcm",
        "password": "$passwd:${user}",
        "network": "tcp",
        "port": "$sstcp",
        "security": "tls"
      }
    }
EOF

cat>/etc/xray/ss-$user-tls.json<<EOF
{
  "inbounds": [
    {
      "port": 2053,
      "protocol": "shadowsocks",
      "settings": {
        "method": "2022-blake3-aes-128-gcm",
        "password": "$passwd:${user}",
        "network": "ws",
        "port": "$sstls",
        "path": "/gandring-ws",
        "host": "$domain",
        "security": "tls"
      }
    }
EOF

cat>/etc/xray/ss-$user-nontls.json<<EOF
{
  "inbounds": [
    {
      "port": 80,
      "protocol": "shadowsocks",
      "settings": {
        "method": "2022-blake3-aes-128-gcm",
        "password": "$passwd:${user}",
        "network": "ws",
        "port": "$ssnontls",
        "path": "/gandring-ws",
        "host": "$domain",
        "security": "none"
      }
    }
EOF

cat>/etc/xray/ss-$user-grpc.json<<EOF
{
  "inbounds": [
    {
      "port": 2096,
      "protocol": "shadowsocks",
      "settings": {
        "method": "2022-blake3-aes-128-gcm",
        "password": "$passwd:${user}",
        "network": "grpc",
        "port": "$ssgrpc",
        "path": "gandring-ssgrpc",
        "host": "$domain",
        "security": "tls"
      }
    }
EOF

tmp1=$(echo -n "2022-blake3-aes-128-gcm:$passwd:${user}@${domain}:$sstcp" | base64 -w0)
tmp2=$(echo -n "2022-blake3-aes-128-gcm:$passwd:${user}@${domain}:$sstls" | base64 -w0)
tmp3=$(echo -n "2022-blake3-aes-128-gcm:$passwd:${user}@${domain}:$ssnontls" | base64 -w0)
tmp4=$(echo -n "2022-blake3-aes-128-gcm:$passwd:${user}@${domain}:$ssgrpc" | base64 -w0)

shadowsocks1="ss://$tmp1#$user"
shadowsocks2="ss://$tmp2#$user"
shadowsocks3="ss://$tmp3#$user"
shadowsocks4="ss://$tmp4#$user"

systemctl restart xvmess
systemctl restart xray.service
systemctl restart xss.service
systemctl restart xtrojan.service
service cron restart
clear
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m    🔰AKUN SHADOWSOCKS 2022🔰     \e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Remarks     : ${user}"
echo -e "IP/Host     : ${MYIP}"
echo -e "Address     : ${domain}"
echo -e "Port SS TCP : $sstcp"
echo -e "Port SS WS TLS : $sstls"
echo -e "Port SS WS NON TLS : $ssnontls"
echo -e "Port SS GRPC  : $ssgrpc"
echo -e "Security    : 2022-blake3-aes-128-gcm"
echo -e "Network     : tcp,udp"
echo -e "Password    : ${user}"
echo -e "Created     : $hariini"
echo -e "Expired     : $exp"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SS 2022 TCP: ${shadowsocksnew}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SOCKS5 WS TLS: http://$MYIP:88/SS2023-WS-TLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SOCKS5 WS NON TLS: http://$MYIP:88/SS2022-WS-NONTLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SOCKS5 GRPC: http://$MYIP:88/SS2023-GRPC-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m  🔰LUXURY EDITION BY ZEROSSL🔰   \e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
