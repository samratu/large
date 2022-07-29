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
sstcp="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 TCP TLS" | cut -d: -f2|sed 's/ //g')"
ssnontls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 WS NON TLS" | cut -d: -f2|sed 's/ //g')"
ssgrpc="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 GRPC TLS" | cut -d: -f2|sed 's/ //g')"
ssgrpcnon="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 GRPC NON TLS" | cut -d: -f2|sed 's/ //g')"
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
cat>/etc/xray/SS22-TCP-TLS-$user.json<<EOF
{
  "{
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
                  "userLevel": 0
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
              "userLevel": 0
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
            "level": 0,
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
  "{
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
                  "userLevel": 0
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
              "userLevel": 0
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
            "level": 0,
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
                  "userLevel": 0
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
              "userLevel": 0
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
            "level": 0,
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

cat>/etc/xray/SS2022-GRPC-TLS-$user.json<<EOF
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
                  "userLevel": 0
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
              "userLevel": 0
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
            "level": 0,
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
cat /etc/xray/SS2022-GRPC-TLS-$user.json >> /home/vps/public_html/SS2022-GRPC-TLS-$user.txt

cat>/etc/xray/SS2022-GRPC-NONTLS-$user.json<<EOF
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
                  "userLevel": 0
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
              "userLevel": 0
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
            "level": 0,
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
         "security": "none",
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
cat /etc/xray/SS2022-GRPC-NONTLS-$user.json >> /home/vps/public_html/SS2022-GRPC-NONTLS-$user.txt

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
service cron restart
clear
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m    🔰AKUN SHADOWSOCKS 2022🔰     \e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Remarks     : ${user}"
echo -e "IP/Host     : ${MYIP}"
echo -e "Address     : ${domain}"
echo -e "Port TLS : $sstcp"
echo -e "Port NON TLS : $ssnontls"
echo -e "Security    : aes-128-gcm"
echo -e "Security    : 2022-blake3-aes-128-gcm"
echo -e "Network     : tcp,udp,WS,GRPC"
echo -e "Password    : ${user}"
echo -e "Created     : $hariini"
echo -e "Expired     : $exp"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SS 2022 TCP : ${shadowsocks1}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SS2022 TCP TLS: http://$MYIP:88/SS2022-TCP-TLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SS2022 WS TLS: http://$MYIP:88/SS2022-WS-TLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SS2022 WS NON TLS: http://$MYIP:88/SS2022-WS-NONTLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SS2022 GRPC TLS: http://$MYIP:88/SS2022-GRPC-TLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SS2022 GRPC NON TLS: http://$MYIP:88/SS2022-GRPC-NONTLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m  🔰LUXURY EDITION BY ZEROSSL🔰   \e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
