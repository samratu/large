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
/root/.acme.sh/acme.sh --issue -d "${domain}" --standalone --keylength ec-2048
/root/.acme.sh/acme.sh --install-cert -d "${domain}" --ecc \
--fullchain-file /etc/ssl/private/fullchain.pem \
--key-file /etc/ssl/private/privkey.pem
chown -R nobody:nogroup /etc/xray
chmod 644 /etc/ssl/private/privkey.pem
chmod 644 /etc/ssl/private/fullchain.pem
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install-geodata
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
  },
  "inbounds": [
    {
      "port": 99,
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
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
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
      "port": 3367,
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
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
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
      "port": 20987,
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
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
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
      "port": 2052,
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
          "path": "/shanum",
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
      "port": 1190,
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
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
        },
        "tcpSettings": {},
        "httpSettings": {
          "path": "/shanumhttp"
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
      "port": 2083,
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
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ],
          "alpn": [
            "h2"
          ]
        },
        "tcpSettings": {},
        "kcpSettings": {},
        "wsSettings": {},
        "httpSettings": {},
        "quicSettings": {},
        "grpcSettings": {
          "serviceName": "/shanumgrpc",
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
      "port": 2082,
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
          "serviceName": "/ahanumgrpc",
          "multiMode": true
        }
      }
    },
    {
      "port": 4143,
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
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
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
      "port": 8880,
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
          "path": "/wisnu",
          "headers": {
            "Host": "${domain}"
          }
        },
        "quicSettings": {}
      }
    },
    {
      "port": 3786,
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
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ],
          "alpn": [
            "h2"
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
          "serviceName": "/wisnugrpc"
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
      "port": 1080,
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
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
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
    },
    {
      "port": 1080,
      "protocol": "socks",
      "settings": {
        "auth": "password",
        "accounts": [
          {
            "user": "gandring",
            "pass": "gandring"
#xray-socks
          }
        ],
        "udp": true
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
        },
        "tcpSettings": {},
        "kcpSettings": {},
        "wsSettings": {
          "path": "/gandring",
          "headers": {
            "Host": "${domain}"
          }
        },
        "httpSettings": {},
        "quicSettings": {},
        "grpcSettings": {}
      },
      "domain": "$domain"
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
  "routing": {
    "domainStrategy": "AsIs",
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
        "outboundTag": "direct"
      },
      {
        "type": "field",
        "inboundTag": [
          "K"
        ],
        "outboundTag": "tg-out"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
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
cat > /etc/xray/xvless.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 10808,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
    {
      "port": 2096,
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "gandring",
            "email": "gandring@p0x.smule.my.id"
#vless-grpc-tls
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
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
        },
        "grpcSettings": {
        "acceptProxyProtocol": true,
          "serviceName": "/wisnugrpc"
        }
      }
    },
    {
      "port": 1150,
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "gandring",
            "email": "gandring@p0x.smule.my.id"
#vless-hdua
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "h2",
        "security": "tls",
        "tlsSettings": {
          "serverName": "",
          "alpn": [
            "h2",
            "http/1.1"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
        },
        "httpSettings": {
        "acceptProxyProtocol": true,
          "path": "/wisnuhttp"
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
      "8.8.8.8",
      "8.8.4.4",
      "1.1.1.1",
      "1.0.0.1",
      "localhost",
      "localhost://dns.google/dns-query",
      "localhost://1.1.1.1/dns-query"
    ]
  },
  "routing": {
    "domainStrategy": "AsIs",
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
        "outboundTag": "direct"
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
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
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
cat > /etc/xray/xtrojan.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 1440,
      "protocol": "trojan",
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
            "dest": 88,
            "xver": 0
          },
          {
            "dest": 8443,
            "xver": 0
          },
          {
            "path": "/gandring",
            "dest": 2095,
            "xver": 0
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlsSettings": {
        "acceptProxyProtocol": true,
          "alpn": [
            "h2",
            "http/1.1"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
        }
      }
    },
    {
      "port": 8443,
      "listen": "0.0.0.0",
      "protocol": "trojan",
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
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
        },
        "grpcSettings": {
          "serviceName": "/gandringgrpc"
        }
      }
    },
    {
      "port": 20009,
      "listen": "0.0.0.0",
      "protocol": "trojan",
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
          "path": "/gandring"
         },
         "tlsSettings": {
          "alpn": [
            "h2",
            "http/1.1"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
        }
      }
    },
    {
      "port": 2095,
      "listen": "0.0.0.0",
      "protocol": "trojan",
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
      "port": 888,
      "listen": "0.0.0.0",
      "protocol": "trojan",
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
          "path": "/gandringhttp"
         },
         "tlsSettings": {
          "alpn": [
            "h2",
            "http/1.1"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
        }
      }
    },
    {
      "{
      "port": 443,
      "listen": "0.0.0.0",
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "id": "gandring",
            "level": 0,
            "email": "gandring@p0x.smule.my.id"
#trojan-quic
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "quic",
        "quicSettings": {
          "security": "$domain",
          "key": "wisnuquic",
          "header": {
            "type": "none"
          }
        },
        "security": "tls",
        "tlsSettings": {
          "minVersion": "1.3",
          "certificates": [
           {
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ],
          "rejectUnknownSni": true
        }
      }
    },
    {
      "port": 414,
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "gandring",
            "email": "gandring@p0x.smule.my.id"
#vless-quic
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "quic",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
        },
        "quicSettings": {
          "security": "$domain",
          "key": "wisnuquic",
          "header": {
            "type": "none"
          }
        }
      }
    },
    {
      "port": 40,
      "protocol": "shadowsocks",
      "settings": {
        "method": "aes-128-gcm",
        "password": "gandring",
        "client": [
           {
             "password": "gandring",
             "email": "gandring@p0x.smule.my.id"
#xray-ss-udp
           }
        ],
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
      "port": 501,
      "protocol": "shadowsocks",
      "settings": {
        "method": "aes-128-gcm",
        "password": "gandring",
        "client": [
           {
             "password": "gandring",
             "email": "gandring@p0x.smule.my.id"
#xray-ss-tls
           }
        ],
        "network": "ws",
        "security": "tls",
        "wsSettings": {
          "path": "/gandring"
         },
         "tlsSettings": {
          "alpn": [
            "h2",
            "http/1.1"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
        }
      }
    },
    {
      "port": 502,
      "protocol": "shadowsocks",
      "settings": {
        "method": "aes-128-gcm",
        "password": "gandring",
        "client": [
           {
             "password": "gandring",
             "email": "gandring@p0x.smule.my.id"
#xray-ss-nontls
           }
        ],
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/gandring"
        }
      }
    },
    {
      "port": 6005,
      "listen": "0.0.0.0",
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "gandring",
            "email": "gandring@p0x.smule.my.id"
#trojan-http-tls
           }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "alpn": [
            "h2",
            "http/1.1"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
        },
        "tcpSettings": {
         "header": {
            "type": "http",
             "request": {
             "path": [
              "/satrio"
             ]
            }
          }
        }
      }
    },
    {
      "port": 880,
      "listen": "0.0.0.0",
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "gandring",
            "email": "gandring@p0x.smule.my.id"
#trojan-http-nontls
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
    },
    {
      "port": 8088,
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "gandring",
            "email": "gandring@p0x.smule.my.id"
#vless-http-nontls
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
      "8.8.8.8",
      "8.8.4.4",
      "1.1.1.1",
      "1.0.0.1",
      "localhost",
      "localhost://dns.google/dns-query",
      "localhost://1.1.1.1/dns-query"
    ]
  },
  "routing": {
    "domainStrategy": "AsIs",
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
        "outboundTag": "direct"
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
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
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
cat > /etc/xray/trojangrpc.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 1120,
      "listen": "0.0.0.0",
      "protocol": "trojan",
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
          "path": "/gandringhttp"
         },
         "tlsSettings": {
          "alpn": [
            "h2",
            "http/1.1"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
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
      "8.8.8.8",
      "8.8.4.4",
      "1.1.1.1",
      "1.0.0.1",
      "localhost",
      "localhost://dns.google/dns-query",
      "localhost://1.1.1.1/dns-query"
    ]
  },
  "routing": {
    "domainStrategy": "AsIs",
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
        "outboundTag": "direct"
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
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
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
    {
     "listen": "127.0.0.1",
     "port": 10808,
     "protocol": "dokodemo-door",
     "settings": {
          "address": "127.0.0.1"
         },
         "tag": "api"
    },
    {
     "port": 443,
     "protocol": "vless",
     "settings": {
       "clients": [
         {
          "id": "gandring",
          "flow": "xtls-rprx-direct",
          "level": 0,
          "email": "gandring@p0x.smule.my.id"
#vless-xtls
         }
       ],
       "decryption": "none",
       "fallbacks": [
         {
          "dest": 1100,
          "xver": 16
         },
         {
          "path": "/gandring",
          "dest": 1110,
          "xver": 16
         },
         {
          "path": "/gandringhttp",
          "dest": 1120,
          "xver": 16
         },
         {
          "path": "/gandringgrpc",
          "dest": 1130,
          "xver": 16
         },
         {
          "path": "/wisnu",
          "dest": 1140,
          "xver": 16
         },
         {
          "path": "/wisnuhttp",
          "dest": 1150,
          "xver": 16
         },
         {
          "path": "/wisnugrpc",
          "dest": 1160,
          "xver": 16
         },
         {
          "path": "/shanum",
          "dest": 1170,
          "xver": 16
         },
         {
          "path": "/shanumhttp",
          "dest": 1180,
          "xver": 16
         },
         {
          "path": "/shanumgrpc",
          "dest": 1190,
          "xver": 16
         },
         {
          "path": "/gandringtcp",
          "dest": 1200,
          "xver": 16
         },
         {
          "path": "/wisnutcp",
          "dest": 1210,
          "xver": 16
         },
         {
          "path": "/shanumtcp",
          "dest": 1220,
          "xver": 16
         }
       ]
     },
     "streamSettings": {
     "network": "tcp",
     "security": "xtls",
     "xtlsSettings": {
       "alpn": [
       "http/1.1"
      ],
      "certificates": [
         {
          "certificateFile": "/etc/ssl/private/fullchain.pem",
          "keyFile": "/etc/ssl/private/privkey.pem"
         }
       ]
      }
     }
    },
    {
     "port": 1100,
     "listen": "127.0.0.1",
     "protocol": "trojan",
     "settings": {
       "clients": [
         {
          "password": "gandring",
          "level": 0,
          "email": "gandring@p0x.smule.my.id"
#trojan-gfw
         }
        ],
        "fallbacks": [
         {
          "dest": 88
         }
        ]
       },
       "streamSettings": {
       "network": "tcp",
       "security": "none",
         "tcpSettings": {
         "acceptProxyProtocol": true
       }
     }
    },
    {
     "port": 1110,
     "listen": "127.0.0.1",
     "protocol": "trojan",
     "settings": {
       "clients": [
         {
          "password": "gandring",
          "level": 0,
          "email": "gandring@p0x.smule.my.id"
#trojan-tls
         }
        ],
        "fallbacks": [
         {
          "dest": 88
         }
        ]
       },
       "streamSettings": {
       "network": "ws",
       "security": "none",
         "wsSettings": {
           "acceptProxyProtocol": true,
           "path": "/gandring"
         }
      }
    },
    {
     "port": 1120,
     "listen": "127.0.0.1",
     "protocol": "trojan",
     "settings": {
       "clients": [
         {
          "password": "gandring",
          "level": 0,
          "email": "gandring@p0x.smule.my.id"
#trojan-hdua
         }
        ],
        "fallbacks": [
         {
          "dest": 88
         }
        ]
       },
       "streamSettings": {
       "network": "h2",
       "security": "none",
        "httpSettings": {
          "path": "/gandringhttp"
         }
      }
    },
    {
     "port": 1130,
     "listen": "127.0.0.1",
     "protocol": "trojan",
     "settings": {
       "clients": [
         {
          "password": "gandring",
          "level": 0,
          "email": "gandring@p0x.smule.my.id"
#trojan-grpcp
         }
        ],
        "fallbacks": [
         {
          "dest": 88
         }
        ]
       },
       "streamSettings": {
       "network": "grpc",
       "security": "none",
         "grpcSettings": {
         "path": "/gandringgrpc"
         }
       }
    },
    {
     "port": 1140,
     "listen": "127.0.0.1",
     "protocol": "vless",
     "settings": {
       "clients": [
         {
          "id": "gandring",
          "level": 0,
          "email": "gandring@p0x.smule.my.id"
#vless-tls
         }
       ],
       "decryption": "none"
      },
      "streamSettings": {
      "network": "ws",
      "security": "none",
        "wsSettings": {
        "acceptProxyProtocol": true,
        "path": "/wisnu"
       }
     }
    },
    {
     "port": 1150,
     "listen": "127.0.0.1",
     "protocol": "vless",
     "settings": {
       "clients": [
         {
          "id": "gandring",
          "level": 0,
          "email": "gandring@p0x.smule.my.id"
#vless-hdua
         }
       ],
       "decryption": "none"
      },
      "streamSettings": {
      "network": "h2",
      "security": "none",
        "httpSettings": {
        "path": "/wisnuhttp"
        }
      }
    },
    {
     "port": 1160,
     "listen": "127.0.0.1",
     "protocol": "vless",
     "settings": {
       "clients": [
         {
          "id": "gandring",
          "level": 0,
          "email": "gandring@p0x.smule.my.id"
#vless-grpc-tls
         }
       ],
       "decryption": "none"
      },
      "streamSettings": {
      "network": "grpc",
      "security": "none",
        "grpcSettings": {
        "path": "/wisnugrpc"
      }
     }
    },
    {
     "port": 1170,
     "listen": "127.0.0.1",
     "protocol": "vmess",
     "settings": {
       "clients": [
         {
          "id": "gandring",
          "level": 0,
          "email": "gandring@p0x.smule.my.id"
#vmess-tls
         }
       ]
      },
      "streamSettings": {
      "network": "ws",
      "security": "none",
        "wsSettings": {
        "acceptProxyProtocol": true,
        "path": "/shanum"
      }
     }
    },
    {
     "port": 1180,
     "listen": "127.0.0.1",
     "protocol": "vmess",
     "settings": {
       "clients": [
         {
          "id": "gandring",
          "level": 0,
          "email": "gandring@p0x.smule.my.id"
#vmess-hdua
         }
       ]
      },
      "streamSettings": {
      "network": "h2",
      "security": "none",
        "httpSettings": {
        "acceptProxyProtocol": true,
        "path": "/shanumhttp"
      }
     }
    },
    {
     "port": 1190,
     "listen": "127.0.0.1",
     "protocol": "vmess",
     "settings": {
      "clients": [
        {
         "id": "gandring",
         "level": 0,
         "email": "gandring@p0x.smule.my.id"
#vmess-grpc-tls
        }
       ]
      },
      "streamSettings": {
      "network": "grpc",
      "security": "none",
        "grpcSettings": {
        "acceptProxyProtocol": true,
        "serviceName": "/shanum"
      }
     }
    },
    {
     "port": 1200,
     "listen": "127.0.0.1",
     "protocol": "trojan",
     "settings": {
       "clients": [
         {
          "password": "gandring",
          "level": 0,
          "email": "gandring@p0x.smule.my.id"
#trojan-http-tls
         }
        ],
        "decryption": "none"
      },
      "streamSettings": {
      "network": "tcp",
       "security": "none",
        "tcpSettings": {
         "acceptProxyProtocol": true,
           "header": {
            "type": "http",
              "request": {
               "path": [
               "/gandringtcp"
              ]
            }
          }
        }
      }
    },
    {
     "port": 1210,
     "listen": "127.0.0.1",
     "protocol": "vless",
     "settings": {
       "clients": [
         {
          "id": "gandring",
          "level": 0,
          "email": "gandring@p0x.smule.my.id"
#vless-http-tls
         }
        ],
        "decryption": "none"
      },
      "streamSettings": {
      "network": "tcp",
       "security": "none",
         "tcpSettings": {
          "acceptProxyProtocol": true,
            "header": {
             "type": "http",
              "request": {
               "path": [
               "/wisnutcp"
              ]
            }
          }
        }
      }
    },
    {
     "port": 1220,
     "listen": "127.0.0.1",
     "protocol": "vmess",
     "settings": {
       "clients": [
         {
          "id": "gandring",
          "level": 0,
          "email": "gandring@p0x.smule.my.id"
#vmess-http-tls
         }
        ],
        "decryption": "none"
      },
      "streamSettings": {
      "network": "tcp",
       "security": "none",
         "tcpSettings": {
          "acceptProxyProtocol": true,
           "header": {
             "type": "http",
              "request": {
               "path": [
               "/shanumtcp"
              ]
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
      "8.8.8.8",
      "8.8.4.4",
      "1.1.1.1",
      "1.0.0.1",
      "localhost",
      "localhost://dns.google/dns-query",
      "localhost://1.1.1.1/dns-query"
    ]
  },
  "routing": {
    "domainStrategy": "AsIs",
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
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
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
cat > /usr/local/etc/xray/vlessquic.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 515,
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "gandring",
            "email": "gandring@p0x.smule.my.id"
#vless-quic
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "quic",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
        },
        "quicSettings": {
          "security": "$domain",
          "key": "wisnuquic",
          "header": {
            "type": "none"
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
      "8.8.8.8",
      "8.8.4.4",
      "1.1.1.1",
      "1.0.0.1",
      "localhost",
      "localhost://dns.google/dns-query",
      "localhost://1.1.1.1/dns-query"
    ]
  },
  "routing": {
    "domainStrategy": "AsIs",
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
        "outboundTag": "direct"
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
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
END

uuid=$(cat /proc/sys/kernel/random/uuid)
uuid5=$openssl rand -base64 16
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
  "inbounds": [
    {
        "port":212,
        "protocol":"shadowsocks",
        "settings":{
          "method":"2022-blake3-aes-128-gcm",
          "password": "fvRKCJ683/9WY0L7SHaNUmAyT3WcGEXBxVUvPV7BQms=",
          "network":"tcp,udp"
        }
      },
      {
        "port":441,
        "protocol":"shadowsocks",
        "settings":{
          "method":"2022-blake3-aes-128-gcm",
          "password": "fvRKCJ683/9WY0L7SHaNUmAyT3WcGEXBxVUvPV7BQms=",
          "network": "ws",
        "security": "tls",
        "wsSettings": {
          "path": "/gandring"
         },
         "tlsSettings": {
          "alpn": [
            "h2",
            "http/1.1"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/ssl/private/fullchain.pem",
              "keyFile": "/etc/ssl/private/privkey.pem"
            }
          ]
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
      "8.8.8.8",
      "8.8.4.4",
      "1.1.1.1",
      "1.0.0.1",
      "localhost",
      "https+local://dns.google/dns-query",
      "https+local://1.1.1.1/dns-query"
    ]
  },
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [
      {
        "type": "field",
        "inboundTag": [
          "TROJAN-XTLS-in",
          "TROJAN-gRPC-in",
          "TROJAN-WSTLS-in",
          "TROJAN-WS-in",
          "TROJAN-H2C-in",
          "TROJAN-HTTP-in"
        ],
        "outboundTag": "blackhole-out",
        "protocol": [ "bittorrent" ]
      }
    ]
  }
}
END

# / / Installation Xray Service
cat > /etc/systemd/system/xray.service << END
[Unit]
Description=XRAY ROUTING DAM COLO PENGKOL BY ZEROSSL
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
Description=XVLESS ROUTING DAM COLO PENGKOL BY SHANUM
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
RestartPreventExitStatus=23

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
RestartPreventExitStatus=23

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
RestartPreventExitStatus=23

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
RestartPreventExitStatus=23

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
sudo iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p udp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p udp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p udp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 300 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p udp --sport 300 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 10805 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p udp --sport 10805 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 10808 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p udp --sport 10808 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables-save > /etc/iptables.up.rules
sudo iptables-restore -t < /etc/iptables.up.rules
sudo netfilter-persistent save
sudo netfilter-persistent reload

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

domain=$(cat /root/domain)
# // Certificate File
path_cer="/etc/xray/xray.crt"
path_key="/etc/xray/xray.key"
#domain_ecc=$(cat /root/.acme.sh)
#domain.key=$(cat /root/.acme.sh/$domain_ecc)
#path_crt="/root/.acme.sh/$domain_ecc/fullchain.cer"
#path_key="/root/.acme.sh/$domain_ecc/$domain.key"
# Buat Config Trojan Go
cat > /etc/trojan-go/config.json << END
{
  "run_type": "server",
  "local_addr": "127.0.0.1",
  "local_port": 2053,
  "remote_addr": "127.0.0.1",
  "remote_port": 443,
  "log_level": 1,
  "log_file": "/var/log/trojan-go/trojan-go.log",
  "password": [
      "$uuid"
  ],
  "disable_http_check": true,
  "udp_timeout": 60,
  "ssl": {
    "verify": true,
    "verify_hostname": true,
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
    "no_delay": false,
    "keep_alive": false,
    "prefer_ipv4": false
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
      "key": "/etc/ssl/private/privkey.pem",
      "cert": "/etc/ssl/private/fullchain.pem",
      "verify_client": false,
      "client_cert": []
    }
  }
}
END

# Installing Trojan Go Service
cat > /etc/systemd/system/trojan-go.service << END
[Unit]
Description=Trojan-Go BENDUNG COLO PENGKOL BY GANDRING
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

sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2053 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2053 -j ACCEPT
sudo iptables-save > /etc/iptables.up.rules
sudo iptables-restore -t < /etc/iptables.up.rules
sudo netfilter-persistent save
sudo netfilter-persistent reload
systemctl daemon-reload
systemctl stop trojan-go
systemctl start trojan-go
systemctl enable trojan-go
systemctl restart trojan-go

cd
cp /root/domain /etc/xray
cp /root/domain /usr/local/etc/xray
