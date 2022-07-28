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
Password=$Username
domain=$(cat /etc/xray/domain)
vmgrpc="$(cat ~/log-install.txt | grep -w "VMESS GRPC TLS" | cut -d: -f2|sed 's/ //g')"
vquic="$(cat ~/log-install.txt | grep -w "VLESS QUIC TLS" | cut -d: -f2|sed 's/ //g')"
tquic="$(cat ~/log-install.txt | grep -w "TROJAN QUIC TLS" | cut -d: -f2|sed 's/ //g')"
vmhdua="$(cat ~/log-install.txt | grep -w "VMESS H2C TLS" | cut -d: -f2|sed 's/ //g')"
vmquic="$(cat ~/log-install.txt | grep -w "VMESS QUIC TLS" | cut -d: -f2|sed 's/ //g')"
vmhttp="$(cat ~/log-install.txt | grep -w "VMESS HTTP TLS" | cut -d: -f2|sed 's/ //g')"
vmhttpnon="$(cat ~/log-install.txt | grep -w "VMESS HTTP NON TLS" | cut -d: -f2|sed 's/ //g')"
tls="$(cat ~/log-install.txt | grep -w "VMESS WS TLS" | cut -d: -f2|sed 's/ //g')"
nontls="$(cat ~/log-install.txt | grep -w "VMESS WS NON TLS" | cut -d: -f2|sed 's/ //g')"
vlgrpc="$(cat ~/log-install.txt | grep -w "VLESS GRPC TLS" | cut -d: -f2|sed 's/ //g')"
vlgrpcnon="$(cat ~/log-install.txt | grep -w "VLESS GRPC NON TLS" | cut -d: -f2|sed 's/ //g')"
vlxtls="$(cat ~/log-install.txt | grep -w "VLESS XTLS" | cut -d: -f2|sed 's/ //g')"
vlnontls="$(cat ~/log-install.txt | grep -w "VLESS WS NON TLS" | cut -d: -f2|sed 's/ //g')"
vltls="$(cat ~/log-install.txt | grep -w "VLESS WS TLS" | cut -d: -f2|sed 's/ //g')"
vlhdua="$(cat ~/log-install.txt | grep -w "VLESS H2C TLS" | cut -d: -f2|sed 's/ //g')"
vlhduanon="$(cat ~/log-install.txt | grep -w "VLESS H2C NON TLS" | cut -d: -f2|sed 's/ //g')"
vlhttp="$(cat ~/log-install.txt | grep -w "VLESS HTTP TLS" | cut -d: -f2|sed 's/ //g')"
vlhttpnon="$(cat ~/log-install.txt | grep -w "VLESS HTTP NON TLS" | cut -d: -f2|sed 's/ //g')"
tls="$(cat ~/log-install.txt | grep -w "VMESS WS TLS" | cut -d: -f2|sed 's/ //g')"
nontls="$(cat ~/log-install.txt | grep -w "VMESS WS NON TLS" | cut -d: -f2|sed 's/ //g')"
uuid=$(cat /proc/sys/kernel/random/uuid)
tgrpc="$(cat ~/log-install.txt | grep -w "TROJAN GRPC TLS" | cut -d: -f2|sed 's/ //g')"
txtls="$(cat ~/log-install.txt | grep -w "TROJAN XTLS" | cut -d: -f2|sed 's/ //g')"
tgfw="$(cat ~/log-install.txt | grep -w "TROJAN GFW" | cut -d: -f2|sed 's/ //g')"
thdua="$(cat ~/log-install.txt | grep -w "TROJAN H2C TLS" | cut -d: -f2|sed 's/ //g')"
thttp="$(cat ~/log-install.txt | grep -w "TROJAN HTTP TLS" | cut -d: -f2|sed 's/ //g')"
thttpnon="$(cat ~/log-install.txt | grep -w "TROJAN HTTP NON TLS" | cut -d: -f2|sed 's/ //g')"
ttls="$(cat ~/log-install.txt | grep -w "TROJAN WS TLS" | cut -d: -f2|sed 's/ //g')"
tnontls="$(cat ~/log-install.txt | grep -w "TROJAN WS NON TLS" | cut -d: -f2|sed 's/ //g')"
trgo="$(cat ~/log-install.txt | grep -w "TROJAN GO" | cut -d: -f2|sed 's/ //g')"
ssudp="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS TCP" | cut -d: -f2|sed 's/ //g')"
sswstls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS WS TLS" | cut -d: -f2|sed 's/ //g')"
sswsnontls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS WS NON TLS" | cut -d: -f2|sed 's/ //g')"
sstls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 WS NON TLS" | cut -d: -f2|sed 's/ //g')"
ssnontls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 WS NON TLS" | cut -d: -f2|sed 's/ //g')"
ssgrpc="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 GRPC" | cut -d: -f2|sed 's/ //g')"
sstcp="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 TCP" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Username : " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${user}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Username : " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/xvless.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${user}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Username : " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/xvmess.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${user}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Username : " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/xtrojan.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
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
#exp2=`date -d "$masaaktif seconds" +"%Y-%m-%d"`
sed -i '/#vless-xtls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","flow": "'""xtls-rprx-direct""'", "email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#trojan-xtls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","flow": "'""xtls-rprx-direct""'", "email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#vless-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#vless-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#vless-grpc-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#vless-http-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#vless-grpc-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#vless-grpc-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#vless-hdua$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#vless-hdua$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#trojan-tls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#trojan-tls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#trojan-gfw$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#trojan-quic$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#trojan-quic$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#vless-quic$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#vless-quic$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#trojan-hdua$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#trojan-http-tls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#trojan-hdua$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#trojan-grpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#trojan-grpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#socks-grpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#socks-tls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#socks-tls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#socks-grpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#socks-grpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#ss-tls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xtrojan.json
sed -i '/#ss-tls$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#ss-grpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#vmess-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xvmess.json
sed -i '/#vmess-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xtrojan.json
cat>/etc/xray/vmess-$user-tls.json<<EOF
      {
      "v": "4",
      "ps": "🔰VMESS WS TLS ${user}",
      "add": "${domain}",
      "port": "${tls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/shanum",
      "type": "none",
      "host": "${domain}",
      "tls": "tls"
}
EOF
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess1="vmess://$(base64 -w 0 /etc/xray/vmess-$user-tls.json)"
rm -rf /etc/xray/vmess-$user-tls.json

sed -i '/#vmess-http-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xvmess.json
sed -i '/#vmess-http-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xtrojan.json
cat>/etc/xray/vmess-$user-tls.json<<EOF
      {
      "v": "5",
      "ps": "🔰VMESS HTTP TLS ${user}",
      "add": "${domain}",
      "port": "${vmhttp}",
      "id": "${uuid}",
      "aid": "0",
      "net": "tcp",
      "path": "/shanumtcp",
      "type": "http",
      "host": "${domain}",
      "tls": "tls"
}
EOF
vmesshttp_base641=$( base64 -w 0 <<< $vmess_json1)
vmesshttp="vmess://$(base64 -w 0 /etc/xray/vmess-$user-tls.json)"
rm -rf /etc/xray/vmess-$user-tls.json

sed -i '/#vmess-hdua$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xvmess.json
sed -i '/#vmess-hdua$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xtrojan.json
cat>/etc/xray/vmess-$user-tls.json<<EOF
      {
      "v": "4",
      "ps": "🔰VMESS H2C TLS ${user}",
      "add": "${domain}",
      "port": "${vmhdua}",
      "id": "${uuid}",
      "aid": "0",
      "net": "h2",
      "path": "shanumhttp",
      "type": "none",
      "host": "${domain}",
      "tls": "tls"
}
EOF
vmesshdua_base641=$( base64 -w 0 <<< $vmess_json1)
vmesshdua="vmess://$(base64 -w 0 /etc/xray/vmess-$user-tls.json)"
rm -rf /etc/xray/vmess-$user-tls.json

sed -i '/#vmess-grpc-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xvmess.json
sed -i '/#vmess-grpc-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xtrojan.json
cat>/etc/xray/vmess-$user-tls.json<<EOF
      {
      "v": "4",
      "ps": "🔰VMESS GRPC TLS ${user}",
      "add": "${domain}",
      "port": "${vmgrpc}",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "shanumgrpc",
      "type": "none",
      "host": "${domain}",
      "tls": "tls"
}
EOF
vmessgrpc_base641=$( base64 -w 0 <<< $vmess_json1)
vmessgrpc="vmess://$(base64 -w 0 /etc/xray/vmess-$user-tls.json)"
rm -rf /etc/xray/vmess-$user-tls.json

sed -i '/#vmess-quic$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xvmess.json
sed -i '/#vmess-quic$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/xtrojan.json
cat>/etc/xray/vmess-$user-tls.json<<EOF
      {
      "v": "4",
      "ps": "🔰VMESS QUIC TLS ${user}",
      "add": "${domain}",
      "port": "${vmquic}",
      "id": "${uuid}",
      "aid": "0",
      "net": "quic",
      "path": "shanumquic",
      "type": "none",
      "host": "${domain}",
      "tls": "tls"
}
EOF
vmessquic_base641=$( base64 -w 0 <<< $vmess_json1)
vmessquic="vmess://$(base64 -w 0 /etc/xray/vmess-$user-tls.json)"
rm -rf /etc/xray/vmess-$user-tls.json

uuid=$(cat /proc/sys/kernel/random/uuid)
stls="$(cat ~/log-install.txt | grep -w "SOCKS5 WS TLS" | cut -d: -f2|sed 's/ //g')"
snontls="$(cat ~/log-install.txt | grep -w "SOCKS5 WS NON TLS" | cut -d: -f2|sed 's/ //g')"
sgrpc="$(cat ~/log-install.txt | grep -w "SOCKS5 GRPC TLS" | cut -d: -f2|sed 's/ //g')"
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
cat>/etc/xray/SOCKS5-WS-TLS-$user.json<<EOF
{
"dns": {
"hosts": {
"domain:googleapis.cn": "googleapis.com"
},
"servers": [
"1.1.1.1"
]
},
"inbounds": [
{
"listen": "127.0.0.1",
"port": "10808",
"protocol": "socks",
"settings": {
"auth": "noauth",
"udp": true,
"userLevel": 8
},
"sniffing": {
"destOverride": [
"http",
"tls"
],
"enabled": true
},
"tag": "socks"
},
{
"listen": "127.0.0.1",
"port": "10809",
"protocol": "http",
"settings": {
"userLevel": 8
},
"tag": "http"
}
],
"log": {
"loglevel": "warning"
},
"outbounds": [
{
"mux": {
"concurrency": 8,
"enabled": true
},
"protocol": "socks",
"settings": {
"servers": [
{
"address": "$domain",
"port": 443,
"users": [
{
"level": 0,
"user": "$user",
"pass": "$user"
}
]
}
]
},
"streamSettings": {
"network": "ws",
"security": "tls",
"tlsSettings": {
"allowInsecure": true,
"serverName": "$domain"
},
"wsSettings": {
"headers": {
"Host": "$domain"
},
"path": "/wisnu-ws"
}
},
"tag": "proxy"
},
{
"protocol": "freedom",
"settings": {},
"tag": "direct"
},
{
"protocol": "blackhole",
"settings": {
"response": {
"type": "http"
}
},
"tag": "block"
}
],
"policy": {
"levels": {
"8": {
"connIdle": 300,
"downlinkOnly": 1,
"handshake": 4,
"uplinkOnly": 1
}
},
"system": {
"statsOutboundDownlink": true,
"statsOutboundUplink": true
}
},
"routing": {
"domainStrategy": "Asls",
"rules": []
},
"stats": {}
}
EOF
cat > /home/vps/public_html/SOCKS5-WS-TLS-$user.txt<<END

cat>/etc/xray/SOCKS5-WS-NONTLS-$user.json<<EOF
{
"dns": {
"hosts": {
"domain:googleapis.cn": "googleapis.com"
},
"servers": [
"1.1.1.1"
]
},
"inbounds": [
{
"listen": "127.0.0.1",
"port": "10808",
"protocol": "socks",
"settings": {
"auth": "noauth",
"udp": true,
"userLevel": 8
},
"sniffing": {
"destOverride": [
"http",
"tls"
],
"enabled": true
},
"tag": "socks"
},
{
"listen": "127.0.0.1",
"port": "10809",
"protocol": "http",
"settings": {
"userLevel": 8
},
"tag": "http"
}
],
"log": {
"loglevel": "warning"
},
"outbounds": [
{
"mux": {
"concurrency": 8,
"enabled": true
},
"protocol": "socks",
"settings": {
"servers": [
{
"address": "$domain",
"port": 80,
"users": [
{
"level": 0,
"user": "$user",
"pass": "$user"
}
]
}
]
},
"streamSettings": {
"network": "ws",
"security": "none",
"tlsSettings": {
"allowInsecure": true,
"serverName": "$domain"
},
"wsSettings": {
"headers": {
"Host": "$domain"
},
"path": "/wisnu-ws"
}
},
"tag": "proxy"
},
{
"protocol": "freedom",
"settings": {},
"tag": "direct"
},
{
"protocol": "blackhole",
"settings": {
"response": {
"type": "http"
}
},
"tag": "block"
}
],
"policy": {
"levels": {
"8": {
"connIdle": 300,
"downlinkOnly": 1,
"handshake": 4,
"uplinkOnly": 1
}
},
"system": {
"statsOutboundDownlink": true,
"statsOutboundUplink": true
}
},
"routing": {
"domainStrategy": "Asls",
"rules": []
},
"stats": {}
}
EOF
cat > /home/vps/public_html/SOCKS5-WS-NONTLS-$user.txt<<END

cat>/etc/xray/SOCKS5-GRPC-$user.json<<EOF
{
"dns": {
"hosts": {
"domain:googleapis.cn": "googleapis.com"
},
"servers": [
"1.1.1.1"
]
},
"inbounds": [
{
"listen": "127.0.0.1",
"port": "10808",
"protocol": "socks",
"settings": {
"auth": "noauth",
"udp": true,
"userLevel": 8
},
"sniffing": {
"destOverride": [
"http",
"tls"
],
"enabled": true
},
"tag": "socks"
},
{
"listen": "127.0.0.1",
"port": "10809",
"protocol": "http",
"settings": {
"userLevel": 8
},
"tag": "http"
}
],
"log": {
"loglevel": "warning"
},
"outbounds": [
{
"mux": {
"concurrency": 8,
"enabled": true
},
"protocol": "socks",
"settings": {
"servers": [
{
"address": "$domain",
"port": 443,
"users": [
{
"level": 0,
"user": "$user",
"pass": "$user"
}
]
}
]
},
"streamSettings": {
"grpcSettings": {
                         "multiMode": true,
                             "serviceName": "wisnu-grpc"
                               },
"network": "grpc",
"security": "tls",
"tlsSettings": {
"allowInsecure": true,
"serverName": "$domain"
}
},
"tag": "proxy"
},
{
"protocol": "freedom",
"settings": {},
"tag": "direct"
},
{
"protocol": "blackhole",
"settings": {
"response": {
"type": "http"
}
},
"tag": "block"
}
],
"policy": {
"levels": {
"8": {
"connIdle": 300,
"downlinkOnly": 1,
"handshake": 4,
"uplinkOnly": 1
}
},
"system": {
"statsOutboundDownlink": true,
"statsOutboundUplink": true
}
},
"routing": {
"domainStrategy": "Asls",
"rules": []
},
"stats": {}
}
EOF
cat > /home/vps/public_html/SOCKS5-GRPC-$user.txt<<END

tmp1=$(echo -n "${user}:${user}@${domain}:$stls" | base64 -w0)
tmp2=$(echo -n "${user}:${user}@${domain}:$snontls" | base64 -w0)
tmp3=$(echo -n "${user}:${user}@${domain}:$sgrpc" | base64 -w0)
socks1="socks://$tmp1#$user"
socks2="socks://$tmp2#$user"
socks3="socks://$tmp3#$user"

cat /etc/xray/SOCKS5-GRPC-$user.json >> /home/vps/public_html/SOCKS5-GRPC-$user.txt
cat /etc/xray/SOCKS5-WS-TLS-$user.json >> /home/vps/public_html/SOCKS5-WS-TLS-$user.txt
cat /etc/xray/SOCKS5-WS-NONTLS-$user.json >> /home/vps/public_html/SOCKS5-WS-NONTLS-$user.txt
service cron restart

rm -rf /etc/xray/SOCKS5-WS-TLS-$user.json
rm -rf /etc/xray/SOCKS5-WS-NONTLS-$user.json
rm -rf /etc/xray/SOCKS5-GRPC-$user.json

systemctl restart xtrojan
systemctl restart xss
systemctl restart xvmess.service
systemctl restart xray.service

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
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Password : " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/xvmess.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${CLIENT_NAME}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
passwd=$GESuWIqYcq34MSCDTOck0g==
uuid=$(cat /proc/sys/kernel/random/uuid)
base64=$(openssl rand -base64 16)
Username=Password
password=$base64
read -p "Expired (Days) : " masaaktif
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#ss-tcp$/a\### '"$user $exp"'\
},{"password": "'""$base64""'","email": "'""$user""'"' /etc/xray/xss.json
sed -i '/#ss-tcp$/a\### '"$user $exp"'\
},{"password": "'""$base64""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#ss-tls$/a\### '"$user $exp"'\
},{"password": "'""$base64""'","email": "'""$user""'"' /etc/xray/xss.json
sed -i '/#ss-tls$/a\### '"$user $exp"'\
},{"password": "'""$base64""'","email": "'""$user""'"' /etc/xray/xvmess.json
sed -i '/#ss-nontls$/a\### '"$user $exp"'\
},{"password": "'""$base64""'","email": "'""$user""'"' /etc/xray/xss.json
sed -i '/#ss-grpc$/a\### '"$user $exp"'\
},{"password": "'""$base64""'","email": "'""$user""'"' /etc/xray/xss.json
sed -i '/#ss-grpc$/a\### '"$user $exp"'\
},{"password": "'""$base64""'","email": "'""$user""'"' /etc/xray/xvmess.json
cat>/etc/xray/ss-$user-tcp.json<<EOF
{
  "inbounds": [
    {
      "port": 443,
      "protocol": "shadowsocks",
      "settings": {
        "method": "2022-blake3-aes-128-gcm",
        "password": "$passwd:$base64",
        "network": "tcp",
        "port": "$sstcp",
        "security": "tls"
      }
    }
EOF

cat>/etc/xray/SS2022-TCP-TLS-$user.json<<EOF
{
  "dns": {
    "hosts": {
      "domain:googleapis.cn": "googleapis.com"
    },
    "servers": [
      "8.8.8.8"
    ]
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 10808,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "tag": "socks"
    },
    {
      "listen": "127.0.0.1",
      "port": 10809,
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "warning"
  },
  "outbounds": [
    {
      "mux": {
        "concurrency": 8,
        "enabled": true
      },
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "${domain}",
            "level": 8,
            "method": "2022-blake3-aes-128-gcm",
            "ota": false,
            "password": "GESuWIqYcq34MSCDTOck0g==:$base64",
            "port": 443
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": "${domain}"
        }
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "routing": {
    "domainMatcher": "mph",
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "ip": [
          "8.8.8.8"
        ],
        "outboundTag": "proxy",
        "port": "53",
        "type": "field"
      }
    ]
  }
}
EOF
cat /etc/xray/SS2022-TCP-TLS-$user.json >> /home/vps/public_html/SS2022-TCP-TLS-$user.txt


cat>/etc/xray/SS2022-WS-TLS-$user.json<<EOF
{
  "dns": {
    "hosts": {
      "domain:googleapis.cn": "googleapis.com"
    },
    "servers": [
      "8.8.8.8"
    ]
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 10808,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "tag": "socks"
    },
    {
      "listen": "127.0.0.1",
      "port": 10809,
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "warning"
  },
  "outbounds": [
    {
      "mux": {
        "concurrency": 8,
        "enabled": true
      },
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "$domain",
            "level": 8,
            "method": "2022-blake3-aes-128-gcm",
            "ota": false,
            "password": "GESuWIqYcq34MSCDTOck0g==:$base64",
            "port": 443
          }
        ]
      },
        "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": "$domain"
        },
        "wsSettings": {
          "headers": {
            "Host": "$domain"
          },
          "path": "/gandring-ws"
        }
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "routing": {
    "domainMatcher": "mph",
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "ip": [
          "8.8.8.8"
        ],
        "outboundTag": "proxy",
        "port": "53",
        "type": "field"
      }
    ]
  }
}
EOF
cat /etc/xray/SS2022-WS-TLS-$user.json >> /home/vps/public_html/SS2022-WS-TLS-$user.txt

cat>/etc/xray/SS2022-WS-NONTLS-$user.json<<EOF
{
  "dns": {
    "hosts": {
      "domain:googleapis.cn": "googleapis.com"
    },
    "servers": [
      "8.8.8.8"
    ]
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 10808,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "tag": "socks"
    },
    {
      "listen": "127.0.0.1",
      "port": 10809,
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "warning"
  },
  "outbounds": [
    {
      "mux": {
        "concurrency": 8,
        "enabled": true
      },
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "$domain",
            "level": 8,
            "method": "2022-blake3-aes-128-gcm",
            "ota": false,
            "password": "GESuWIqYcq34MSCDTOck0g==:$base64",
            "port": 80
          }
        ]
      },
        "streamSettings": {
        "network": "ws",
        "security": "none",
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": "$domain"
        },
        "wsSettings": {
          "headers": {
            "Host": "$domain"
          },
          "path": "/gandring-ws"
        }
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "routing": {
    "domainMatcher": "mph",
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "ip": [
          "8.8.8.8"
        ],
        "outboundTag": "proxy",
        "port": "53",
        "type": "field"
      }
    ]
  }
}
EOF
cat /etc/xray/SS2022-WS-NONTLS-$user.json >> /home/vps/public_html/SS2022-WS-NONTLS-$user.txt

cat>/etc/xray/SS2022-GRPC-$user.json<<EOF
{
  "dns": {
    "hosts": {
      "domain:googleapis.cn": "googleapis.com"
    },
    "servers": [
      "8.8.8.8"
    ]
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 10808,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "tag": "socks"
    },
    {
      "listen": "127.0.0.1",
      "port": 10809,
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "warning"
  },
  "outbounds": [
    {
      "mux": {
        "concurrency": 8,
        "enabled": false
      },
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "$domain",
            "level": 8,
            "method": "2022-blake3-aes-128-gcm",
            "ota": false,
            "password": "GESuWIqYcq34MSCDTOck0g==:$base64",
            "port": 443
          }
        ]
      },
      "streamSettings": {
        "grpcSettings": {
          "multiMode": true,
          "serviceName": "gandring-grpc"
        },
        "network": "grpc",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": "$domain"
        }
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "routing": {
    "domainMatcher": "mph",
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "ip": [
          "8.8.8.8"
        ],
        "outboundTag": "proxy",
        "port": "53",
        "type": "field"
      }
    ]
  }
}
EOF
cat /etc/xray/SS2022-GRPC-$user.json >> /home/vps/public_html/SS2022-GRPC-$user.txt

tmp1=$(echo -n "2022-blake3-aes-128-gcm:$passwd:$base64@${domain}:$sstcp" | base64 -w0)
tmp2=$(echo -n "2022-blake3-aes-128-gcm:$passwd:$base64@${domain}:$sstls" | base64 -w0)
tmp3=$(echo -n "2022-blake3-aes-128-gcm:$passwd:$base64@${domain}:$ssnontls" | base64 -w0)
tmp4=$(echo -n "2022-blake3-aes-128-gcm:$passwd:$base64@${domain}:$ssgrpc" | base64 -w0)

shadowsocks1="ss://$tmp1#$user"
shadowsocks2="ss://$tmp2#$user"
shadowsocks3="ss://$tmp3#$user"
shadowsocks4="ss://$tmp4#$user"

systemctl restart xvmess
systemctl restart xray.service
systemctl restart xss.service
systemctl restart xtrojan.service

vlessquic="vless://$uuid@$MYIP:$vquic?sni=$domain&key=wisnuquic&security=tls&encryption=none&headerType=none&quicSecurity=$domain&type=quic#%F0%9F%94%B0VLESS+QUIC+TLS+$user"
vlesshttpnon="vless://${uuid}@${domain}:$vlhttpnon?host=${domain}&security=none&type=tcp&headerType=http&encryption=none#%F0%9F%94%B0VLESS+HTTP+NONTLS+${user}"
vlesshttp="vless://${uuid}@${domain}:$vlhttp?sni=${domain}&host=${domain}&type=tcp&security=tls&path=/wisnutcp&headerType=http&encryption=none#%F0%9F%94%B0VLESS+HTTP+TLS+${user}"
vlesstls="vless://${uuid}@${domain}:$vltls?host=${domain}&sni=${domain}&type=ws&security=tls&path=%2fwisnu&encryption=none#%F0%9F%94%B0VLESS+WS+TLS+${user}"
vlessnontls="vless://${uuid}@${domain}:$vlnontls?host=${domain}&security=none&type=ws&path=/wisnu&encryption=none#${user}"
vlessgrpc="vless://${uuid}@${domain}:$vlgrpc?serviceName=wisnugrpc&sni=${domain}&mode=multi&type=grpc&security=tls&encryption=none#%F0%9F%94%B0VLESS+GRPC+TLS+${user}"
vlessgrpcnon="vless://${uuid}@${domain}:$vlgrpcnon?serviceName=/wisnugrpc&sni=${domain}&mode=multi&type=grpc&security=none&encryption=none#${user}"
vlesshdua="vless://${uuid}@${domain}:$vlhdua?type=http&security=tls&path=/wisnuhttp&encryption=none#%F0%9F%94%B0VLESS+H2C+TLS+${user}"
#vlesshduanon="vless://${uuid}@${domain}:$vlhduanon?type=http&security=none&path=/bagus&encryption=none#${user}"
vlessxtls="vless://${uuid}@${domain}:$vlxtls?security=xtls&encryption=none&flow=xtls-rprx-splice-udp443#%F0%9F%94%B0VLESS+XTLS+${user}"
vlessgfw="vless://${uuid}@${domain}:$vlxtls?security=tls&encryption=none#%F0%9F%94%B0VLESS+GFW+TLS+${user}"
trojanxtls="trojan://${uuid}@${domain}:$txtls?security=xtls&type=tcp&headerType=none&flow=xtls-rprx-splice-udp443#%F0%9F%94%B0TROJAN+XTLS+${user}"
trojangfw="trojan://$uuid@$domain:$tgfw?type=tcp&security=tls&headerType=none#%F0%9F%94%B0TROJAN+GFW+TLS+$user"
trojantls="trojan://${uuid}@${domain}:$ttls?type=ws&security=tls&host=$domain&path=%2fgandring&sni=$domain#%F0%9F%94%B0TROJAN+WS+TLS+$user"
trojanhttp="trojan://${uuid}@${domain}:$thttp?sni=${domain}&type=tcp&security=tls&host=$domain&path=/gandringtcp&headerType=http#%F0%9F%94%B0TROJAN+HTTP+TLS+${user}"
trojanhdua="trojan://$uuid@$domain:$thttp?sni=angilangilgamping.com&type=http&security=tls&path=/gandringhttp#%F0%9F%94%B0TROJAN+H2C+TLS+$user"
trojanquic="trojan://$uuid@$MYIP:$tquic?sni=$domain&quicSecurity=$domain&key=gandringquic&security=tls&type=quic&headerType=none#%F0%9F%94%B0TROJAN+QUIC+TLS+$user"
trojangrpc="trojan://$uuid@$domain:$tgrpc?serviceName=gandringgrpc&sni=$domain&mode=gun&security=tls&type=grpc#%F0%9F%94%B0TROJAN+GRPC+TLS+$user"

systemctl restart xvless.service
systemctl restart xray.service
systemctl restart xtrojan.service
systemctl restart xvmess
systemctl restart xss
service cron restart
clear
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m🔰 AKUN AIO PORT TESTER 🔰\e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "IP  :${MYIP} / $domain"
#echo -e "Protokol  :GRPC,HTTP,H2C,GFW,XTLS,WS,QUIC"
echo -e "Protokol   :GRPC,WS"
echo -e "NAMA  :${user}"
echo -e "Port Tls  : 443"
echo -e "Port Non Tls  : 80"
#echo -e "Port SERVICE  :$vlxtls"
#echo -e "Port Trojan grpc  :$tgrpc"
#echo -e "Port Vless grpc  :$vlgrpc"
echo -e "UserID  :${uuid}"
echo -e "Dibuat  :$hariini"
echo -e "Kadaluarsa  :$exp"
echo -e "<><><><><><><><><><><><><><>"
#echo -e "VLESS QUIC: ${vlessquic}"
#echo -e "<><><><><><><><><><><><><><>"
#echo -e "VLESS XTLS: ${vlessxtls}"
#echo -e "<><><><><><><><><><><><><><>"
echo -e "VLESS GRPC TLS: ${vlessgrpc}"
echo -e "<><><><><><><><><><><><><><>"
#echo -e "VLESS GFW TLS: ${vlessgfw}"
#echo -e "<><><><><><><><><><><><><><>"
echo -e "VLESS WS TLS: ${vlesstls}"
#echo -e "<><><><><><><><><><><><><><>"
#echo -e "VLESS H2C TLS: ${vlesshdua}"
#echo -e "<><><><><><><><><><><><><><>"
#echo -e "VLESS HTTP TLS: ${vlesshttp}"
#echo -e "<><><><><><><><><><><><><><>"
#echo -e "TROJAN QUIC TLS: ${trojanquic}"
#echo -e "<><><><><><><><><><><><><><>"
#echo -e "TROJAN GFW TLS: ${trojangfw}"
#echo -e "<><><><><><><><><><><><><><>"
echo -e "TROJAN WS TLS: ${trojantls}"
#echo -e "<><><><><><><><><><><><><><>"
#echo -e "TROJAN HTTP TLS: ${trojanhttp}"
echo -e "<><><><><><><><><><><><><><>"
echo -e "TROJAN GRPC TLS: ${trojangrpc}"
echo -e "<><><><><><><><><><><><><><>"
echo -e "VMESS WS TLS: ${vmess1}"
#echo -e "<><><><><><><><><><><><><><>"
echo -e "VMESS HTTP TLS: ${vmesshttp}"
#echo -e "<><><><><><><><><><><><><><>"
#echo -e "VMESS QUIC TLS: ${vmessquic}"
#echo -e "<><><><><><><><><><><><><><>"
#echo -e "VMESS H2C TLS: ${vmesshdua}"
echo -e "<><><><><><><><><><><><><><>"
echo -e "VMESS GRPC TLS: ${vmessgrpc}"
echo -e "<><><><><><><><><><><><><><>"
echo -e "SS2022 TCP TLS: http://$MYIP:88/SS2022-TCP-TLS-$user.txt"
echo -e "<><><><><><><><><><><><><><>"
echo -e "SS2022 WS TLS: http://$MYIP:88/SS2022-WS-TLS-$user.txt"
echo -e "<><><><><><><><><><><><><><>"
echo -e "SS2022 WS NON TLS: http://$MYIP:88/SS2022-WS-NONTLS-$user.txt"
echo -e "<><><><><><><><><><><><><><>"
echo -e "SS2022 GRPC: http://$MYIP:88/SS2022-GRPC-$user.txt"
echo -e "<><><><><><><><><><><><><><>"
echo -e "SOCKS5 WS TLS: http://$MYIP:88/SOCKS5-WS-TLS-$user.txt"
echo -e "<><><><><><><><><><><><><><>"
echo -e "SOCKS5 WS NON TLS: http://$MYIP:88/SOCKS5-WS-NONTLS-$user.txt"
echo -e "<><><><><><><><><><><><><><>"
echo -e "SOCKS5 GRPC: http://$MYIP:88/SOCKS5-GRPC-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m🔰LUXURY EDITION ZEROSSL🔰\e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
