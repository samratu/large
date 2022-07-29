#!/bin/bash
#shadowsocks-libev obfs install by wisnu cokro satrio
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
# Link Hosting Kalian
wisnuvpn="raw.githubusercontent.com/samratu/large/sae/shadowsocks"
source /etc/os-release
OS=$ID
ver=$VERSION_ID
#Install_Packages
echo "Install Paket..."
apt-get install --no-install-recommends build-essential autoconf libtool libssl-dev libpcre3-dev libev-dev asciidoc xmlto automake -y
echo "Install Paket Selesai BUILD UP BY WISNU COKRO SATRIO"
#Install_Shadowsocks_libev
echo "Installing Shadowsocks-libev BY WISNU COKRO SATRIO"
apt update -y
apt-get install software-properties-common -y
if [[ $OS == 'ubuntu' ]]; then
apt install shadowsocks-libev -y
apt install simple-obfs -y
elif [[ $OS == 'debian' ]]; then
if [[ "$ver" = "9" ]]; then
echo "deb http://deb.debian.org/debian stretch-backports main" | tee /etc/apt/sources.list.d/stretch-backports.list
apt update -y
apt -t stretch-backports install shadowsocks-libev -y
apt -t stretch-backports install simple-obfs -y
elif [[ $OS == 'debian' ]]; then
if [[ "$ver" = "10" ]]; then
echo "deb http://deb.debian.org/debian buster-backports main" | tee /etc/apt/sources.list.d/buster-backports.list
apt update
apt -t buster-backports install shadowsocks-libev -y
apt -t buster-backports install simple-obfs -y
elif [[ $OS == 'debian' ]]; then
if [[ "$ver" = "11" ]]; then
echo "deb http://deb.debian.org/debian bullseye-backports main" | tee /etc/apt/sources.list.d/bullseye-backports.list
apt update
apt -t bullseye-backports install shadowsocks-libev -y
apt -t bullseye-backports install simple-obfs -y
fi
echo "Install Shadowsocks-libev Selesai"
#Server konfigurasi
echo "Konfigurasi Server."
cat > /etc/shadowsocks-libev/config.json <<END
{   
    "server":"0.0.0.0",
    "server_port":8488,
    "password":"tes",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "nameserver":"1.1.1.1",
    "mode":"tcp_and_udp",
}
END
#mulai ~shadowsocks-libev~ server
echo "mulai ss server"
systemctl enable shadowsocks-libev.service
systemctl start shadowsocks-libev.service
#buat client config
echo "buat config obfs"
cat > /etc/shadowsocks-libev.json <<END
{
    "server":"127.0.0.1",
    "server_port":8388,
    "local_port":1080,
    "password":"",
    "timeout":60,
    "method":"chacha20-ietf-poly1305",
    "mode":"tcp_and_udp",
    "fast_open":true,
    "plugin":"/usr/bin/obfs-local",
    "plugin_opts":"obfs=tls;failover=127.0.0.1:1443;fast-open"
}
END
chmod +x /etc/shadowsocks-libev.json
echo -e "">>"/etc/shadowsocks-libev/akun.conf"
echo "Menambahkan Perintah Shadowsocks-libev"
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2444:3442 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2444:3442 -j ACCEPT
iptables-save > /etc/iptables.up.rules
ip6tables-save > /etc/ip6tables.up.rules
cd /usr/bin
wget -O addss "https://${wisnuvpn}/addss.sh"
wget -O delss "https://${wisnuvpn}/delss.sh"
wget -O cekss "https://${wisnuvpn}/cekss.sh"
wget -O renewss "https://${wisnuvpn}/renewss.sh"
chmod +x addss
chmod +x delss
chmod +x cekss
chmod +x renewss
cd
rm -f /root/sodosok.sh
