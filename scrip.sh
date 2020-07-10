#!/bin/bash
# ******************************************
# Program: Autoscript Setup VPS 2019
# Developer: BangJack
# Nickname: jack
# Modify : @JackDotMy 
# Date: 04-01-2015
# Last Updated: 19-11-2019
# ******************************************
# START SCRIPT ( POWERJACK )
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;
if [ $USER != 'root' ]; then
echo "Sorry, for run the script please using root user"
exit 1
fi
if [[ "$EUID" -ne 0 ]]; then
echo "Sorry, you need to run this as root"
exit 2
fi
if [[ ! -e /dev/net/tun ]]; then
echo "TUN is not available"
exit 3
fi
echo "
AUTOSCRIPT BY POWERJACK

PLEASE CANCEL ALL PACKAGE POPUP

TAKE NOTE !!!"
clear
echo "START AUTOSCRIPT"
clear
echo "SET TIMEZONE KUALA LUMPUT GMT +8"
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;
clear
echo "
ENABLE IPV4 AND IPV6

COMPLETE 1%
"
echo ipv4 >> /etc/modules
echo ipv6 >> /etc/modules
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf
sysctl -p
clear
echo "
REMOVE SPAM PACKAGE

COMPLETE 10%
"
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove postfix*;
apt-get -y --purge remove bind*;
clear
echo "
UPDATE AND UPGRADE PROCESS

PLEASE WAIT TAKE TIME 1-5 MINUTE
"
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -
apt-get update;
apt-get -y autoremove;
apt-get -y install wget curl;
echo "
INSTALLER PROCESS PLEASE WAIT

TAKE TIME 5-10 MINUTE
"
# script
wget -O /usr/local/bin/menu "https://ghostjack.net/script/menu"
wget -O /usr/local/bin/m "https://ghostjack.net/script/menu"
wget -O /usr/local/bin/autokill "https://ghostjack.net/script/autokill"
wget -O /usr/local/bin/user-generate "https://ghostjack.net/script/user-generate"
wget -O /usr/local/bin/speedtest "https://ghostjack.net/script/speedtest"
wget -O /usr/local/bin/user-lock "https://ghostjack.net/script/user-lock"
wget -O /usr/local/bin/user-unlock "https://ghostjack.net/script/user-unlock"
wget -O /usr/local/bin/auto-reboot "https://ghostjack.net/script/auto-reboot"
wget -O /usr/local/bin/user-password "https://ghostjack.net/script/user-password"
wget -O /usr/local/bin/trial "https://ghostjack.net/script/trial"
wget -O /etc/pam.d/common-password "https://ghostjack.net/script/common-password"
chmod +x /etc/pam.d/common-password
chmod +x /usr/local/bin/menu
chmod +x /usr/local/bin/m
chmod +x /usr/local/bin/autokill 
chmod +x /usr/local/bin/user-generate 
chmod +x /usr/local/bin/speedtest 
chmod +x /usr/local/bin/user-unlock
chmod +x /usr/local/bin/user-lock
chmod +x /usr/local/bin/auto-reboot
chmod +x /usr/local/bin/user-password
chmod +x /usr/local/bin/trial
# fail2ban & exim & protection
apt-get install -y grepcidr
apt-get -y install fail2ban sysv-rc-conf dnsutils dsniff zip unzip;
wget https://github.com/jgmdev/ddos-deflate/archive/master.zip;unzip master.zip;
cd ddos-deflate-master && ./install.sh
service exim4 stop;sysv-rc-conf exim4 off;
# webmin
apt-get -y install webmin
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
# ssh
sed -i 's/#Banner/Banner/g' /etc/ssh/sshd_config
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
wget -O /etc/issue.net "https://ghostjack.net/script/banner"
# dropbear
apt-get -y install dropbear
wget -O /etc/default/dropbear "https://ghostjack.net/script/dropbear"
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
# squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://ghostjack.net/script/squid.conf"
wget -O /etc/squid/squid.conf "https://ghostjack.net/script/squid.conf"
sed -i "s/ipserver/$myip/g" /etc/squid3/squid.conf
sed -i "s/ipserver/$myip/g" /etc/squid/squid.conf
# openvpn
apt-get -y install openvpn
cd /etc/openvpn/
wget https://ghostjack.net/script/openvpn.tar;tar xf openvpn.tar;rm openvpn.tar
wget -O /etc/rc.local "https://ghostjack.net/script/rc.local"
chmod +x /etc/rc.local
#wget -O /etc/iptables.up.rules "https://ghostjack.net/script/iptables.up.rules"
#sed -i "s/ipserver/$myip/g" /etc/iptables.up.rules
#iptables-restore < /etc/iptables.up.rules
# Badvpn
echo "#!/bin/bash
if [ "'$1'" == start ]
then
badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10 > /dev/null &
echo 'Badvpn Run On Port 7300'
fi
if [ "'$1'" == stop ]
then
badvpnpid="'$(ps x |grep badvpn |grep -v grep |awk '"{'"'print $1'"'})
kill -9 "'"$badvpnpid" >/dev/null 2>/dev/null
kill $badvpnpid > /dev/null 2> /dev/null
kill "$badvpnpid" > /dev/null 2>/dev/null''
kill $(ps x |grep badvpn |grep -v grep |awk '"{'"'print $1'"'})
killall badvpn-udpgw
fi" > /bin/badvpn
chmod +x /bin/badvpn
if [ -f /usr/local/bin/badvpn-udpgw ]; then
echo -e "\033[1;32mBadvpn Installing\033[0m"
exit
else
clear
fi
if [ -f /usr/bin/badvpn-udpgw ]; then
echo -e "\033[1;32mBadvpn Installing\033[0m"
exit
else
clear
fi
echo -e "\033[1;31m           Installing Badvpn\n\033[1;37mInstalling gcc Cmake make g++ openssl etc...\033[0m"
apt-get update >/dev/null 2>/dev/null
apt-get install -y nano >/dev/null 2>/dev/null
apt-get install -y sudo >/dev/null 2>/dev/null
apt-get install -y gcc >/dev/null 2>/dev/null
apt-get install -y make >/dev/null 2>/dev/null
apt-get install -y g++ >/dev/null 2>/dev/null
apt-get install -y openssl >/dev/null 2>/dev/null
apt-get install -y build-essential >/dev/null 2>/dev/null
apt-get install -y cmake >/dev/null 2>/dev/null
echo -e "\033[1;37mDownloading File Badvpn"; cd
wget https://ghostjack.net/script/badvpn-1.999.128.tar.bz2 -o /dev/null
echo -e "Extract Badvpn"
tar -xf badvpn-1.999.128.tar.bz2
echo -e "Setup configuration"
mkdir /etc/badvpn-install
cd /etc/badvpn-install
cmake ~/badvpn-1.999.128 -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1 >/dev/null 2>/dev/null
echo -e "Compile Badvpn\033[0m"
make install
clear
echo -e "\033[1;32m             Installation Complete\033[0m" 
echo -e "\033[1;37mCommand:\n\033[1;31mbadvpn start\033[1;37m Run Badvpn Service"
echo -e "\033[1;31mbadvpn stop \033[1;37m Stop Badvpn Service\033[0m"
rm -rf /etc/badvpn-install
cd ; rm -rf badvpn.sh badvpn-1.999.128/ badvpn-1.999.128.tar.bz2 >/dev/null 2>/dev/null
# Stunnel
apt-get install stunnel4 -y
wget -P /etc/stunnel/ "https://ghostjack.net/script/stunnel.conf"
openssl genrsa -out key.pem 2048
wget -P /etc/stunnel/ "https://ghostjack.net/script/stunnel.pem"
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
# nginx
apt-get -y install nginx php5-fpm php5-cli libexpat1-dev libxml-parser-perl
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://ghostjack.net/script/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>SETUP BY JACK PM +60176777798</pre>" > /home/vps/public_html/index.php
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "https://ghostjack.net/script/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
# install vnstat gui
apt-get install vnstat
cd /home/vps/public_html/
wget http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/eth0/venet0/g" config.php
sed -i "s/\$iface_list = array('venet0', 'sixxs');/\$iface_list = array('venet0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i "s/Internal/Internet/g" config.php
sed -i "/SixXS IPv6/d" config.php
service vnstat restart
#fix webserver
sudo apt update
sudo apt install apache2
# etc
wget -O /var/www/html/client.ovpn "https://ghostjack.net/script/client.ovpn"
wget -O /etc/motd "https://ghostjack.net/script/motd"
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
sed -i 's/1194/443/g' /etc/openvpn/server.conf
sed -i '$ i\port-share 0.0.0.0 444' /etc/openvpn/server.conf
sed -i "s/ipserver/$myip/g" /var/www/html/client.ovpn
useradd -m -g users -s /bin/bash jack
echo "ghost123:ghost123" | chpasswd
echo "UPDATE AND INSTALL COMPLETE COMPLETE 99% BE PATIENT"
rm *.sh;rm *.txt;rm *.tar;rm *.deb;rm *.asc;rm *.zip;rm ddos*;
clear
# freeradius
apt-get -y install freeradius
cat /dev/null > /etc/freeradius/users
echo "jack Cleartext-Password := jack" > /etc/freeradius/users
# Lock Dropbear Expired ID
wget -O /usr/local/bin/lockidexp.sh "https://ghostjack.net/script/lockidexp.sh"
chmod +x /usr/local/bin/lockidexp.sh
crontab -l > mycron
echo "1 8 * * * /usr/local/bin/lockidexp.sh" >> mycron
crontab mycron
rm mycron
# BlockTorrent
wget -O /usr/local/bin/BlockTorrentEveryReboot "https://ghostjack.net/script/BlockTorrentEveryReboot"
chmod +x /usr/local/bin/BlockTorrentEveryReboot
crontab -l > mycron
echo "@reboot /usr/local/bin/BlockTorrentEveryReboot" >> mycron
crontab mycron
rm mycron

# restart service
badvpn start
service stunnel4 restart
service ssh restart
service openvpn restart
service dropbear restart
service nginx restart
service php5-fpm restart
service webmin restart
service squid3 restart
service fail2ban restart
service freeradius restart
clear
# softether
apt install build-essential -y;
cd && wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.28-9669-beta/softether-vpnserver-v4.28-9669-beta-2018.09.11-linux-x64-64bit.tar.gz
tar xzf softether-vpnserver-v4.28-9669-beta-2018.09.11-linux-x64-64bit.tar.gz
clear
echo  -e "\033[31;7mNOTE: ANSWER 1 AND ENTER THREE TIMES FOR THE COMPILATION TO PROCEED\033[0m"
cd vpnserver && make && ./vpnserver start
mkdir /usr/local/vpnserver/
cd && mv vpnserver /usr/local && cd /usr/local/vpnserver/ && chmod 600 * && chmod 700 vpnserver && chmod 700 vpncmd
crontab -l > mycron
echo "@reboot /usr/local/vpnserver/vpnserver start" >> mycron
crontab mycron
rm mycron
/usr/local/vpnserver/vpnserver start
clear
# END SCRIPT 
echo "========================================"  | tee -a log-install.txt
echo "Service Autoscript VPS (GHOSTJACK)"  | tee -a log-install.txt
echo "----------------------------------------"  | tee -a log-install.txt
echo "POWER BY GHOSTJACK CALL +601161604107"  | tee -a log-install.txt
echo "nginx : http://$myip:80"   | tee -a log-install.txt
echo "Webmin : http://$myip:10000/"  | tee -a log-install.txt
echo "OpenVPN  : TCP 443 (client config : http://$myip/client.ovpn)"  | tee -a log-install.txt
echo "Badvpn UDPGW : 7300"   | tee -a log-install.txt
echo "Stunnel SSL/TLS : 442"   | tee -a log-install.txt
echo "Squid3 : 3128,3129,8080,8000,9999"  | tee -a log-install.txt
echo "OpenSSH : 22"  | tee -a log-install.txt
echo "Dropbear : 443,444"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt
echo "AntiDDOS : [on]"  | tee -a log-install.txt
echo "Modify(@GHOSTJACK)AntiTorrent : [on]"  | tee -a log-install.txt
echo "Timezone : Asia/Kuala_Lumpur"  | tee -a log-install.txt
echo "Menu : type menu to check menu script"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "RADIUS Authentication Settings:"  | tee -a log-install.txt
echo "Radius Server Hostname: 127.0.0.1"  | tee -a log-install.txt
echo "Radius Port: 1812 (UDP)"  | tee -a log-install.txt
echo "Shared Secret: testing123"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "SoftEtherVPN Port: 8888"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "----------------------------------------"
echo "LOG INSTALL  --> /root/log-install.txt"
echo "----------------------------------------"
echo "========================================"  | tee -a log-install.txt
echo "      PLEASE REBOOT TAKE EFFECT !"
echo "========================================"  | tee -a log-install.txt
cat /dev/null > ~/.bash_history && history -c