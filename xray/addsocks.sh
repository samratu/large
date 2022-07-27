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

uuid=$(cat /proc/sys/kernel/random/uuid)
stls="$(cat ~/log-install.txt | grep -w "SOSCKS5 WS TLS" | cut -d: -f2|sed 's/ //g')"
snontls="$(cat ~/log-install.txt | grep -w "SOSCKS5 WS NON TLS" | cut -d: -f2|sed 's/ //g')"
sgrpc="$(cat ~/log-install.txt | grep -w "SOSCKS5 GRPC TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Password : " -e user
		user_EXISTS=$(grep -w $user /etc/xray/xvmess.json | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${user}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (Days) : " masaaktif
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#socks-tls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#socks-tls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#socks-tls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#socks-grpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#socks-grpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#socks-grpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
cat>/etc/xray/socks-$user-tls.json<<EOF
{
  "add": "$domain",
  "port": "443",
  "auth": "password",
  "accounts": [
    {
      "user": "${user}",
      "pass": "${user}"
    }
  ],
  "udp": true
}
EOF

cat>/etc/xray/SOCKS5-WS-TLS-$user.json<<EOF
{
        "listen": "127.0.0.1",
        "port": "443",
        "protocol": "socks",
        "settings": {
          "auth": "password",
             "accounts": [
          {
                 "user": "${user}",
                 "pass": "${user}"
#socks-tls
           }
          ],
         "level": 0,
          "udp": true
       },
       "streamSettings":{
          "network": "ws",
             "wsSettings": {
               "path": "/gandring-socksws"
           }
        }
     },
EOF
cat > /home/vps/public_html/SOCKS5-WS-TLS-$user.json.txt<<END

cat>/etc/xray/SICKS5-WS-NONTLS-$user.json<<EOF
{
        "listen": "127.0.0.1",
        "port": "80",
        "protocol": "socks",
        "settings": {
          "auth": "password",
             "accounts": [
          {
                 "user": "${user}",
                 "pass": "${user}"
#socks-tls
           }
          ],
         "level": 0,
          "udp": true
       },
       "streamSettings":{
          "network": "ws",
             "wsSettings": {
               "path": "/gandring-socksws"
           }
        }
     },
EOF
cat > /home/vps/public_html/SOCKS5-WS-NONTLS-$user.json.txt<<END

cat>/etc/xray/SOCKS5-GRPC-$user.json<<EOF
{
        "listen": "127.0.0.1",
        "port": "443",
        "protocol": "socks",
        "settings": {
          "auth": "password",
             "accounts": [
          {
                 "user": "${user}",
                 "pass": "${user}"
#socks-grpc
           }
          ],
         "level": 0,
          "udp": true
       },
       "streamSettings":{
          "network": "grpc",
             "grpcSettings": {
               "path": "/gandring-socksgrpc"
           }
        }
     },
EOF
cat > /home/vps/public_html/SOCKS5-GRPC-$user.json.txt<<END

tmp1=$(echo -n "${user}:${user}@${domain}:$stls" | base64 -w0)
tmp2=$(echo -n "${user}:${user}@${domain}:$snontls" | base64 -w0)
tmp3=$(echo -n "${user}:${user}@${domain}:$sgrpc" | base64 -w0)
socks1="socks://$tmp1#$user"
socks2="socks://$tmp2#$user"
socks3="socks://$tmp3#$user"
systemctl restart xtrojan
systemctl restart xss
systemctl restart xvmess.service
systemctl restart xray.service

cat /etc/xray/SOCKS5-GRPC-$user.json >> /home/vps/public_html/SOCKS5-GRPC-$user.txt
cat /etc/xray/SOCKS5-WS-TLS-$user.json >> /home/vps/public_html/SOCKS5-WS-TLS-$user.txt
cat /etc/xray/SOCKS5-WS-NONTLS-$user.json >> /home/vps/public_html/SOCKS5-WS-NONTLS-$user.txt
service cron restart

rm -rf /etc/xray/SOCKS5-WS-TLS-$user.json
rm -rf /etc/xray/SOCKS5-WS-NONTLS-$user.json
rm -rf /etc/xray/SOCKS5-GRPC-$user.json
clear
echo -e ""
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m 🔰 AKUN SOCKS5 WS GRPC🔰 \e[m"       
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Remarks  : ${user}"
echo -e "IP/Host  : ${MYIP}"
echo -e "Address  : ${domain}"
echo -e "Protocol : tcp,udp,ws,grpc"
echo -e "ServiceName: gandring-socksgrpc"
echo -e "Path WS : /gandring-socksws"
echo -e "Port TLS : ${stls}"
echo -e "Port WS NON TLS : ${snontls}"
echo -e "Password : ${user}"
echo -e "Created  : $hariini"
echo -e "Expired  : $exp"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SOCKS5 TCP: ${socks1}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SOCKS5 WS TLS: http://$MYIP:88/SOCKS5-WS-TLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SOCKS5 WS NON TLS: http://$MYIP:88/SOCKS5-WS-NONTLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SOCKS5 GRPC: http://$MYIP:88/SOCKS5-GRPC-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m🔰LUXURY EDITION ZEROSSL🔰\e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
