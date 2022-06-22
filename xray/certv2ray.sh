#!/bin/bash
echo start
sleep 0.5
source /var/lib/wisnucs/ipvps.conf
IP=$(cat 
domain=$IP
systemctl stop xtrojan
systemctl stop xray

sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill
##Generate acme certificate
curl https://get.acme.sh | sh
alias acme.sh=~/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d "${domain}" --standalone --keylength ec-256
/root/.acme.sh/acme.sh --install-cert -d "${domain}" --ecc \
--fullchain-file /etc/xray/xray.cer \
#--key-file /etc/xray/xray.key
#chown -R nobody:nogroup /etc/xray
#chmod 644 /etc/xray/xray.cer
#chmod 644 /etc/xray/xray.key
--fullchain-file /etc/ssl/private/fullchain.pem \
--key-file /etc/ssl/private/privkey.pem
chown -R nobody:nogroup /etc/xray
chmod 644 /etc/ssl/private/fullchain.pem
chmod 644 /etc/ssl/private/privkey.pem
systemctl start xray
systemctl start xtrojan
systemctl start xvless
systemctl restart xvmess
systemctl restart xss
systemctl restart satrio
echo Done
sleep 0.5
clear 
status
