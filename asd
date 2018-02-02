#!/bin/bash

if [ $USER != 'root' ]; then
	echo "Anda harus menjalankan ini sebagai root"
	exit
fi

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;

if [[ -e /etc/debian_version ]]; then
	#OS=debian
	RCLOCAL='/etc/rc.local'
else
	echo "Anda tidak menjalankan script ini pada OS Debian"
	exit
fi

# go to root
cd

MYIP=$(wget -qO- ipv4.icanhazip.com);



#https://github.com/adenvt/OcsPanels/wiki/tutor-debian

clear
echo ""
echo "Saya perlu bertanya beberapa soalan sebelum memulakan setup"
echo "Anda boleh membiarkan pilihan default dan hanya tekan enter jika Anda setuju dengan pilihan tersebut"
echo ""
echo "Pertama saya perlu tahu password baru user root MySQL:"
read -p "Password baru: " -e -i pyka1234 DatabasePass
echo ""
echo "Terakhir, sebutkan Nama Database untuk OCS Panels"
echo "Sila gunakan satu kata saja, tiada karakter khusus selain Underscore (_)"
read -p "Nama Database: " -e -i OCS_PANEL DatabaseName
echo ""
echo "Okey, OCS Panel anda bersedia untuk di Install"
read -n1 -r -p "Tekan sebarang keyword untuk memulakan..."

#apt-get update
apt-get update -y
apt-get install build-essential expect -y
apt-get install -y mysql-server

#mysql_secure_installation
so1=$(expect -c "
spawn mysql_secure_installation; sleep 3
expect \"\";  sleep 3; send \"\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect eof; ")
echo "$so1"
#\r
#Y
#pass
#pass
#Y
#Y
#Y
#Y

chown -R mysql:mysql /var/lib/mysql/
chmod -R 755 /var/lib/mysql/

apt-get install -y nginx php5 php5-fpm php5-cli php5-mysql php5-mcrypt

rm /etc/nginx/sites-enabled/default && rm /etc/nginx/sites-available/default
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
mv /etc/nginx/conf.d/vps.conf /etc/nginx/conf.d/vps.conf.backup
wget -O /etc/nginx/nginx.conf "https://github.com/SSL3/FluxoScript/raw/master/nginx.conf"
wget -O /etc/nginx/conf.d/vps.conf "https://github.com/SSL3/FluxoScript/raw/master/vps.conf/vps.conf"
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf

useradd -m vps && mkdir -p /home/vps/public_html
rm /home/vps/public_html/index.html && echo "" > /home/vps/public_html/info.php
chown -R www-data:www-data /home/vps/public_html && chmod -R g+rw /home/vps/public_html
service php5-fpm restart && service nginx restart

apt-get -y install zip unzip
cd /home/vps/public_html
wget http://borneobesthosting.me/autoscripts-vps/Debian7/OrangKuatSabah.zip
unzip OrangKuatSabah.zip
chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html

chmod 777 /home/vps/public_html/config
chmod 777 /home/vps/public_html/config/inc.php
chmod 777 /home/vps/public_html/config/route.php

#mysql -u root -p
so2=$(expect -c "
spawn mysql -u root -p; sleep 3
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"CREATE DATABASE IF NOT EXISTS $DatabaseName;EXIT;\r\"
expect eof; ")
echo "$so2"
#pass
#CREATE DATABASE IF NOT EXISTS OCS_PANEL;EXIT;


clear
echo "Buka Browser, akses alamat http://$MYIP:81/ dan lengkapi data2 seperti dibawah ini!"
echo "Database:"
echo "- Database Host: localhost"
echo "- Database Name: $DatabaseName"
echo "- Database User: root"
echo "- Database Pass: $DatabasePass"
echo ""
echo "Admin Login:"
echo "- Username: sesuai keinginan"
echo "- Password Baru: sesuai keinginan"
echo "- Masukkan Ulang Password Baru: sesuai keinginan"
echo ""
echo "Klik Install dan tunggu proses selesai, kembali lagi ke terminal dan kemudian tekan [ENTER]!"
sleep 3
echo ""
read -p "Jika Step diatas sudah dilakukan, sila tekan [Enter] untuk melanjutkan..."
echo ""
read -p "Jika anda benar-benar yakin Step diatas sudah dilakukan, sila tekan [Enter] untuk melanjutkan..."
echo ""

#rm -R /home/vps/public_html/installation
#apt-get -y --force-yes -f install libxml-parser-perl

apt-get -y --force-yes -f install libxml-parser-perl
echo "unset HISTFILE" >> /etc/profile

chmod 777 /home/vps/public_html/config
chmod 777 /home/vps/public_html/config/inc.php
chmod 777 /home/vps/public_html/config/route.php

# info
clear
echo "=======================================================" | tee -a log-install.txt
echo "Sila login Panel Reseller di http://$MYIP:81" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "Auto Script Installer OCS Panels | Budak Sabah Terkini"  | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "Thanks " | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "Log Instalasi --> /root/log-install.txt" | tee -a log-install.txt
echo "=======================================================" | tee -a log-install.txt
cd ~/
