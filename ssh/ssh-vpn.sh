#!/bin/bash
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

# Getting
MYIP=$(wget -qO- https://ipv4.icanhazip.com);
MYIP6=$(wget -qO- https://ipv6.icanhazip.com);
# Link Hosting Kalian
wisnuvpn="raw.githubusercontent.com/samratu/large/sae/ssh"

# Link Hosting Kalian Untuk Xray
wisnuvpnn="raw.githubusercontent.com/samratu/large/sae/xray"

# Link Hosting Kalian Untuk Trojan Go
wisnuvpnnn="raw.githubusercontent.com/samratu/large/sae/trojango"

# Link Hosting Kalian Untuk Stunnel5
wisnuvpnnnn="raw.githubusercontent.com/samratu/large/sae/stunnel5"

wisnuvpnnnnn="raw.githubusercontent.com/samratu/large/sae/update"
# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=Jawa-Tengah
locality=Sukoharjo
organization=GANDRING-VPN
organizationalunit=GANDRING
commonname=GANDRING-VPN
email=djarumpentol01@gmail.com

# simple password minimal
wget -O /etc/pam.d/common-password "https://${wisnuvpn}/password"
chmod +x /etc/pam.d/common-password

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target

END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl daemon-reload
systemctl enable rc-local.service
systemctl start rc-local.service

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y
apt-get purge apache2* -y
rm -rf /etc/apache2

# install wget and curl
apt -y install wget curl
apt install ssl-cert -y
apt install ca-certificate -y
# Install Requirements Tools
apt install ruby -y
apt install python -y
apt install privoxy -y
apt install make -y
apt install cowsay -y
apt install figlet -y
apt install lolcat -y
apt install cmake -y
apt install ncurses-utils -y
apt install coreutils -y
apt install rsyslog -y
apt install net-tools -y
apt install zip -y
apt install unzip -y
apt install nano -y
apt install sed -y
apt install gnupg -y
apt install gnupg1 -y
apt install gnupg2 -y
apt install bc -y
apt install jq -y
apt install apt-transport-https -y
apt install build-essential -y
apt install dirmngr -y
apt install libxml-parser-perl -y
apt install neofetch -y
apt install git -y
apt install lsof -y
apt install libsqlite3-dev -y
apt install libz-dev -y
apt install gcc -y
apt install g++ -y
apt install libreadline-dev -y
apt install zlib1g-dev -y
apt install libssl-dev -y
gem install lolcat
apt install jq curl -y
apt install dnsutils jq -y
apt-get install tcpdump -y
apt-get install dsniff -y
apt install grepcidr -y

# Privoxy Ports
Privoxy_Port1='4000'
Privoxy_Port2='5000'

 # Creating Privoxy server config using cat eof tricks
cd
cat <<'privoxy' > /etc/privoxy/config
# My Privoxy Server Config
user-manual /usr/share/doc/privoxy/user-manual
confdir /etc/privoxy
logdir /var/log/privoxy
filterfile default.filter
logfile logfile
listen-address 0.0.0.0:4000
listen-address 0.0.0.0:5000
toggle 1
enable-remote-toggle 0
enable-remote-http-toggle 0
enable-edit-actions 0
enforce-blocks 0
buffer-limit 4096
enable-proxy-authentication-forwarding 1
forwarded-connect-retries 1
accept-intercepted-requests 1
allow-cgi-request-crunching 1
split-large-forms 0
keep-alive-timeout 5
tolerate-pipelining 1
socket-timeout 300
permit-access 0.0.0.0/0 IP-ADDRESS
privoxy
IP-ADDRESS=$MYIP

#Setting machine's IP Address inside of our privoxy config(security that only allows this machine to use this proxy server)
sed -i "s|IP-ADDRESS|$MYIP|g" /etc/privoxy/config
 
#Setting privoxy ports
sed -i "s|Privoxy_Port1|$Privoxy_Port1|g" /etc/privoxy/config
sed -i "s|Privoxy_Port2|$Privoxy_Port2|g" /etc/privoxy/config

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
mkdir /etc/ssl/zerossl.my.id/

# install
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof
#echo "neofetch" >> .profile
echo "status" >> .profile

# install webserver
apt -y install nginx php php-fpm php-cli php-mysql libxml-parser-perl
rm /etc/nginx/sites-enabled/
rm /etc/nginx/sites-available/
curl https://${wisnuvpn}/nginx.conf > /etc/nginx/nginx.conf
curl https://${wisnuvpn}/vps.conf > /etc/nginx/conf.d/vps.conf
sed -i 's/listen = \/var\/run\/php-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php/fpm/pool.d/www.conf
useradd -m vps;
mkdir -p /home/vps/public_html
echo "<?php phpinfo() ?>" > /home/vps/public_html/info.php
chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html
cd /home/vps/public_html
wget -O /home/vps/public_html/index.html "https://${wisnuvpn}/index.html"
/etc/init.d/nginx restart

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://${wisnuvpn}/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500' /etc/rc.local

# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

# install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=200/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 300"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# install squid
cd
apt -y install squid3
wget -O /etc/squid/squid.conf "https://${wisnuvpn}/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# Install SSLH
apt -y install sslh
rm -f /etc/default/sslh

# Settings SSLH
cat > /etc/default/sslh <<-END
# Default options for sslh initscript
# sourced by /etc/init.d/sslh

# Disabled by default, to force yourself
# to read the configuration:
# - /usr/share/doc/sslh/README.Debian (quick start)
# - /usr/share/doc/sslh/README, at "Configuration" section
# - sslh(8) via "man sslh" for more configuration details.
# Once configuration ready, you *must* set RUN to yes here
# and try to start sslh (standalone mode only)

RUN=yes

# binary to use: forked (sslh) or single-thread (sslh-select) version
# systemd users: don't forget to modify /lib/systemd/system/sslh.service
DAEMON=/usr/sbin/sslh

DAEMON_OPTS="--user sslh --listen 0.0.0.0:8443 --ssl 127.0.0.1:500 --ssh 127.0.0.1:300 --openvpn 127.0.0.1:1194 --http 127.0.0.1:8880 --pidfile /var/run/sslh/sslh.pid"

END

# Restart Service SSLH
service sslh restart
systemctl restart sslh
/etc/init.d/sslh restart
/etc/init.d/sslh status
/etc/init.d/sslh restart

# setting vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

mkdir -p /usr/local/wisnucs
mkdir -p /etc/wisnucs

# install stunnel 5 
cd /root/
wget -q -O stunnel5.zip "https://${wisnuvpnnnn}/stunnel5.zip"
unzip -o stunnel5.zip
cd /root/stunnel
chmod +x configure
./configure
make
make install
cd /root
rm -r -f stunnel
rm -f stunnel5.zip
mkdir -p /etc/stunnel5
chmod 644 /etc/stunnel5

# Download Config Stunnel5
cat > /etc/stunnel5/stunnel5.conf <<-END
cert = /etc/stunnel5/stunnel5.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 600
connect = 127.0.0.1:300

[openssh]
accept = 500
connect = 127.0.0.1:8443

[openvpn]
accept = 990
connect = 127.0.0.1:1194

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key #!/usr/bin/python
import socket, threading, thread, select, signal, sys, time, getopt

# Listen
LISTENING_ADDR = '0.0.0.0'
if sys.argv[1:]:
	LISTENING_PORT = sys.argv[1]
else:
	LISTENING_PORT = 80

# Pass
PASS = ''

# CONST
BUFLEN = 4096 * 4
TIMEOUT = 60
DEFAULT_HOST = '127.0.0.1:8443'
#RESPONSE = 'HTTP/1.1 101 <b><font color="blue"> GANDRING BAGUS SATRIO </font></b>\r\n\r\nContent-Length: 1048576000000\r\n\r\n'
RESPONSE = 'HTTP/1.1 501 <b><font color="red">SUN AMATAK AJIKU SI JARAN GOYANG TAK GOYANG ING TENGAH LATAR CEMETHIKU SODHO LANANG SAKING SWARGO TAK SABETAKE GUNUNG JUGRUG TAK SABETAKE SEGORO ASAT TAK SABETAKE MARANG ATINE SI JABANG BAYI PET SIDHO EDAN ORA EDAN SIDHO GENDENG ORA GENDENG ORA MARI MARI YEN ORA INGSUN SING NAMBANI </font></b>\r\n\r\nContent-Length: 104857600000\r\n\r\n'

class Server(threading.Thread):
    def __init__(self, host, port):
        threading.Thread.__init__(self)
        self.running = False
        self.host = host
        self.port = port
        self.threads = []
        self.threadsLock = threading.Lock()
        self.logLock = threading.Lock()

    def run(self):
        self.soc = socket.socket(socket.AF_INET)
        self.soc.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.soc.settimeout(2)
        intport = int(self.port)
        self.soc.bind((self.host, intport))
        self.soc.listen(0)
        self.running = True

        try:
            while self.running:
                try:
                    c, addr = self.soc.accept()
                    c.setblocking(1)
                except socket.timeout:
                    continue

                conn = ConnectionHandler(c, self, addr)
                conn.start()
                self.addConn(conn)
        finally:
            self.running = False
            self.soc.close()

    def printLog(self, log):
        self.logLock.acquire()
        print log
        self.logLock.release()

    def addConn(self, conn):
        try:
            self.threadsLock.acquire()
            if self.running:
                self.threads.append(conn)
        finally:
            self.threadsLock.release()

    def removeConn(self, conn):
        try:
            self.threadsLock.acquire()
            self.threads.remove(conn)
        finally:
            self.threadsLock.release()

    def close(self):
        try:
            self.running = False
            self.threadsLock.acquire()

            threads = list(self.threads)
            for c in threads:
                c.close()
        finally:
            self.threadsLock.release()


class ConnectionHandler(threading.Thread):
    def __init__(self, socClient, server, addr):
        threading.Thread.__init__(self)
        self.clientClosed = False
        self.targetClosed = True
        self.client = socClient
        self.client_buffer = ''
        self.server = server
        self.log = 'Connection: ' + str(addr)

    def close(self):
        try:
            if not self.clientClosed:
                self.client.shutdown(socket.SHUT_RDWR)
                self.client.close()
        except:
            pass
        finally:
            self.clientClosed = True

        try:
            if not self.targetClosed:
                self.target.shutdown(socket.SHUT_RDWR)
                self.target.close()
        except:
            pass
        finally:
            self.targetClosed = True

    def run(self):
        try:
            self.client_buffer = self.client.recv(BUFLEN)

            hostPort = self.findHeader(self.client_buffer, 'X-Real-Host')

            if hostPort == '':
                hostPort = DEFAULT_HOST

            split = self.findHeader(self.client_buffer, 'X-Split')

            if split != '':
                self.client.recv(BUFLEN)

            if hostPort != '':
                passwd = self.findHeader(self.client_buffer, 'X-Pass')
				
                if len(PASS) != 0 and passwd == PASS:
                    self.method_CONNECT(hostPort)
                elif len(PASS) != 0 and passwd != PASS:
                    self.client.send('HTTP/1.1 400 WrongPass!\r\n\r\n')
                elif hostPort.startswith('127.0.0.1') or hostPort.startswith('localhost'):
                    self.method_CONNECT(hostPort)
                else:
                    self.client.send('HTTP/1.1 403 Forbidden!\r\n\r\n')
            else:
                print '- No X-Real-Host!'
                self.client.send('HTTP/1.1 400 NoXRealHost!\r\n\r\n')

        except Exception as e:
            self.log += ' - error: ' + e.strerror
            self.server.printLog(self.log)
	    pass
        finally:
            self.close()
            self.server.removeConn(self)

    def findHeader(self, head, header):
        aux = head.find(header + ': ')

        if aux == -1:
            return ''

        aux = head.find(':', aux)
        head = head[aux+2:]
        aux = head.find('\r\n')

        if aux == -1:
            return ''

        return head[:aux];

    def connect_target(self, host):
        i = host.find(':')
        if i != -1:
            port = int(host[i+1:])
            host = host[:i]
        else:
            if self.method=='CONNECT':
                port = 443
            else:
                port = sys.argv[1]

        (soc_family, soc_type, proto, _, address) = socket.getaddrinfo(host, port)[0]

        self.target = socket.socket(soc_family, soc_type, proto)
        self.targetClosed = False
        self.target.connect(address)

    def method_CONNECT(self, path):
        self.log += ' - CONNECT ' + path

        self.connect_target(path)
        self.client.sendall(RESPONSE)
        self.client_buffer = ''

        self.server.printLog(self.log)
        self.doCONNECT()

    def doCONNECT(self):
        socs = [self.client, self.target]
        count = 0
        error = False
        while True:
            count += 1
            (recv, _, err) = select.select(socs, [], socs, 3)
            if err:
                error = True
            if recv:
                for in_ in recv:
		    try:
                        data = in_.recv(BUFLEN)
                        if data:
			    if in_ is self.target:
				self.client.send(data)
                            else:
                                while data:
                                    byte = self.target.send(data)
                                    data = data[byte:]

                            count = 0
			else:
			    break
		    except:
                        error = True
                        break
            if count == TIMEOUT:
                error = True
            if error:
                break


def print_usage():
    print 'Usage: proxy.py -p <port>'
    print '       proxy.py -b <bindAddr> -p <port>'
    print '       proxy.py -b 0.0.0.0 -p 80'

def parse_args(argv):
    global LISTENING_ADDR
    global LISTENING_PORT
    
    try:
        opts, args = getopt.getopt(argv,"hb:p:",["bind=","port="])
    except getopt.GetoptError:
        print_usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print_usage()
            sys.exit()
        elif opt in ("-b", "--bind"):
            LISTENING_ADDR = arg
        elif opt in ("-p", "--port"):
            LISTENING_PORT = int(arg)


def main(host=LISTENING_ADDR, port=LISTENING_PORT):
    print "\n:-------PythonProxy-------:\n"
    print "Listening addr: " + LISTENING_ADDR
    print "Listening port: " + str(LISTENING_PORT) + "\n"
    print ":-------------------------:\n"
    server = Server(LISTENING_ADDR, LISTENING_PORT)
    server.start()
    while True:
        try:
            time.sleep(2)
        except KeyboardInterrupt:
            print 'Stopping...'
            server.close()
            break

#######    parse_args(sys.argv[1:])
if __name__ == '__main__':
    main()
.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel5/stunnel5.pem

# Service Stunnel5 systemctl restart stunnel5
cat > /etc/systemd/system/stunnel5.service << END
[Unit]
Description=Stunnel5 Service
Documentation=https://stunnel.org
Documentation=https://github.com/wisnucokrosatrio
After=syslog.target network-online.target

[Service]
ExecStart=/usr/local/wisnucs/stunnel5 /etc/stunnel5/stunnel5.conf
Type=forking

[Install]
WantedBy=multi-user.target
END

# Service Stunnel5 /etc/init.d/stunnel5
wget -q -O /etc/init.d/stunnel5 "https://${wisnuvpnnnn}/stunnel5.init"

# Ubah Izin Akses
chmod 600 /etc/stunnel5/stunnel5.pem
chmod +x /etc/init.d/stunnel5
cp /usr/local/bin/stunnel /usr/local/wisnucs/stunnel5

# Remove File
rm -r -f /usr/local/share/doc/stunnel/
rm -r -f /usr/local/etc/stunnel/
rm -f /usr/local/bin/stunnel
rm -f /usr/local/bin/stunnel3
rm -f /usr/local/bin/stunnel4
#rm -f /usr/local/bin/stunnel5

# Restart Stunnel 5
systemctl stop stunnel5
systemctl enable stunnel5
systemctl start stunnel5
systemctl restart stunnel5
/etc/init.d/stunnel5 restart
/etc/init.d/stunnel5 status
/etc/init.d/stunnel5 restart
#OpenVPN
wget https://${wisnuvpn}/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'
# Install DDoS Deflate
apt install -y dnsutils tcpdump dsniff grepcidr
wget -qO ddos.zip "https://raw.githubusercontent.com/Hanxhin/Autoscript/main/FILES/ddos-deflate.zip"
unzip ddos.zip
cd ddos-deflate
chmod +x install.sh
./install.sh
cd
rm -rf ddos.zip ddos-deflate

# banner /etc/issue.net
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# Install BBR
wget https://${wisnuvpn}/bbr.sh && chmod +x bbr.sh && ./bbr.sh

# Ganti Banner
wget -O /etc/issue.net "https://${wisnuvpn}/issue.net"

# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# download script
cd /usr/bin
wget -O restart "https://${wisnuvpn}/restart.sh"
wget -O addhost "https://${wisnuvpn}/addhost.sh"
wget -O about "https://${wisnuvpn}/about.sh"
wget -O addssh "https://${wisnuvpn}/addssh.sh"
wget -O trialssh "https://${wisnuvpn}/trialssh.sh"
wget -O menuu "https://${wisnuvpn}/menuu.sh"
wget -O delssh "https://${wisnuvpn}/delssh.sh"
wget -O member "https://${wisnuvpn}/member.sh"
wget -O delexp "https://${wisnuvpn}/delexp.sh"
wget -O cekssh "https://${wisnuvpn}/cekssh.sh"
wget -O restart "https://${wisnuvpn}/restart.sh"
wget -O speedtest "https://${wisnuvpn}/speedtest_cli.py"
wget -O info "https://${wisnuvpn}/info.sh"
wget -O ram "https://${wisnuvpn}/ram.sh"
wget -O renewssh "https://${wisnuvpn}/renewssh.sh"
wget -O autokill "https://${wisnuvpn}/autokill.sh"
wget -O ceklim "https://${wisnuvpn}/ceklim.sh"
wget -O tendang "https://${wisnuvpn}/tendang.sh"
wget -O clearlog "https://${wisnuvpn}/clearlog.sh"
wget -O changeport "https://${wisnuvpn}/changeport.sh"
wget -O wbmn "https://${wisnuvpn}/webmin.sh"
wget -O xp "https://${wisnuvpn}/xp.sh"
wget -O swapkvm "https://${wisnuvpn}/swapkvm.sh"

wget -O portovpn "https://${wisnuvpn}/portovpn.sh"
wget -O portwg "https://${wisnuvpn}/portwg.sh"
wget -O porttrojan "https://${wisnuvpn}/porttrojan.sh"
wget -O porttrojango "https://${wisnuvpn}/porttrojango.sh"
wget -O portgrpc "https://${wisnuvpn}/portgrpc.sh"
wget -O portsstp "https://${wisnuvpn}/portsstp.sh"
wget -O portsquid "https://${wisnuvpn}/portsquid.sh"
wget -O portvlm "https://${wisnuvpn}/portvlm.sh"
wget -O portstunnel5 "https://${wisnuvpn}/portstunnel5.sh"
wget -O portdropbear "https://${wisnuvpn}/portdropbear.sh"
wget -O portopenssh "https://${wisnuvpn}/portopenssh.sh"
wget -O portsshnontls "https://${wisnuvpn}/portsshnontls.sh"
wget -O portsshwstls "https://${wisnuvpn}/portsshwstls.sh"

wget -O addvmess "https://${wisnuvpnn}/addvmess.sh"
wget -O addnewtr "https://${wisnuvpnn}/addnewtr.sh"
wget -O addvmessgrpc "https://${wisnuvpnn}/addvmessgrpc.sh"
wget -O addvmesshdua "https://${wisnuvpnn}/addvmesshdua.sh"
wget -O addvmesshttp "https://${wisnuvpnn}/addvmesshttp.sh"
wget -O addvlessxtls "https://${wisnuvpnn}/addvlessxtls.sh"
wget -O addvlesshttp "https://${wisnuvpnn}/addvlesshttp.sh"
wget -O addvlesshdua "https://${wisnuvpnn}/addvlesshdua.sh"
wget -O addxrayss "https://${wisnuvpnn}/addxrayss.sh"
wget -O addvless "https://${wisnuvpnn}/addvless.sh"
wget -O addvlessgrpc "https://${wisnuvpnn}/addvlessgrpc.sh"
wget -O addtrojan "https://${wisnuvpnn}/addtrojan.sh"
wget -O addxtlstrojan "https://${wisnuvpnn}/addxtlstrojan.sh"
wget -O addgrpctrojan "https://${wisnuvpnn}/addgrpctrojan.sh"
wget -O addtrojanwss "https://${wisnuvpnn}/addtrojanwss.sh"
wget -O addtrojanhttp "https://${wisnuvpnn}/addtrojanhttp.sh"
wget -O addtrojanhdua "https://${wisnuvpnn}/addtrojanhdua.sh"
wget -O addxrayss "https://${wisnuvpnn}/addxrayss.sh"
wget -O addnewtr "https://${wisnuvpnn}/addnewtr.sh"
wget -O addnewvmess "https://${wisnuvpnn}/addnewvmess.sh"
wget -O addnewvless "https://${wisnuvpnn}/addnewvless.sh"

wget -O delxrayss "https://${wisnuvpnn}/delxrayss.sh"
wget -O delvmess "https://${wisnuvpnn}/delvmess.sh"
wget -O delnewvmess "https://${wisnuvpnn}/delnewvmess.sh"
wget -O delnewvless "https://${wisnuvpnn}/delnewvless.sh"
wget -O delnewtr "https://${wisnuvpnn}/delnewtr.sh"
wget -O delvmessgrpc "https://${wisnuvpnn}/delvmessgrpc.sh"
wget -O delvmesshdua "https://${wisnuvpnn}/delvmesshdua.sh"
wget -O delvmesshttp "https://${wisnuvpnn}/delvmesshttp.sh"
wget -O delvlessxtls "https://${wisnuvpnn}/delvlessxtls.sh"
wget -O delvlesshttp "https://${wisnuvpnn}/delvlesshttp.sh"
wget -O delvlesshdua "https://${wisnuvpnn}/delvlesshdua.sh"
wget -O delxrayss "https://${wisnuvpnn}/delxrayss.sh"
wget -O delvless "https://${wisnuvpnn}/delvless.sh"
wget -O delvlessgrpc "https://${wisnuvpnn}/delvlessgrpc.sh"
wget -O deltrojan "https://${wisnuvpnn}/deltrojan.sh"
wget -O delxtlstrojan "https://${wisnuvpnn}/delxtlstrojan.sh"
wget -O delgrpctrojan "https://${wisnuvpnn}/delgrpctrojan.sh"
wget -O deltrojanwss "https://${wisnuvpnn}/deltrojanwss.sh"
wget -O deltrojanhdua "https://${wisnuvpnn}/deltrojanhdua.sh"
wget -O deltrojanhttp "https://${wisnuvpnn}/deltrojanhttp.sh"

wget -O cekvmess "https://${wisnuvpnn}/cekvmess.sh"
wget -O cekvmessgrpc "https://${wisnuvpnn}/cekvmessgrpc.sh"
wget -O cekvmesshdua "https://${wisnuvpnn}/cekvmesshdua.sh"
wget -O cekvmesshttp "https://${wisnuvpnn}/cekvmesshttp.sh"
wget -O cekvlessxtls "https://${wisnuvpnn}/cekvlessxtls.sh"
wget -O cekvlesshttp "https://${wisnuvpnn}/cekvlesshttp.sh"
wget -O cekvlesshdua "https://${wisnuvpnn}/cekvlesshdua.sh"
wget -O cekxrayss "https://${wisnuvpnn}/cekxrayss.sh"
wget -O cekvless "https://${wisnuvpnn}/cekvless.sh"
wget -O cekvlessgrpc "https://${wisnuvpnn}/cekvlessgrpc.sh"
wget -O cektrojan "https://${wisnuvpnn}/cektrojan.sh"
wget -O cekxtlstrojan "https://${wisnuvpnn}/cekxtlstrojan.sh"
wget -O cekgrpctrojan "https://${wisnuvpnn}/cekgrpctrojan.sh"
wget -O cektrojanwss "https://${wisnuvpnn}/cektrojanwss.sh"
wget -O cektrojanhttp "https://${wisnuvpnn}/cektrojanhttp.sh"
wget -O ceknewtr "https://${wisnuvpnn}/ceknewtr.sh"
wget -O cekxrayss "https://${wisnuvpnn}/cekxrayss.sh"
wget -O cektrojanhdua "https://${wisnuvpnn}/cektrojanhdua.sh"

wget -O renewxrayss "https://${wisnuvpnn}/renewxrayss.sh"
wget -O renewvmess "https://${wisnuvpnn}/renewvmess.sh"
wget -O renewvmessgrpc "https://${wisnuvpnn}/renewvmessgrpc.sh"
wget -O renewvmesshdua "https://${wisnuvpnn}/renewvmesshdua.sh"
wget -O renewvmesshttp "https://${wisnuvpnn}/renewvmesshttp.sh"
wget -O renewvlessxtls "https://${wisnuvpnn}/renewvlessxtls.sh"
wget -O renewvlesshttp "https://${wisnuvpnn}/renewvlesshttp.sh"
wget -O renewvlesshdua "https://${wisnuvpnn}/renewvlesshdua.sh"
wget -O renewxrayss "https://${wisnuvpnn}/renewxrayss.sh"
wget -O renewvless "https://${wisnuvpnn}/renewvless.sh"
wget -O renewvlessgrpc "https://${wisnuvpnn}/renewvlessgrpc.sh"
wget -O renewtrojan "https://${wisnuvpnn}/renewtrojan.sh"
wget -O renewxtlstrojan "https://${wisnuvpnn}/renewxtlstrojan.sh"
wget -O renewgrpctrojan "https://${wisnuvpnn}/renewgrpctrojan.sh"
wget -O renewtrojanwss "https://${wisnuvpnn}/renewtrojanwss.sh"
wget -O renewtrojanhdua "https://${wisnuvpnn}/renewtrojanhdua.sh"
wget -O renewtrojanhttp "https://${wisnuvpnn}/renewtrojanhttp.sh"
wget -O certv2ray "https://${wisnuvpnn}/certv2ray.sh"

wget -O addtrgo "https://${wisnuvpnnn}/addtrgo.sh"
wget -O deltrgo "https://${wisnuvpnnn}/deltrgo.sh"
wget -O renewtrgo "https://${wisnuvpnnn}/renewtrgo.sh"
wget -O cektrgo "https://${wisnuvpnnn}/cektrgo.sh"

wget -O trpcwsmenu "https://${wisnuvpnnnnn}/trpcwsmenu.sh"
wget -O sshovpnmenu "https://${wisnuvpnnnnn}/sshovpnmenu.sh"
#wget -O l2tpmenu "https://${wisnuvpnnnnn}/l2tpmenu.sh"
wget -O l2tppmenu "https://${wisnuvpnnnnn}/l2tppmenu.sh"
#wget -O pptpmenu "https://${wisnuvpnnnnn}/pptpmenu.sh"
#wget -O sstpmenu "https://${wisnuvpnnnnn}/sstpmenu.sh"
wget -O wgmenu "https://${wisnuvpnnnnn}/wgmenu.sh"
wget -O ssmenu "https://${wisnuvpnnnnn}/ssmenu.sh"
#wget -O ssrmenu "https://${wisnuvpnnnnn}/ssrmenu.sh"
wget -O vmessmenu "https://${wisnuvpnnnnn}/vmessmenu.sh"
wget -O vlessmenu "https://${wisnuvpnnnnn}/vlessmenu.sh"
#wget -O grpcmenu "https://${wisnuvpnnnnn}/grpcmenu.sh"
wget -O trghmenu "https://${wisnuvpnnnnn}/trghmenu.sh"
wget -O trxtmenu "https://${wisnuvpnnnnn}/trxtmenu.sh"
wget -O setmenu "https://${wisnuvpnnnnn}/setmenu.sh"
wget -O testermenu "https://${wisnuvpnnnnn}/testermenu.sh"
wget -O menu "https://${wisnuvpnnnnn}/menu.sh"
wget -O status "https://${wisnuvpnnnnn}/status.sh"
chmod +x testermenu
chmod +x ceknewtr
chmod +x addnewtr
chmod +x addxrayss
chmod +x addnewvmess
chmod +x addnewvless
chmod +x delnewtr
chmod +x delnewvmess
chmod +x addnewvless
chmod +x restart
chmod +x portdropbear
chmod +x portopenssh
chmod +x portstunnel5
chmod +x status
chmod +x portsshnontls
chmod +x portsshwstls
chmod +x menuu
chmod +x sshovpnmenu
#chmod +x l2tpmenu
chmod +x l2tppmenu
#chmod +x pptpmenu
#chmod +x sstpmenu
chmod +x wgmenu
chmod +x ssmenu

#chmod +x ssrmenu
chmod +x vmessmenu
chmod +x vlessmenu
#chmod +x grpcmenu
chmod +x trxtmenu
chmod +x trpcwsmenu
chmod +x setmenu
chmod +x trghmenu
chmod +x addhost
chmod +x menu
chmod +x addssh
chmod +x trialssh
chmod +x delssh
chmod +x member
chmod +x delexp
chmod +x cekssh
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about
chmod +x autokill
chmod +x tendang
chmod +x ceklim
chmod +x ram
chmod +x renewssh
chmod +x clearlog

chmod +x changeport
chmod +x portovpn
chmod +x portwg
chmod +x porttrojan
chmod +x porttrojango
chmod +x portgrpc
chmod +x portsstp
chmod +x portsquid
chmod +x portvlm

chmod +x wbmn
chmod +x xp
chmod +x swapkvm
chmod +x addvmess
chmod +x addvmessgrpc
chmod +x addvmesshdua
chmod +x addvmesshttp
chmod +x addvless
chmod +x addvlessgrpc
chmod +x addtrojan
chmod +x addvlesshttp
chmod +x addvlesshdua
chmod +x addvlessxtls
chmod +x addxrayss
chmod +x addxtlstrojan
chmod +x addgrpctrojan
chmod +x addtrojanwss
chmod +x addtrojanhttp
chmod +x addtrojanhdua
chmod +x renewxrayss

chmod +x cekxrayss
chmod +x delxrayss
chmod +x delvmess
chmod +x delvmessgrpc
chmod +x delvmesshdua
chmod +x delvmesshttp
chmod +x delvless
chmod +x delvlessgrpc
chmod +x delvlessxtls
chmod +x delxrayss
chmod +x deltrojan
chmod +x delvlesshttp
chmod +x delvlesshdua
chmod +x delxtlstrojan
chmod +x delgrpctrojan
chmod +x deltrojanwss
chmod +x deltrojanhttp
chmod +x deltrojanhdua

chmod +x renewvmess
chmod +x renewvmessgrpc
chmod +x renewvmesshdua
chmod +x renewvmesshttp
chmod +x renewvless
chmod +x renewvlesshdua
chmod +x renewvlessgrpc
chmod +x renewvlessxtls
chmod +x renewxrayss
chmod +x renewtrojan
chmod +x renewvlesshttp
chmod +x renewxtlstrojan
chmod +x renewgrpctrojan
chmod +x renewtrojanwss
chmod +x renewtrojanhttp
chmod +x renewtrojanhdua

chmod +x cekvmesshdua
chmod +x cekvmesshttp
chmod +x cekvlesshttp
chmod +x cekvlesshdua
chmod +x cekvmess
chmod +x cekvmessgrpc
chmod +x cekvless
chmod +x cekvlessgrpc
chmod +x cekvlessxtls
chmod +x cekxrayss
chmod +x cekxtlstrojan
chmod +x cekgrpctrojan
chmod +x cektrojanwss
chmod +x cektrojanhttp
chmod +x cektrojan
chmod +x cektrojanhdua

chmod +x certv2ray
chmod +x addtrgo
chmod +x deltrgo
chmod +x renewtrgo
chmod +x cektrgo

# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/sslh restart
/etc/init.d/stunnel5 restart
/etc/init.d/vnstat restart
#/etc/init.d/fail2ban restart
#/etc/init.d/squid restart

screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500
echo "0 5 * * * root clearlog && reboot" >> /etc/crontab
echo "0 0 * * * root xp" >> /etc/crontab
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh

# finishing
clear
