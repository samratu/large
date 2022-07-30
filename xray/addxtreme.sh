"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`

cat>/etc/xray/SOCKS5-TCP-TLS-$user.json<<EOF
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
        "network": "tcp",
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
cat /etc/xray/SOCKS5-TCP-TLS-$user.json >> /home/vps/public_html/SOCKS5-TCP-TLS-$user.txt

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
                     "address": "dl.gandring.my.id",
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

tmp1=$(echo -n "${user}:${user}" | base64 -w0)
tmp2=$(echo -n "${user}:${user}" | base64 -w0)
tmp3=$(echo -n "${user}:${user}" | base64 -w0)
tmp4=$(echo -n "${user}:${user}" | base64 -w0)
socks1="socks://$tmp1@${domain}:$stcp#$user"
socks2="socks://$tmp2@${domain}:$stls#$user"
socks3="socks://$tmp3@${domain}:$snontls#$user"
socks4="socks://$tmp4@${domain}:$sgrpc#$user"

rm -rf /etc/xray/SOCKS5-WS-TLS-$user.json
rm -rf /etc/xray/SOCKS5-WS-NONTLS-$user.json
rm -rf /etc/xray/SOCKS5-GRPC-$user.json

systemctl restart xtrojan
systemctl restart xss
systemctl restart xvmess.service
systemctl restart xray.service

domain=$(cat /etc/xray/domain)
ss22tls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 WS TLS" | cut -d: -f2|sed 's/ //g')"
ss22tcp="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 TCP" | cut -d: -f2|sed 's/ //g')"
ss22nontls="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 WS NON TLS" | cut -d: -f2|sed 's/ //g')"
ss22grpc="$(cat ~/log-install.txt | grep -w "SHADOWSOCKS 2022 GRPC TLS" | cut -d: -f2|sed 's/ //g')"
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
            "port": 80
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

tmp1=$(echo -n "2022-blake3-aes-128-gcm:$passwd:$base64" | base64 -w0)
tmp2=$(echo -n "2022-blake3-aes-128-gcm:$passwd:$base64" | base64 -w0)
tmp3=$(echo -n "2022-blake3-aes-128-gcm:$passwd:$base64" | base64 -w0)
tmp4=$(echo -n "2022-blake3-aes-128-gcm:$passwd:$base64" | base64 -w0)

shadowsocks1="ss://$tmp1@${domain}:$ss22tcp#%F0%9F%94%B0SS+TCP+$user"
shadowsocks2="ss://$tmp2@${domain}:$ss22tls#%F0%9F%94%B0SS+WS+TLS+$user"
shadowsocks3="ss://$tmp3@${domain}:$ss22nontls#%F0%9F%94%B0SS+WS+NONTLS+$user"
shadowsocks4="ss://$tmp4@${domain}:$ss22grpc#%F0%9F%94%B0SS+GRPC+$user"

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
echo -e "Password :$base64"
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
#echo -e "SS2022 TCP TLS: http://$MYIP:88/SS2022-TCP-TLS-$user.txt"
#echo -e "<><><><><><><><><><><><><><>"
echo -e "SS2022 WS TLS: http://$MYIP:88/SS2022-WS-TLS-$user.txt"
echo -e "<><><><><><><><><><><><><><>"
echo -e "SS2022 WS NON TLS: http://$MYIP:88/SS2022-WS-NONTLS-$user.txt"
echo -e "<><><><><><><><><><><><><><>"
echo -e "SS2022 GRPC TLS: http://$MYIP:88/SS2022-GRPC-TLS-$user.txt"
echo -e "<><><><><><><><><><><><><><>"
echo -e "SOCKS5 WS TLS: http://$MYIP:88/SOCKS5-WS-TLS-$user.txt"
echo -e "<><><><><><><><><><><><><><>"
echo -e "SOCKS5 WS NON TLS: http://$MYIP:88/SOCKS5-WS-NONTLS-$user.txt"
echo -e "<><><><><><><><><><><><><><>"
echo -e "SOCKS5 GRPC TLS: http://$MYIP:88/SOCKS5-GRPC-TLS-$user.txt"
echo -e "<><><><><><><><><><><><><><>"
#echo -e "SOCKS5 GRPC NON TLS: http://$MYIP:88/SOCKS5-GRPC-NONTLS-$user.txt"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;46m🔰LUXURY EDITION ZEROSSL🔰\e[m"   
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
