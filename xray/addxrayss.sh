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
sstls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS WS TLS" | cut -d: -f2|sed 's/ //g')"
sstcp="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS TCP" | cut -d: -f2|sed 's/ //g')"
ssnontls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS WS NON TLS" | cut -d: -f2|sed 's/ //g')"
ssudp="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS UDP" | cut -d: -f2|sed 's/ //g')"
ssnew="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Password : " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${CLIENT_NAME}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (Days) : " masaaktif
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#xray-ss-tcp$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/config.json
sed -i '/#xray-ss-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xtrojan.json
sed -i '/#xray-ss-nontls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xtrojan.json
sed -i '/#xray-ss-udp$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xtrojan.json
sed -i '/#xray-new-ss$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xss.json
cat>/etc/xray/ss-$user-tcp.json<<EOF
      {
      "port": 333,
      "protocol": "shadowsocks",
      "settings": {
        "method": "chacha20-poly1305",
        "password": "${user}",
        "network": "tcp,udp"
      }
    },
EOF
cat>/etc/xray/ss-$user-udp.json<<EOF
      {
      "port": 503,
      "protocol": "shadowsocks",
      "settings": {
        "method": "aes-128-gcm",
        "password": "${user}",
        "network": "tcp,udp"
      }
    },
EOF
cat>/etc/xray/ss-$user-tls.json<<EOF
      {
      "port": 501,
      "protocol": "shadowsocks",
      "settings": {
        "method": "aes-128-gcm",
        "password": "${user}",
        "network": "ws",
        "security": "tls",
        "path": "/gandring",
        "host": "$domain"
      }
    },
EOF
cat>/etc/xray/ss-$user-nontls.json<<EOF
      {
      "port": 502,
      "protocol": "shadowsocks",
      "settings": {
        "method": "aes-128-gcm",
        "password": "${user}",
        "network": "ws",
        "security": "none",
        "path": "/gandring",
        "host": "$domain"
      }
    },
EOF
cat>/etc/xray/ss-$user-new.json<<EOF
      {
  "inbounds": [
    {
      "port": 212,
      "protocol": "shadowsocks",
      "settings": {
        "method": "2022-blake3-aes-128-gcm",
        "password": "gandring",
        "network": "tcp,udp"
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

tmp1=$(echo -n "aes-256-gcm:${user}@${domain}:$sstcp" | base64 -w0)
tmp2=$(echo -n "aes-128-gcm:${user}@${domain}:$sstls" | base64 -w0)
tmp3=$(echo -n "aes-128-gcm:${user}@${domain}:$ssnontls" | base64 -w0)
tmp4=$(echo -n "aes-128-gcm:${user}@${domain}:$ssudp" | base64 -w0)
tmp5=$(echo -n "2022-blake3-aes-128-gcm:${user}@${domain}:$ssnew" | base64 -w0)
shadowsockstcp="ss://$tmp1#$user"
shadowsockstls="ss://$tmp2#$user"
shadowsocksnontls="ss://$tmp3#$user"
shadowsocksudp="ss://$tmp4#$user"
shadowsocksnew="ss://$tmp5#$user"
systemctl restart xray.service
systemctl restart xss.service
systemctl restart xtrojan.service
service cron restart
clear
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m      🔰AKUN SHADOWSOCKS 🔰       \e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Remarks     : ${user}"
echo -e "IP/Host     : ${MYIP}"
echo -e "Address     : ${domain}"
#echo -e "Port TLS    : ${tls}"
echo -e "Port SS     : ${sstcp},$ssudp,$sstls,$ssnontls,$ssnew"
#echo -e "User ID     : ${uuid}"
#echo -e "Alter ID    : 0"
echo -e "Security    : aes-256-gcm"
echo -e "Security    : aes-128-gcm"
echo -e "Security    : chacha20-poly1305"
echo -e "Security    : 2022-blake3-aes-128-gcm"
echo -e "Network     : tcp,udp"
echo -e "Password    : ${user}"
echo -e "Created     : $hariini"
echo -e "Expired     : $exp"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link SS tcp : ${shadowsockstcp}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link SS udp : ${shadowsocksudp}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link SS tls : ${shadowsockstls}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link SS nontls : ${shadowsocksnontls}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link SS new : ${shadowsocksnew}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m  🔰LUXURY EDITION BY ZEROSSL🔰   \e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
