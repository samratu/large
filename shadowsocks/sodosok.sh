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
pkgs='build-essential autoconf libtool libssl-dev libpcre3-dev libev-dev asciidoc xmlto automake'
if ! dpkg -s $pkgs > /dev/null 2>&1; then
   sleep 1
   echo -e "[ ${green}INFO${NC} ] Common pkgs not installed... "
   sleep 3
   echo -e "[ ${green}INFO${NC} ] Installing common pkgs... "
   apt-get install --no-install-recommends $pkgs -y > /dev/null 2>&1
fi

pkgscommon='software-properties-common'
if ! dpkg -s $pkgscommon > /dev/null 2>&1; then
   apt-get install $pkgscommon -y > /dev/null 2>&1
fi

if [[ $OS == 'ubuntu' ]]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Ubuntu detected... "
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing shadowsocks $OS... "
apt install shadowsocks-libev -y > /dev/null 2>&1
apt install simple-obfs -y > /dev/null 2>&1
elif [[ $OS == 'debian' ]]; then
if [[ "$ver" = "9" ]]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Debian ver 9 detected... "
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing shadowsocks for $OS $ver ... "

if [ -f "/etc/apt/sources.list.d/buster-backports.list" ]; then
detect=( `cat /etc/apt/sources.list.d/buster-backports.list | grep -ow "stretch-backports"` )
if [ "$detect" != "stretch-backports" ]; then
touch /etc/apt/sources.list.d/stretch-backports.list
echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list.d/stretch-backports.list
fi
else
touch /etc/apt/sources.list.d/stretch-backports.list
echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list.d/stretch-backports.list
fi

apt update -y > /dev/null 2>&1
apt -t stretch-backports install shadowsocks-libev -y > /dev/null 2>&1
apt -t stretch-backports install simple-obfs -y > /dev/null 2>&1
elif [[ "$ver" = "10" ]]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Debian ver 10 detected... "
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing shadowsocks for $OS $ver ... "

if [ -f "/etc/apt/sources.list.d/buster-backports.list" ]; then
detect=( `cat /etc/apt/sources.list.d/buster-backports.list | grep -ow "buster-backports"` )
if [ "$detect" != "buster-backports" ]; then
touch /etc/apt/sources.list.d/buster-backports.list
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list.d/buster-backports.list
fi
else
touch /etc/apt/sources.list.d/buster-backports.list
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list.d/buster-backports.list
fi
fi

#Server konfigurasi
sleep 1
echo -e "[ ${green}INFO${NC} ] Creating config shadowsocks..."
cat > /etc/shadowsocks-libev/config.json <<END
{   
    "server":"0.0.0.0",
    "server_port":8488,
    "password":"tes",
    "timeout":60,
    "method":"aes-128-gcm",
    "fast_open":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
}
END

#mulai ~shadowsocks-libev~ server
sleep 1
echo -e "[ ${green}INFO${NC} ] Enable service on boot..."
systemctl enable shadowsocks-libev.service > /dev/null 2>&1
sleep 1
echo -e "[ ${green}INFO${NC} ] Start service shadowsocks..."
systemctl start shadowsocks-libev.service > /dev/null 2>&1

#buat client config
cat > /etc/shadowsocks-libev.json <<END
{
    "server":"127.0.0.1",
    "server_port":8388,
    "local_port":1080,
    "password":"",
    "timeout":60,
    "method":"aes-128-gcm",
    "mode":"tcp_and_udp",
    "fast_open":true,
    "plugin":"/usr/bin/obfs-local",
    "plugin_opts":"obfs=tls;failover=127.0.0.1:443;fast-open"
}
END
chmod +x /etc/shadowsocks-libev.json

echo -e "">>"/etc/shadowsocks-libev/akun.conf"
sleep 1
echo -e "[ ${green}INFO${NC} ] Set iptables..."
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2444:3442 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2444:3442 -j ACCEPT
sudo iptables-save > /etc/iptables.up.rules
sudo ip6tables-save > /etc/ip6tables.up.rules
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
