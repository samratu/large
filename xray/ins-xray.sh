#!/bin/bash
# @ Copyrigt 2017 By zerossl
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'

MYIP=$(wget -qO- ipinfo.io/ip);
clear
domain=$(cat /root/domain)
apt install iptables iptables-persistent -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
apt install chronyd -y
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
chronyc sourcestats -v
chronyc tracking -v
date

# / / Ambil Xray Core Version Terbaru
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
#bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install-geodata
# / / Installation Xray Core
xraycore_link="https://github.com/XTLS/Xray-core/releases/download/v$latest_version/xray-linux-64.zip"
#xraycore_link="https://raw.githubusercontent.com/samratu/large/file/Xray-linux-64.zip"
# / / Make Main Directory
mkdir -p /usr/bin/xray
mkdir -p /etc/xray

# / / Unzip Xray Linux 64
cd `mktemp -d`
curl -sL "$xraycore_link" -o xray.zip
unzip -q xray.zip && rm -rf xray.zip
mv xray /usr/local/bin/xray
chmod +x /usr/local/bin/xray
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install-geodata
# Make Folder XRay
mkdir -p /var/log/xray/
uuid=$(cat /proc/sys/kernel/random/uuid)
#bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root
cd /root/
#wget https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
mkdir -p /usr/local/etc/xray
sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill
##Generate acme certificate
curl https://get.acme.sh | sh
alias acme.sh=~/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
#/root/.acme.sh/acme.sh --issue -d "${domain}" --standalone --keylength ec-2048
/root/.acme.sh/acme.sh --issue -d "${domain}" --standalone --keylength ec-384
/root/.acme.sh/acme.sh --install-cert -d "${domain}" --ecc \
--fullchain-file /etc/ssl/private/fullchain.pem \
--key-file /etc/ssl/private/privkey.pem
chown -R nobody:nogroup /etc/xray
chmod 644 /etc/ssl/private/privkey.pem
chmod 644 /etc/ssl/private/fullchain.pem

#sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill
cd /root/
#wget https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
#bash acme.sh --install
#bash acme.sh --register-account -m inoyaksorojawi@gmail.com
#bash acme.sh --issue --standalone -d $domain --force
#bash acme.sh --installcert -d $domain --fullchainpath /etc/ssl/private/fullchain.pem --keypath /etc/ssl/private/privkey.pem
#chown -R nobody:nogroup /etc/xray
#chmod 644 /etc/ssl/private/privkey.pem
#chmod 644 /etc/ssl/private/fullchain.pem

#curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
#chmod +x /root/.acme.sh/acme.sh
#/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
#~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/ssl/private/fullchain.pem --keypath /etc/ssl/private/privkey.pem --ecc

uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /root/domain)
# // Certificate File
path_crt="/etc/xray/xray.crt"
path_key="/etc/xray/xray.key"
#domain_ecc=$(cat /root/.acme.sh)
#domain.key=$(cat /root/.acme.sh/$domain_ecc)
#path_crt="/root/.acme.sh/$domain_ecc/fullchain.cer"
#path_key="/root/.acme.sh/$domain_ecc/$domain.key"
# Buat Config Xray
cat > /etc/xray/config.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"

          
        
  
   
END

uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /root/domain)
# // Certificate File
path_crt="/etc/xray/xray.crt"
path_key="/etc/xray/xray.key"
#domain_ecc=$(cat /root/.acme.sh)
#domain.key=$(cat /root/.acme.sh/$domain_ecc)
#path_crt="/root/.acme.sh/$domain_ecc/fullchain.cer"
#path_key="/root/.acme.sh/$domain_ecc/$domain.key"
# Buat Config Xray
cat > /etc/xray/xvless.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    
}
END

uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /root/domain)
# // Certificate File
path_crt="/etc/xray/xray.crt"
path_key="/etc/xray/xray.key"
#domain_ecc=$(cat /root/.acme.sh)
#domain.key=$(cat /root/.acme.sh/$domain_ecc)
#path_crt="/root/.acme.sh/$domain_ecc/fullchain.cer"
#path_key="/root/.acme.sh/$domain_ecc/$domain.key"
# Buat Config Xray
cat > /etc/xray/xtrojan.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  s
           }
        
END

uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /root/domain)
# // Certificate File
path_crt="/etc/xray/xray.crt"
path_key="/etc/xray/xray.key"
#domain_ecc=$(cat /root/.acme.sh)
#domain.key=$(cat /root/.acme.sh/$domain_ecc)
#path_crt="/root/.acme.sh/$domain_ecc/fullchain.cer"
#path_key="/root/.acme.sh/$domain_ecc/$domain.key"
# Buat Config Xray
cat > /etc/xray/trojangrpc.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    : true,
      "statsOutboundDownlink" : true
    }
  }
}
END

uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /root/domain)
# // Certificate File
path_crt="/etc/xray/xray.crt"
path_key="/etc/xray/xray.key"
#domain_ecc=$(cat /root/.acme.sh)
#domain.key=$(cat /root/.acme.sh/$domain_ecc)
#path_crt="/root/.acme.sh/$domain_ecc/fullchain.cer"
#path_key="/root/.acme.sh/$domain_ecc/$domain.key"
# Buat Config Xray
cat > /usr/local/etc/xray/xvmess.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    
         
        
          
END

uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /root/domain)
# // Certificate File
path_crt="/etc/xray/xray.crt"
path_key="/etc/xray/xray.key"
#domain_ecc=$(cat /root/.acme.sh)
#domain.key=$(cat /root/.acme.sh/$domain_ecc)
#path_crt="/root/.acme.sh/$domain_ecc/fullchain.cer"
#path_key="/root/.acme.sh/$domain_ecc/$domain.key"
# Buat Config Xray
cat > /usr/local/etc/xray/vlessquic.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    

END

uuid=$(cat /proc/sys/kernel/random/uuid)

domain=$(cat /root/domain)
# // Certificate File
path_crt="/etc/xray/xray.crt"
path_key="/etc/xray/xray.key"
#domain_ecc=$(cat /root/.acme.sh)
#domain.key=$(cat /root/.acme.sh/$domain_ecc)
#path_crt="/root/.acme.sh/$domain_ecc/fullchain.cer"
#path_key="/root/.acme.sh/$domain_ecc/$domain.key"
# Buat Config Xray
cat > /etc/xray/xss.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
    
END

uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /root/domain)
# // Certificate File
path_crt="/etc/xray/xray.crt"
path_key="/etc/xray/xray.key"
#domain_ecc=$(cat /root/.acme.sh)
#domain.key=$(cat /root/.acme.sh/$domain_ecc)
#path_crt="/root/.acme.sh/$domain_ecc/fullchain.cer"
#path_key="/root/.acme.sh/$domain_ecc/$domain.key"
# Buat Config Xray
cat > /etc/xray/sstcp.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
    
END

# / / Installation Xray Service
cat > /etc/systemd/system/xray.service << END
[Unit]
Description=XRAY ROUTING DAM COLO PENGKOL BY ZEROSSL
Documentation=https://t.me/zerossl
After=network.target nss-lookup.target

[Service]
User=root
Type=simple
StandardError=journal
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/config.json
LimitNOFILE=65535
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
END

# / / Installation Xray Service
cat > /etc/systemd/system/xtrojan.service << END
[Unit]
Description=XTROJAN ROUTING DAM COLO PENGKOL BY ZEROSSL
Documentation=https://t.me/zerossl
After=network.target nss-lookup.target

[Service]
User=root
Type=simple
StandardError=journal
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/xtrojan.json
LimitNOFILE=65535
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target

END

# / / Installation Xray Service
cat > /etc/systemd/system/xvless.service << END
[Unit]
Description=XVLESS ROUTING DAM COLO PENGKOL BY SHANUM
Documentation=https://t.me/zerossl
After=network.target nss-lookup.target

[Service]
User=root
Type=simple
StandardError=journal
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/xvless.json
LimitNOFILE=65535
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target

END

cat > /etc/systemd/system/xvmess.service << END
[Unit]
Description=XVMESS ROUTING GAJAH DEMAK BY GANDRING
Documentation=https://t.me/zerossl
After=network.target nss-lookup.target

[Service]
User=root
Type=simple
StandardError=journal
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /usr/local/etc/xray/xvmess.json
LimitNOFILE=65535
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target

END

# / / Installation Xray Service
cat > /etc/systemd/system/xss.service << END
[Unit]
Description=XSHADOWSOCKS ROUTING DAM COLO PENGKOL BY WISNU
Documentation=https://t.me/zerossl
After=network.target nss-lookup.target

[Service]
User=root
Type=simple
StandardError=journal
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/xss.json
LimitNOFILE=65535
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target

END

# / / Installation Xray Service
cat > /etc/systemd/system/sstcp.service << END
[Unit]
Description=XSHADOWSOCKS ROUTING DAM COLO PENGKOL BY WISNU
Documentation=https://t.me/zerossl
After=network.target nss-lookup.target

[Service]
User=root
Type=simple
StandardError=journal
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/sstcp.json
LimitNOFILE=65535
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target

END

# / / Installation Xray Service
cat > /etc/systemd/system/trojangrpc.service << END
[Unit]
Description=XTROJAN ROUTING DAM COLO PENGKOL BY zerossl
Documentation=https://t.me/zerossl
After=network.target nss-lookup.target

[Service]
User=root
Type=simple
StandardError=journal
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/trojangrpc.json
LimitNOFILE=65535
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target

END

# / / Installation Xray Service
cat > /etc/systemd/system/vlessquic.service << END
[Unit]
Description=XVLESS ROUTING DAM COLO PENGKOL BY zerossl
Documentation=https://t.me/zerossl
After=network.target nss-lookup.target

[Service]
User=root
Type=simple
StandardError=journal
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /usr/local/etc/xray/vlessquic.json
LimitNOFILE=65535
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target

END

# // Enable & Start Service
# Accept port Xray

sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 8443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2053 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2052 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2052 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 8088 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8088 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2053 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8880 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 8880 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 80 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2083 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2083 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2096 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2095 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2095 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2096 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 808 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 808 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8808 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 8808 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 111 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 111 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 333 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 333 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 880 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 880 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 888 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 888 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 808 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 808 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 4443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 4443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8888 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 8888 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 5443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 5443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 3443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 3443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 888 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 888 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 3443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 3443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 3444 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 3444 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2082 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2082 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2087 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2087 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 8080 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 441 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 441 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 442 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 442 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 212 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 212 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 501 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 501 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 502 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 502 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 503 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 503 -j ACCEPT

iptables -A OUTPUT -p tcp --sport 10809 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp --sport 10809 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 10808 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp --sport 10808 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
systemctl daemon-reload
systemctl stop xray
systemctl enable xray
systemctl start xray
systemctl restart xray

##restart&start service
systemctl daemon-reload
systemctl enable xtrojan
systemctl stop xtrojan
systemctl start xtrojan
systemctl restart xtrojan

##restart&start service
systemctl daemon-reload
systemctl enable xvless
systemctl stop xvless
systemctl start xvless
systemctl restart xvless

##restart&start service
systemctl daemon-reload
systemctl enable xss
systemctl stop xss
systemctl start xss
systemctl restart xss

##restart&start service
systemctl daemon-reload
systemctl enable sstcp
systemctl stop sstcp
systemctl start sstcp
systemctl restart sstcp

##restart&start service
systemctl daemon-reload
systemctl enable xvmess
systemctl stop xvmess
systemctl start xvmess
systemctl restart xvmess

##restart&start service
systemctl daemon-reload
systemctl enable trojangrpc
systemctl stop trojangrpc
systemctl start trojangrpc
systemctl restart trojangrpc

##restart&start service
systemctl daemon-reload
systemctl enable vlessquic
systemctl stop vlessquic
systemctl start vlessquic
systemctl restart vlessquic

# Install Trojan Go
latest_version="$(curl -s "https://api.github.com/repos/p4gefau1t/trojan-go/releases" | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
trojango_link="https://github.com/p4gefau1t/trojan-go/releases/download/v${latest_version}/trojan-go-linux-amd64.zip"
mkdir -p "/usr/bin/trojan-go"
mkdir -p "/etc/trojan-go"
cd `mktemp -d`
curl -sL "${trojango_link}" -o trojan-go.zip
unzip -q trojan-go.zip && rm -rf trojan-go.zip
mv trojan-go /usr/local/bin/trojan-go
chmod +x /usr/local/bin/trojan-go
mkdir /var/log/trojan-go/
touch /etc/trojan-go/akun.conf
touch /var/log/trojan-go/trojan-go.log

# Buat Config Trojan Go
cat > /etc/trojan-go/config.json << END
{
  "run_type": "server",
  "local_addr": "0.0.0.0",
  "local_port": 2053,
  "remote_addr": "127.0.0.1",
  "remote_port": 88,
  "log_level": 1,
  "log_file": "/var/log/trojan-go/trojan-go.log",
  "password": [
      "$uuid"
  ],
  "disable_http_check": true,
  "udp_timeout": 60,
  "ssl": {
    "verify": false,
    "verify_hostname": false,
    "cert": "/etc/ssl/private/fullchain.pem",
    "key": "/etc/ssl/private/privkey.pem",
    "key_password": "",
    "cipher": "",
    "curves": "",
    "prefer_server_cipher": false,
    "sni": "$domain",
    "alpn": [
      "http/1.1"
    ],
    "session_ticket": true,
    "reuse_session": true,
    "plain_http_response": "",
    "fallback_addr": "127.0.0.1",
    "fallback_port": 2053,
    "fingerprint": "firefox"
  },
  "tcp": {
    "no_delay": true,
    "keep_alive": true,
    "prefer_ipv4": true
  },
  "mux": {
    "enabled": false,
    "concurrency": 8,
    "idle_timeout": 60
  },
  "websocket": {
    "enabled": true,
    "path": "/gandring",
    "host": "$domain"
  },
    "api": {
    "enabled": false,
    "api_addr": "",
    "api_port": 0,
    "ssl": {
      "enabled": false,
      "key": "",
      "cert": "",
      "verify_client": false,
      "client_cert": []
    }
  }
}
END

# Installing Trojan Go Service
cat > /etc/systemd/system/trojan-go.service << END
[Unit]
Description=Trojan-Go Service Mod By wisnu
Documentation=https://t.me/zerossl
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/trojan-go -config /etc/trojan-go/config.json
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
END

# Trojan Go Uuid
cat > /etc/trojan-go/uuid.txt << END
$uuid
END

# restart
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2053 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2053 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
systemctl daemon-reload
systemctl stop trojan-go
systemctl start trojan-go
systemctl enable trojan-go
systemctl restart trojan-go
cd
cp /root/domain /etc/xray
cp /root/domain /usr/local/etc/xray
cp /root/.acme.sh/$domain_ecc/fullcain.cer /etc/stunnel/stunnel.pem
cp /root/.acme.sh/$domain_ecc/$domain.key /etc/stunnel/stunnel.pem
cp /etc/ssl/private/fullchain.pem //etc/xray/xray.crt
cp /etc/ssl/private/privkey.pem //etc/xray/xray.key
