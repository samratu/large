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
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
chronyc sourcestats -v
chronyc tracking -v
date

# / / Ambil Xray Core Version Terbaru
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"

# / / Installation Xray Core
xraycore_link="https://github.com/XTLS/Xray-core/releases/download/v$latest_version/xray-linux-64.zip"

# / / Make Main Directory
mkdir -p /usr/bin/xray
mkdir -p /etc/xray
mkdir -p /etc/ssl/private
mkdir -p /usr/local/etc/xray
# / / Unzip Xray Linux 64
cd `mktemp -d`
curl -sL "$xraycore_link" -o xray.zip
unzip -q xray.zip && rm -rf xray.zip
mv xray /usr/local/bin/xray
chmod +x /usr/local/bin/xray

# Make Folder XRay
mkdir -p /var/log/xray/
uuid=$(cat /proc/sys/kernel/random/uuid)
#bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root
cd /root/
#wget https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
##Generate acme certificate
curl https://get.acme.sh | sh
alias acme.sh=~/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
#/root/.acme.sh/acme.sh --issue -d "${domain}" --standalone --keylength ec-2048
/root/.acme.sh/acme.sh --issue -d "${domain}" --standalone --keylength ec-256
/root/.acme.sh/acme.sh --install-cert -d "${domain}" --ecc \
--fullchain-file /etc/ssl/private/fullchain.pem \
--key-file /etc/ssl/private/privkey.pem
chown -R nobody:nogroup /etc/xray
chown -R nobody:nogroup /etc/ssl/private
chmod 644 /etc/ssl/private/fullchain.pem
chmod 644 /etc/ssl/private/privkey.pem


#sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill
#cd /root/
#wget https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
#bash acme.sh --install
#bash acme.sh --register-account -m djarumpentol01@gmail.com
#bash acme.sh --issue --standalone -d $domain --force
#bash acme.sh --installcert -d $domain --fullchainpath /etc/ssl/private/fullchain.pem --keypath /etc/ssl/private/privkey.pem
#chown -R nobody:nogroup /etc/xray
#chmod 644 /etc/ssl/private/privkey.pem
#chmod 644 /etc/ssl/private/fullchain.pem

#cd /root/
#wget https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
#bash acme.sh --install
#bash acme.sh --register-account -m inoyaksorojawi@gmail.com
#bash acme.sh --issue --standalone -d $domain --force
#bash acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key

#curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
#chmod +x /root/.acme.sh/acme.sh
#/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
#~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install-geodata
uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /root/domain)

# Check OS version
if [[ -e /etc/debian_version ]]; then
	source /etc/os-release
	OS=$ID # debian or ubuntu
elif [[ -e /etc/centos-release ]]; then
	source /etc/os-release
	OS=centos
fi
if [[ $OS == 'ubuntu' ]]; then
		sudo add-apt-repository ppa:ondrej/nginx -y
		apt update ; apt upgrade -y
		sudo apt install nginx -y
		sudo apt install python3-certbot-nginx -y
		systemctl daemon-reload
        systemctl enable nginx
elif [[ $OS == 'debian' ]]; then
		sudo apt install gnupg2 ca-certificates lsb-release -y 
        echo "deb http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list 
        echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx 
        curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key 
        # gpg --dry-run --quiet --import --import-options import-show /tmp/nginx_signing.key
        sudo mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc
        sudo apt update
        systemctl daemon-reload
        systemctl enable nginx
fi
rm -f /etc/nginx/conf.d/default.conf 
clear
echo "
server {
    listen 80 ;
    listen [::]:80 ;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    location /shanumgrpc 
       {
       client_max_body_size 0;
       keepalive_time 1071906480m;
       keepalive_requests 4294967296;
       client_body_timeout 1071906480m;
       send_timeout 1071906480m;
       lingering_close always;
       grpc_read_timeout 1071906480m;
       grpc_send_timeout 1071906480m;
       grpc_pass grpc://127.0.0.1:1190;
       }
    location /wisnugrpc 
       {
       client_max_body_size 0;
       keepalive_time 1071906480m;
       keepalive_requests 4294967296;
       client_body_timeout 1071906480m;
       send_timeout 1071906480m;
       lingering_close always;
       grpc_read_timeout 1071906480m;
       grpc_send_timeout 1071906480m;
       grpc_pass grpc://127.0.0.1:1160;
       }
    location /gandringgrpc 
       {
       client_max_body_size 0;
       keepalive_time 1071906480m;
       keepalive_requests 4294967296;
       client_body_timeout 1071906480m;
       send_timeout 1071906480m;
       lingering_close always;
       grpc_read_timeout 1071906480m;
       grpc_send_timeout 1071906480m;
       grpc_pass grpc://127.0.0.1:1130;
       }
}
" > /etc/nginx/conf.d/default.conf
# // Certificate File
path_crt="/etc/xray/xray.cer"
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
  },
  "inbounds": [
    {
      "port": 8808,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 0
#vmess-http-tls
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.cer",
              "keyFile": "/etc/xray/xray.key"
            }
          ]
        },
        "httpSettings": {},
        "tcpSettings": {
          "header": {
            "type": "http",
            "request": {
              "version": "1.1",
              "method": "GET",
              "path": [
                "/"
              ],
              "headers": {
                "Host": "${domain}",
                "User-Agent": [
                  "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36",
                  "Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_2 like Mac OS X) AppleWebKit/601.1 (KHTML, like Gecko) CriOS/53.0.2785.109 Mobile/14A456 Safari/601.1.46"
                ],
                "Accept-Encoding": [
                  "gzip, deflate"
                ],
                "Connection": [
                  "keep-alive"
                ],
                "Pragma": "no-cache"
              }
            },
            "response": {
              "version": "1.1",
              "status": "200",
              "reason": "OK",
              "headers": {
                "Content-Type": [
                  "application/octet-stream",
                  "video/mpeg"
                ],
                "Transfer-Encoding": [
                  "chunked"
                ],
                "Connection": [
                  "keep-alive"
                ],
                "Pragma": "no-cache"
              }
            }
          }
        },
        "kcpSettings": {},
        "wsSettings": {},
        "quicSettings": {}
      },
      "domain": "${domain}",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "port": 44443,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-direct"
#vless-xtls
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": 88
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "tcpSettings": {},
        "kcpSettings": {},
        "wsSettings": {},
        "httpSettings": {},
        "quicSettings": {},
        "grpcSettings": {},
        "xtlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.cer",
              "keyFile": "/etc/xray/xray.key"
            }
          ],
          "alpn": [
            "http/1.1"
          ]
        }
      },
      "domain": "${domain}",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "port": 808,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 0
#vmess-http-nontls
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "none",
        "tlsSettings": {},
        "httpSettings": {},
        "tcpSettings": {
          "header": {
            "type": "http",
            "request": {
              "version": "1.1",
              "method": "GET",
              "path": [
                "/"
              ],
              "headers": {
                "Host": "${domain}",
                "User-Agent": [
                  "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36",
                  "Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_2 like Mac OS X) AppleWebKit/601.1 (KHTML, like Gecko) CriOS/53.0.2785.109 Mobile/14A456 Safari/601.1.46"
                ],
                "Accept-Encoding": [
                  "gzip, deflate"
                ],
                "Connection": [
                  "keep-alive"
                ],
                "Pragma": "no-cache"
              }
            },
            "response": {
              "version": "1.1",
              "status": "200",
              "reason": "OK",
              "headers": {
                "Content-Type": [
                  "application/octet-stream",
                  "video/mpeg"
                ],
                "Transfer-Encoding": [
                  "chunked"
                ],
                "Connection": [
                  "keep-alive"
                ],
                "Pragma": "no-cache"
              }
            }
          }
        },
        "kcpSettings": {},
        "wsSettings": {},
        "quicSettings": {}
      }
    },
    {
      "port": 2053,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 0
#vmess-tls
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.cer",
              "keyFile": "/etc/xray/xray.key"
            }
          ]
        },
        "tcpSettings": {},
        "kcpSettings": {},
        "httpSettings": {},
        "wsSettings": {
          "path": "gandring",
          "headers": {
            "Host": "${domain}"
          }
        },
        "quicSettings": {}
      },
      "domain": "${domain}"
    },
    {
      "port": 2053,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 0
#vmess-nontls
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "tlsSettings": {},
        "tcpSettings": {},
        "kcpSettings": {},
        "httpSettings": {},
        "wsSettings": {
          "path": "gandring",
          "headers": {
            "Host": "${domain}"
          }
        },
        "quicSettings": {}
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "port": 8088,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 0
#vmess-hdua
          }
        ]
      },
      "streamSettings": {
        "network": "h2",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.cer",
              "keyFile": "/etc/xray/xray.key"
            }
          ]
        },
        "tcpSettings": {},
        "httpSettings": {
          "path": "gandring"
        },
        "kcpSettings": {},
        "wsSettings": {},
        "quicSettings": {}
      },
      "domain": "${domain}",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "port": 20530,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 0
#vmess-grpc-tls
          }
        ]
      },
      "streamSettings": {
        "network": "grpc",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.cer",
              "keyFile": "/etc/xray/xray.key"
            }
          ],
          "alpn": [
            "http/1.1"
          ]
        },
        "tcpSettings": {},
        "kcpSettings": {},
        "wsSettings": {},
        "httpSettings": {},
        "quicSettings": {},
        "grpcSettings": {
          "serviceName": "gandring",
          "multiMode": true
        } 
      },
      "domain": "${domain}",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "port": 2052,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 0
#vmess-grpc-nontls
          }
        ]
      },
      "streamSettings": {
        "network": "grpc",
        "security": "none",
        "tlsSettings": {},
        "tcpSettings": {},
        "kcpSettings": {},
        "wsSettings": {},
        "httpSettings": {},
        "quicSettings": {},
        "grpcSettings": {
          "serviceName": "gandring",
          "multiMode": true
        }
      }
    },
    {
      "port": 2083,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
#vless-tls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.cer",
              "keyFile": "/etc/xray/xray.key"
            }
          ],
          "alpn": [
            "http/1.1"
          ]
        },
        "tcpSettings": {},
        "kcpSettings": {},
        "httpSettings": {},
        "wsSettings": {
          "path": "gandring",
          "headers": {
            "Host": "${domain}"
          }
        },
        "quicSettings": {}
      },
      "domain": "${domain}",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "port": 2083,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
#vless-nontls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "tlsSettings": {},
        "tcpSettings": {},
        "kcpSettings": {},
        "httpSettings": {},
        "wsSettings": {
          "path": "gandring",
          "headers": {
            "Host": "${domain}"
          }
        },
        "quicSettings": {}
      }
    },
    {
      "port": 2082,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
#vless-grpc-tls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "grpc",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.cer",
              "keyFile": "/etc/xray/xray.key"
            }
          ],
          "alpn": [
            "http/1.1"
          ]
        },
        "tcpSettings": {},
        "kcpSettings": {},
        "wsSettings": {},
        "httpSettings": {},
        "quicSettings": {},
        "grpcSettings": {
          "serviceName": "gandring"
        }
      },
      "domain": "${domain}",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "port": 2082,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
#vless-grpc-nontls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "grpc",
        "security": "none",
        "tlsSettings": {},
        "tcpSettings": {},
        "kcpSettings": {},
        "wsSettings": {},
        "httpSettings": {},
        "quicSettings": {},
        "grpcSettings": {
          "serviceName": "gandring"
        }
      }
    },
    {
      "port": 333,
      "protocol": "shadowsocks",
      "settings": {
        "method": "chacha20-poly1305",
        "password": "gandring",
#xray-ss
        "network": "tcp,udp"
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "tag": "K",
      "port": 111,
      "protocol": "mtproto",
      "settings": {
        "users": [
          {
            "secret": "abdff3490fe6bb16fbd57f4f45d7215a"
#xray-mtproto
          }
        ]
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "port": 777,
      "protocol": "socks",
      "settings": {
        "auth": "password",
        "accounts": [
          {
            "user": "gandring",
            "pass": "g"
#xray-socks
          }
        ],
        "udp": true
      },
      "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.cer",
              "keyFile": "/etc/xray/xray.key"
            }
          ]
        },
        "tcpSettings": {},
        "kcpSettings": {},
        "wsSettings": {},
        "httpSettings": {},
        "quicSettings": {},
        "grpcSettings": {}
      },
      "domain": "${domain}"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    },
    {
      "tag": "tg-out",
      "protocol": "mtproto",
      "settings": {}
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true
    }
  }
}
END

uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /root/domain)
# // Certificate File
path_crt="/etc/xray/xray.cer"
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
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": 4443,
      "protocol": "trojan",
      "tag": "TROJAN-xtls-in",
      "settings": {
        "clients": [
          {
            "password": "gandring",
            "flow": "xtls-rprx-direct",
            "email": "gandring@p0x.smule.my.id",
            "level": 0
#trojan-xtls
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": 443,
            "xver": 1
          },
          {
            "path": "/gandring",
            "dest": 2096,
            "xver": 1
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlsSettings": {
          "alpn": [
            "h2",
            "http/1.1"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.cer",
              "keyFile": "/etc/xray/xray.key"
            }
          ]
        }
      }
    },
    {
      "port": 8443,
      "listen": "0.0.0.0",
      "protocol": "trojan",
      "tag": "TROJAN-gRPC-in",
      "settings": {
        "clients": [
          {
            "password": "gandring",
            "email": "gandring@p0x.smule.my.id"
#trojan-grpc
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "grpc",
        "security": "tls",
        "tlsSettings": {
          "serverName": "",
          "alpn": [
            "h2",
            "http/1.1"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.cer",
              "keyFile": "/etc/xray/xray.key"
            }
          ]
        },
        "grpcSettings": {
          "serviceName": "gandring"
        }
      }
    },
    {
      "port": 20878,
      "listen": "0.0.0.0",
      "protocol": "trojan",
      "tag": "TROJAN-WSTLS-in",
      "settings": {
        "clients": [
          {
            "password": "gandring",
            "email": "gandring@p0x.smule.my.id"
#trojan-tls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "wsSettings": {
          "path": "gandring"
         },
         "tlsSettings": {
          "alpn": [
            "h2",
            "http/1.1"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.cer",
              "keyFile": "/etc/xray/xray.key"
            }
          ]
        }
      }
    },
    {
      "port": 2095,
      "listen": "0.0.0.0",
      "protocol": "trojan",
      "tag": "TROJAN-WS-in",
      "settings": {
        "clients": [
          {
            "password": "gandring",
            "email": "gandring@p0x.smule.my.id"
#trojan-nontls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/gandring"
        }
      }
    },
    {
      "port": 1120,
      "listen": "0.0.0.0",
      "protocol": "trojan",
      "tag": "TROJAN-HTTP/2-in",
      "settings": {
        "clients": [
          {
            "password": "gandring",
            "email": "gandring@p0x.smule.my.id"
#trojan-hdua
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "h2",
        "security": "tls",
        "httpSettings": {
          "path": "gandring"
         },
         "tlsSettings": {
          "alpn": [
            "h2",
            "http/1.1"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.cer",
              "keyFile": "/etc/xray/xray.key"
            }
          ]
        }
      }
    },
    {
      "port": 880,
      "listen": "0.0.0.0",
      "protocol": "trojan",
      "tag": "TROJAN-HTTP-in",
      "settings": {
        "clients": [
          {
            "password": "gandring",
            "email": "gandring@p0x.smule.my.id"
#trojan-http
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "none",
        "tcpSettings": {
         "header": {
          "type": "http",
           "response": {
            "version": "1.1",
             "status": "200",
             "reason": "OK",
             "headers": {}
            }
          }
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "tag": "blocked"
    }
  ],
  "dns": {
    "servers": [
      "1.1.1.1",
      "1.0.0.1",
      "localhost",
      "https+local://1.1.1.1/dns-query"
    ]
  },
  "routing":{
        "domainStrategy": "AsIs",
        "rules": [
          {
            "type": "field",
            "outboundTag": "blackhole-out",
            "protocol": [ "bittorrent" ]
          }
      ]
   }
}
END

uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /root/domain)
# // Certificate File
path_crt="/etc/xray/xray.cer"
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
        {
            "port": 2053,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}",
                        "alterid": 0
#vmess-grpc-tls
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "grpc",
                "security": "tls",
                "tlsSettings": {
                    "serverName": "${domain}",
                    "alpn": [
                        "http/1.1",
                        "h2"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/etc/xray/xray.cer",
                            "keyFile": "/etc/xray/xray.key"
                        }
                    ]
                },
                "grpcSettings": {
                    "serviceName": "gandring"
                }
            }
        },
        {
            "port": 20520,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}",
                        "alterid": 0
#vmess-grpc-nontls
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "grpc",
                "security": "none",
                "tlsSettings": {
                    "serverName": "${domain}",
                    "alpn": [
                        "http/1.1",
                        "h2"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/etc/xray/xray.cer",
                            "keyFile": "/etc/xray/xray.key"
                        }
                    ],
                },
                "grpcSettings": {
                    "serviceName": "gandring"
                }
            }
        },
        {
            "port": 1150,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}",
                        "alterid": 0
#vmess-hdua-tls
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "h2",
                "security": "tls",
                "tlsSettings": {
                    "serverName": "${domain}",
                    "alpn": [
                        "http/1.1",
                        "h2"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/etc/xray/xray.cer",
                            "keyFile": "/etc/xray/xray.key"
                        }
                    ]
                },
                "httpSettings": {
                    "path": "gandring"
                }
            }
        },
        {
            "port": 21820,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}",
                        "alterid": 0
#vmess-hdua-nontls
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "h2",
                "security": "none",
                "tlsSettings": {
                    "serverName": "${domain}",
                    "alpn": [
                        "http/1.1",
                        "h2"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/etc/xray/xray.cer",
                            "keyFile": "/etc/xray/xray.key"
                        }
                    ]
                },
                "httpSettings": {
                    "path": "gandring"
                }
            }
        },
        {
            "port": 2083,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}"
#vless-grpc-tls
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "grpc",
                "security": "tls",
                "tlsSettings": {
                    "serverName": "${domain}",
                    "alpn": [
                        "http/1.1",
                        "h2"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/etc/xray/xray.cer",
                            "keyFile": "/etc/xray/xray.key"
                        }
                    ]
                },
                "grpcSettings": {
                    "serviceName": "gandring"
                }
            }
        },
        {
            "port": 2082,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}"
#vless-grpc-nontls
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "grpc",
                "security": "none",
                "tlsSettings": {
                    "serverName": "${domain}",
                    "alpn": [
                        "http/1.1",
                        "h2"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/etc/xray/xray.cer",
                            "keyFile": "/etc/xray/xray.key"
                        }
                    ],
                },
                "grpcSettings": {
                    "serviceName": "gandring"
                }
            }
        },
        {
            "port": 8888,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}"
#vless-hdua-tls
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "h2",
                "security": "tls",
                "tlsSettings": {
                    "serverName": "${domain}",
                    "alpn": [
                        "http/1.1",
                        "h2"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/etc/xray/xray.cer",
                            "keyFile": "/etc/xray/xray.key"
                        }
                    ]
                },
                "httpSettings": {
                    "path": "gandring"
                }
            }
        },
        {
            "port": 888,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}"
#vless-hdua-nontls
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "h2",
                "security": "none",
                "tlsSettings": {
                    "serverName": "${domain}",
                    "alpn": [
                        "http/1.1",
                        "h2"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/etc/xray/xray.cer",
                            "keyFile": "/etc/xray/xray.key"
                        }
                    ]
                },
                "httpSettings": {
                    "path": "gandring"
                }
            }
        }
    ],
    "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true
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

cat > /etc/systemd/system/xvmess.service << END
[Unit]
Description=XVMESS ROUTING GAJAH DEMAK BY GANDRING
Documentation=https://t.me/zerossl
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /usr/local/etc/xray/xvmess.json
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
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/xss.json
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
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/sstcp.json
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
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/trojangrpc.json
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
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /usr/local/etc/xray/vlessquic.json
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
END

# / / Installation Xray Service
cat > /etc/systemd/system/xray.service << END
[Unit]
Description=XRAY GAJAH DEMAK BY GANDRING
Documentation=https://t.me/zerossl
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23

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
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/xtrojan.json
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
END

# / / Installation Xray Service
cat > /etc/systemd/system/xvless.service << END
[Unit]
Description=XTROJAN ROUTING DAM COLO PENGKOL BY Z
Documentation=https://t.me/zerossl
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/xvless.json
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
END

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

# // Enable & Start Service
# Accept port Xray
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 8443 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 80 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2083 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2083 -j ACCEPT
sudo iptables-save > /etc/iptables.up.rules
sudo iptables-restore -t < /etc/iptables.up.rules
sudo netfilter-persistent save
sudo netfilter-persistent reload

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
    "fallback_port": 88,
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
Description=Trojan-Go Service Mod By zerossl
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
