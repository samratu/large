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
stls="$(cat ~/log-install.txt | grep -w "SOCKS5 WS TLS" | cut -d: -f2|sed 's/ //g')"
snontls="$(cat ~/log-install.txt | grep -w "SOCKS5 WS NON TLS" | cut -d: -f2|sed 's/ //g')"
sgrpc="$(cat ~/log-install.txt | grep -w "SOCKS5 GRPC TLS" | cut -d: -f2|sed 's/ //g')"
sgrpcnon="$(cat ~/log-install.txt | grep -w "SOCKS5 GRPC NON TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Username: " -e user
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
            "port": "10809",
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
          "0": {
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
cat /etc/xray/SOCKS5-WS-TLS-$user.json >> /home/vps/public_html/SOCKS5-WS-TLS-$user.txt

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
            "port": "10809",
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
          "0": {
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
cat /etc/xray/SOCKS5-WS-NONTLS-$user.json >> /home/vps/public_html/SOCKS5-WS-NONTLS-$user.txt

cat>/etc/xray/SOCKS5-GRPC-TLS-$user.json<<EOF
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
        "port": "10809",
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
           "0": {
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
cat /etc/xray/SOCKS5-GRPC-TLS-$user.json >> /home/vps/public_html/SOCKS5-GRPC-TLS-$user.txt

cat>/etc/xray/SOCKS5-GRPC-NONTLS-$user.json<<EOF
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
        "port": "10809",
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
          "grpcSettings": {
            "multiMode": true,
              "serviceName": "wisnu-grpc"
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
       "policy": {
         "levels": {
           "0": {
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
cat /etc/xray/SOCKS5-GRPC-NONTLS-$user.json >> /home/vps/public_html/SOCKS5-GRPC-NONTLS-$user.txt

tmp1=$(echo -n "${user}:${user}@${domain}:$stls" | base64 -w0)
tmp2=$(echo -n "${user}:${user}@${domain}:$snontls" | base64 -w0)
tmp3=$(echo -n "${user}:${user}@${domain}:$sgrpc" | base64 -w0)
tmp4=$(echo -n "${user}:${user}@${domain}:$sgrpcnon" | base64 -w0)
socks1="socks://$tmp1#$user"
socks2="socks://$tmp2#$user"
socks3="socks://$tmp3#$user"
socks4="socks://$tmp4#$user"
systemctl restart xtrojan
systemctl restart xss
systemctl restart xvmess.service
systemctl restart xray.service

cat /etc/xray/SOCKS5-GRPC-TLS-$user.json >> /home/vps/public_html/SOCKS5-GRPC-TLS-$user.txt
cat /etc/xray/SOCKS5-GRPC-NONTLS-$user.json >> /home/vps/public_html/SOCKS5-GRPC-NONTLS-$user.txt
cat /etc/xray/SOCKS5-WS-TLS-$user.json >> /home/vps/public_html/SOCKS5-WS-TLS-$user.txt
cat /etc/xray/SOCKS5-WS-NONTLS-$user.json >> /home/vps/public_html/SOCKS5-WS-NONTLS-$user.txt
service cron restart

rm -rf /etc/xray/SOCKS5-WS-TLS-$user.json
rm -rf /etc/xray/SOCKS5-WS-NONTLS-$user.json
rm -rf /etc/xray/SOCKS5-GRPC-TLS-$user.json
rm -rf /etc/xray/SOCKS5-GRPC-NONTLS-$user.json
clear
echo -e ""
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m 🔰 AKUN SOCKS5 WS GRPC🔰 \e[m"       
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Remarks  : ${user}"
echo -e "IP/Host  : ${MYIP}"
echo -e "Address  : ${domain}"
echo -e "Protocol : tcp,udp,ws,grpc"
echo -e "ServiceName: wisnu-grpc"
echo -e "Path WS : /wisnu-ws"
echo -e "Port TLS : ${stls}"
echo -e "Port NON TLS : ${snontls}"
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
echo -e "SOCKS5 GRPC TLS: http://$MYIP:88/SOCKS5-GRPC-TLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SOCKS5 GRPC NON TLS: http://$MYIP:88/SOCKS5-GRPC-NONTLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m🔰LUXURY EDITION ZEROSSL🔰\e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
