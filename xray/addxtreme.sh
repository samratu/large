
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
MYIP=$(wget -qO- https://ipv4.icanhazip.com);
MYIP6=$(wget -qO- https://ipv6.icanhazip.com);
clear
domain=$(cat /etc/xray/domain)

uuid=$(cat /proc/sys/kernel/random/uuid)
tgrpc="$(cat ~/log-install.txt | grep -w "TROJAN GRPC" | cut -d: -f2|sed 's/ //g')"
txtls="$(cat ~/log-install.txt | grep -w "TROJAN XTLS" | cut -d: -f2|sed 's/ //g')"
tgfw="$(cat ~/log-install.txt | grep -w "TROJAN GFW" | cut -d: -f2|sed 's/ //g')"
thdua="$(cat ~/log-install.txt | grep -w "TROJAN H2C" | cut -d: -f2|sed 's/ //g')"
thttp="$(cat ~/log-install.txt | grep -w "TROJAN HTTP TLS" | cut -d: -f2|sed 's/ //g')"
thttpnon="$(cat ~/log-install.txt | grep -w "TROJAN HTTP NON TLS" | cut -d: -f2|sed 's/ //g')"
ttls="$(cat ~/log-install.txt | grep -w "TROJAN WS TLS" | cut -d: -f2|sed 's/ //g')"
tnontls="$(cat ~/log-install.txt | grep -w "TROJAN WS NON TLS" | cut -d: -f2|sed 's/ //g')"
trgo="$(cat ~/log-install.txt | grep -w "TROJAN GO" | cut -d: -f2|sed 's/ //g')"
ssudp="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS UDP" | cut -d: -f2|sed 's/ //g')"
sswstls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS WS TLS" | cut -d: -f2|sed 's/ //g')"
sswsnontls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS WS NON TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Password : " -e user
		user_EXISTS=$(grep -w $user /etc/xray/xtrojan.json | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${user}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Password : " -e user
		user_EXISTS=$(grep -w $user /usr/local/etc/xray/xvmess.json | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${user}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (Days) : " masaaktif
#read -p "Expired (Seconds) : " masaaktif
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
#exp=`date -d "$masaaktif seconds" +"%Y-%m-%d"`
sed -i '/#trojan-grpc$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#trojan-grpc$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/xvmess.json
sed -i '/#trojan-xtls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","flow": "'""xtls-rprx-direct""'", "email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#trojan-hdua$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#trojan-hdua$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/xvmess.json
sed -i '/#trojan-tls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/xvmess.json
sed -i '/#trojan-gfw$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/xvmess.json
sed -i '/#trojan-nontls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#trojan-http-tls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/xvmess.json
sed -i '/#trojan-http-nontls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#xray-ss-udp$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#xray-ss-tls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#xray-ss-nontls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/"'""$uuid""'"$/a\,"'""$uuid""'"' /etc/trojan-go/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
#exp2=`date -d "$masaaktif seconds" +"%Y-%m-%d"`
hariini=`date -d "0 days" +"%Y-%m-%d"`
echo -e "### $user $exp" >> /etc/trojan-go/akun.conf
systemctl restart trojan-go.service
trojango="trojan-go://${uuid}@${domain}:${trgo}/?sni=${domain}&type=ws&host=${domain}&path=/gandring&encryption=none#$user"
trojanhdua="trojan://${uuid}@${domain}:$thdua?sni=${domain}&type=http&security=tls&path=%2ftrojanhttp#${user}"
trojangrpc="trojan://${uuid}@${domain}:$tgrpc?mode=gun&security=tls&type=grpc&serviceName=%2ftrojangrpc&sni=${domain}#${user}"
trojanxtls="trojan://${uuid}@${domain}:$txtls?security=xtls&type=tcp&headerType=none&flow=xtls-rprx-direct#${user}"
trojangfw="trojan://$uuid@$domain:$tgfw?type=tcp&security=tls&headerType=none#$user"
trojantls="trojan://${uuid}@${domain}:$ttls?type=ws&security=tls&host=$domain&path=%2fgandring&sni=$domain#${user}"
trojannontls="trojan://${uuid}@${domain}:$tnontls?type=ws&security=none&host=$domain&path=%2fgandring#${user}"
trojanhttp="trojan://${uuid}@${domain}:$thttp?sni=${domain}&type=tcp&security=tls&path=%2ftrojantcp&headerType=http#${user}"
trojanhttpnon="trojan://${uuid}@${domain}:$thttpnon?sni=${domain}&type=tcp&security=none&host=${domain}&headerType=http#${user}"
systemctl restart xray.service
systemctl restart xtrojan.service
systemctl restart xvmess
service cron restart
clear
echo -e ""
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m 🔰 AKUN TROJAN TESTER 🔰 \e[m"       
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "NAMA             :${user}"
echo -e "IP/Host :${MYIP} / $domain"
echo -e "Protocol         :GRPC,H2C,GFW,XTLS,WS,HTTP,GO"
echo -e "ServiceName      :/trojangrpc"
echo -e "Path WS          :/gandring"
echo -e "Path H2C         :/trojanhttp"
echo -e "Path HTTP        :/trojantcp"
echo -e "Path Trojan-Go   :/gandring"
echo -e "Port GRPC        :${tgrpc}"
echo -e "Port WSTLS       :${ttls}"
echo -e "Port WS Non TLS  :${tnontls}"
echo -e "Port H2C         :${thdua}"
echo -e "Port HTTP TLS    :${thttp}"
echo -e "Port HTTP NonTLS :${thttpnon}"
echo -e "Port GFW         :${tgfw}"
echo -e "Port XTLS        :${txtls}" 
echo -e "Password         :${uuid}"
echo -e "Created          :$hariini"
echo -e "Expired          :$exp"
#echo -e "Expired         :$exp2"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link GRPC:  ${trojangrpc}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link XTLS:  ${trojanxtls}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link GFW:  ${trojangfw}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link HTTP/2:  ${trojanhdua}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link WS TLS:  ${trojantls}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link WS NONTLS:  ${trojannontls}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link HTTP TLS:  ${trojanhttp}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link HTTP NONTLS:  ${trojanhttpnon}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link TROJAN GO:  ${trojango}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m🔰LUXURY EDITION ZEROSSL🔰\e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
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
MYIP=$(wget -qO- https://ipv4.icanhazip.com);
MYIP6=$(wget -qO- https://ipv6.icanhazip.com);
clear
domain=$(cat /etc/xray/domain)
tls="$(cat ~/log-install.txt | grep -w "VMESS WS TLS" | cut -d: -f2|sed 's/ //g')"
nontls="$(cat ~/log-install.txt | grep -w "VMESS WS NON TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Username : " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${CLIENT_NAME}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Username : " -e user
		CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/xvmess.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${CLIENT_NAME}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (Days) : " masaaktif
#read -p "Expired (Seconds) : " masaaktif
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
#exp2=`date -d "$masaaktif seconds" +"%Y-%m-%d"`
sed -i '/#vmess-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /usr/local/etc/xray/xvmess.json
sed -i '/#vmess-nontls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/config.json
cat>/etc/xray/vmess-$user-tls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${tls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/cokro",
      "type": "none",
      "host": "${domain}",
      "tls": "tls"
}
EOF
cat>/etc/xray/vmess-$user-nontls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${nontls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "gandring",
      "type": "none",
      "host": "${domain}",
      "tls": "none"
}
EOF
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess1="vmess://$(base64 -w 0 /etc/xray/vmess-$user-tls.json)"
vmess2="vmess://$(base64 -w 0 /etc/xray/vmess-$user-nontls.json)"
rm -rf /etc/xray/vmess-$user-tls.json
rm -rf /etc/xray/vmess-$user-nontls.json

vmgrpc="$(cat ~/log-install.txt | grep -w "VMESS GRPC TLS" | cut -d: -f2|sed 's/ //g')"
vmgrpcnon="$(cat ~/log-install.txt | grep -w "VMESS GRPC NON TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A Client Username Was Already Created, Please Enter New Username"
			exit 1
		fi
	done
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/xvless.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A Client Username Was Already Created, Please Enter New Username"
			exit 1
		fi
	done
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/xvmess.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A Client Username Was Already Created, Please Enter New Username"
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (Days): " masaaktif
#read -p "Expired (Seconds) : " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
#exp2=`date -d "$masaaktif seconds" +"%Y-%m-%d"`
sed -i '/#vmess-grpc-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/xvless.json
sed -i '/#vmess-grpc-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/xray/xvmess.json
sed -i '/#vmess-grpc-nontls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
cat>/etc/xray/vmess-$user-tls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${vmgrpc}",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "/vmessgrpc",
      "type": "none",
      "host": "${domain}",
      "tls": "tls"
}
EOF
cat>/etc/xray/vmess-$user-nontls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${vmgrpcnon}",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "/gandring",
      "type": "none",
      "host": "${domain}",
      "tls": "none"
}
EOF
vmess_base641=$( base64 -w 0 <<< vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmessgrpc="vmess://$(base64 -w 0 /etc/xray/vmess-$user-tls.json)"
vmessgrpcnon="vmess://$(base64 -w 0 /etc/xray/vmess-$user-nontls.json)"

domain=$(cat /etc/xray/domain)
vmhdua="$(cat ~/log-install.txt | grep -w "VMESS H2C TLS" | cut -d: -f2|sed 's/ //g')"
#none="$(cat ~/log-install.txt | grep -w "Vmess None TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A Client Username Was Already Created, Please Enter New Username"
			exit 1
		fi
	done
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/xvmess.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A Client Username Was Already Created, Please Enter New Username"
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (Days): " masaaktif
#read -p "Expired (Seconds) : " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
#exp2=`date -d "$masaaktif seconds" +"%Y-%m-%d"`
sed -i '/#vmess-hdua$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vmess-hdua$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/xray/xvmess.json
#sed -i '/#none$/a\### '"$user $exp"'\
#},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
cat>/etc/xray/vmess-$user-tls.json<<EOF
      {
      "v": "0",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${vmhdua}",
      "id": "${uuid}",
      "aid": "0",
      "net": "h2",
      "path": "/vmesshttp",
      #"type": "multi",
      "host": "$domain",
      "tls": "tls"
}
EOF
vmesshdua=$( base64 -w 0 <<< $vmess_json1)
#vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmesshdua="vmess://$(base64 -w 0 /etc/xray/vmess-$user-tls.json)"
#vmessgrpclink2="vmess://$(base64 -w 0 /etc/xray/$user-none.json)"

domain=$(cat /etc/xray/domain)
vmhttp="$(cat ~/log-install.txt | grep -w "VMESS HTTP TLS" | cut -d: -f2|sed 's/ //g')"
vmhttpnon="$(cat ~/log-install.txt | grep -w "VMESS HTTP NON TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A Client Username Was Already Created, Please Enter New Username"
			exit 1
		fi
	done
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/xvmess.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A Client Username Was Already Created, Please Enter New Username"
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (Days): " masaaktif
#read -p "Expired (Seconds) : " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
#exp2=`date -d "$masaaktif seconds" +"%Y-%m-%d"`
sed -i '/#vmess-http-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/xray/xvmess.json
sed -i '/#vmess-http-nontls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
cat>/etc/xray/vmess-$user-tls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${vmhttp}",
      "id": "${uuid}",
      "aid": "0",
      "net": "tcp",
      "path": "/wisnu",
      "type": "http",
      "host": "${domain}",
      "tls": "tls"
}
EOF
cat>/etc/xray/vmess-$user-nontls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${vmhttpnon}",
      "id": "${uuid}",
      "aid": "0",
      "net": "tcp",
      #"path": "/",
      "type": "http",
      "host": "${domain}",
      "tls": "none"
}
EOF
vmesshttp_base641=$( base64 -w 0 <<< $vmess_json1)
vmesshttp_base642=$( base64 -w 0 <<< $vmess_json2)
vmesshttp="vmess://$(base64 -w 0 /etc/xray/vmess-$user-tls.json)"
vmesshttpnon="vmess://$(base64 -w 0 /etc/xray/vmess-$user-nontls.json)"
systemctl restart xvless
systemctl restart xray.service
systemctl restart xvmess
service cron restart
clear
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m  🔰AKUN VMESS TESTER🔰   \e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "NAMA        :${user}"
echo -e "IP :${MYIP}/ ${domain}"
echo -e "Port WS     :${tls}/${nontls}"
echo -e "Port GRPC   :${vmgrpc}/${vmgrpcnon}"
echo -e "Port H2C    :${vmhdua}"
echo -e "Port HTTP   :${vmhttp}/${vmhttpnon}"
echo -e "User ID     :${uuid}"
echo -e "Network     :WS,GRPC,H2C,HTTP"
echo -e "Path WS     :/cokro,gandring"
echo -e "Pat H2C     :/vmesshttp"
echo -e "ServiceName :/vmessgrpc"
echo -e "Path HTTP   :/wisnu"
echo -e "Created     :$hariini"
echo -e "Expired     :$exp"
#echo -e "Expired     :$exp2"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link WS TLS:  ${vmess1}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link WS NONTLS:  ${vmess2}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link GRPC TLS:  ${vmessgrpc}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link GRPC NONTLS:  ${vmessgrpcnon}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link HTTP/2 TLS:  ${vmesshdua}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link HTTP TLS:  ${vmesshttp}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link HTTP NONTLS:  ${vmesshttpnon}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m🔰LUXURY EDITION ZEROSSL🔰\e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
