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
sstcp="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS TCP TLS" | cut -d: -f2|sed 's/ //g')"
ssnontls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS WS NON TLS" | cut -d: -f2|sed 's/ //g')"
ssgrpc="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS WS GRPC TLS" | cut -d: -f2|sed 's/ //g')"
ssgrpcnon="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS WS GRPC NON TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Password : " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

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
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Password : " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/xvless.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${CLIENT_NAME}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Password : " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/xtrojan.json | wc -l)

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
sed -i '/#xray-ss-tls$/a\### '"$user $exp"'\
},{"method": "'""aes-128-gcm""'","password": "'""$uuid""'"' /etc/xray/config.json
sed -i '/#xray-ss-tcp$/a\### '"$user $exp"'\
},{"method": "'""aes-128-gcm""'","password": "'""$uuid""'"' /etc/xray/config.json
sed -i '/#xray-ss-tls$/a\### '"$user $exp"'\
},{"method": "'""aes-128-gcm""'","password": "'""$uuid""'"' /etc/xray/xvmess.json
sed -i '/#xray-ss-grpc$/a\### '"$user $exp"'\
},{"method": "'""aes-128-gcm""'","password": "'""$uuid""'"' /etc/xray/xvmess.json
sed -i '/#xray-ss-grpc$/a\### '"$user $exp"'\
},{"method": "'""aes-128-gcm""'","password": "'""$uuid""'"' /etc/xray/config.json
cat>/etc/xray/ss-tcp-$user.json<<EOF
      {
  "inbounds": [
    {
      "port": 212,
      "protocol": "shadowsocks",
      "settings": {
        "method": "aes-128-gcm",
        "password": "$user",
        "network": "tcp,udp"
      }
    },
EOF
tmp1=$(echo -n "aes-128-gcm:${uuid}" | base64 -w0)
shadow1="ss://$tmp1@$domain:$sstcp#%F0%9F%94%B0SS+TCP+$user "

cat>/etc/xray/SS-TCP-TLS-$user.json<<EOF
{
 "dns": {
    "servers": [
      "8.8.8.8",
        "8.8.4.4"
    ]
  },
 "inbounds": [
   {
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
      "port": 10809,
        "protocol": "http",
          "settings": {
            "userLevel": 0
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "none"
  },
  "outbounds": [
    {
      "mux": {
        "enabled": true
      },
      "protocol": "shadowsocks",
        "settings": {
          "servers": [
          {
           "address": "${domain}",
             "level": 0,
               "method": "aes-128-gcm",
                 "password": "${uuid}",
                   "port": 212
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
      "statsOutboundUplink": true,
        "statsOutboundDownlink": true
    }
  },
  "routing": {
    "domainStrategy": "Asls",
      "rules": []
  },
  "stats": {}
}
EOF
cat /etc/xray/SS-TCP-TLS-$user.json >> /home/vps/public_html/SS-TCP-TLS-$user.txt
tmp1=$(echo -n "aes-128-gcm:$uuid" | base64 -w0)
shadow1="ss://$tmp1@$domain:$sstcp#%F0%9F%94%B0SS+TCP+$user"

cat>/etc/xray/SS-WS-TLS-$user.json<<EOF
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
     "protocol": "shadowsocks",
       "settings": {
         "servers": [
          {
            "address": "${domain}",
            "level": 0,
            "method": "aes-128-gcm",
            "password": "${uuid}",
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
                "path": "/shanum-ws"
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
cat /etc/xray/SS-WS-TLS-$user.json >> /home/vps/public_html/SS-WS-TLS-$user.txt

tmp2=$(echo -n "aes-128-gcm:${uuid}" | base64 -w0)
shadow2="ss://$tmp2@$domain:$sstls#%F0%9F%94%B0SS+WS+TLS+$user"

cat>/etc/xray/SS-WS-NONTLS-$user.json<<EOF
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
     "protocol": "shadowsocks",
       "settings": {
         "servers": [
          {
            "address": "${domain}",
            "level": 0,
            "method": "aes-128-gcm",
            "password": "${uuid}",
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
                "path": "/shanum-ws"
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
cat /etc/xray/SS-WS-NONTLS-$user.json >> /home/vps/public_html/SS-WS-NONTLS-$user.txt
tmp3=$(echo -n "aes-128-gcm:${user}@${domain}:$ssnontls" | base64 -w0)
shadow3="ss://$tmp3#$user"

cat>/etc/xray/SS-GRPC-TLS-$user.json<<EOF
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
     "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "${domain}",
            "level": 0,
            "method": "aes-128-gcm",
            "password": "${uuid}",
            "port": 443
          }
        ]
      },
      "streamSettings": {
        "grpcSettings": {
          "multiMode": true,
            "serviceName": "shanum-grpc"
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
cat /etc/xray/SS-GRPC-TLS-$user.json >> /home/vps/public_html/SS-GRPC-TLS-$user.txt

cat>/etc/xray/SS-GRPC-NONTLS-$user.json<<EOF
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
     "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "${domain}",
            "level": 0,
            "method": "aes-128-gcm",
            "password": "${uuid}",
            "port": 80
          }
        ]
      },
      "streamSettings": {
        "grpcSettings": {
          "multiMode": true,
            "serviceName": "shanum-grpc"
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
cat /etc/xray/SS-GRPC-NONTLS-$user.json >> /home/vps/public_html/SS-GRPC-NONTLS-$user.txt

tmp4=$(echo -n "aes-128-gcm:$uuid" | base64 -w0)
shadow4="ss://$tmp4@$domain:$ssgrpc#%F0%9F%94%B0SS+GRPC+TLS+$user"
tmp5=$(echo -n "aes-128-gcm:$uuid" | base64 -w0)
shadow5="ss://$tmp5@$domain:$ssgrpcnon#%F0%9F%94%B0SS+GRPC+NONTLS+$user"
systemctl restart xvmess
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
echo -e "Port TCP    : ${sstcp}"
echo -e "Port TLS    : ${sstls}"
echo -e "Port NON TLS  : $ssnontls"
echo -e "Security    : aes-128-gcm"
echo -e "Path WS     : /shanum-ws"
echo -e "Path GRPC   : shanum-grpc"
echo -e "Network     : tcp,udp,ws,grpc"
echo -e "Password    : ${uuid}"
echo -e "Created     : $hariini"
echo -e "Expired     : $exp"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SS TCP : ${shadow1}"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SS TCP TLS: http://$MYIP:88/SS-TCP-TLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SS WS TLS: http://$MYIP:88/SS-WS-TLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SS WS NON TLS: http://$MYIP:88/SS-WS-NONTLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SS GRPC TLS: http://$MYIP:88/SS-GRPC-TLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "SS GRPC NON TLS: http://$MYIP:88/SS-GRPC-NONTLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m  🔰LUXURY EDITION BY ZEROSSL🔰   \e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
