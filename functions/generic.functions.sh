#!/bin/bash

###############################################################################################
# Complete ISPConfig setup script for Debian/Ubuntu Systems             					  					#
# Drew Clardy												                          	                              # 
# http://drewclardy.com				                                                          			#
# http://github.com/dclardy64/ISPConfig-3-Debian-Install                                      #
###############################################################################################


back_title="ISPConfig 3 System Installer"

questions (){

if ! check_package "whiptail"; then
	package_install whiptail
fi

while [ "x$serverIP" == "x" ]
do
serverIP=$(whiptail --title "Server IP" --backtitle "$back_title" --inputbox "Please specify a Server IP" --nocancel 10 50 3>&1 1>&2 2>&3)
done
while [ "x$HOSTNAMESHORT" == "x" ]
do
HOSTNAMESHORT=$(whiptail --title "Short Hostname" --backtitle "$back_title" --inputbox "Please specify a Short Hostname" --nocancel 10 50 3>&1 1>&2 2>&3)
done
while [ "x$HOSTNAMEFQDN" == "x" ]
do
HOSTNAMEFQDN=$(whiptail --title "Fully Qualified Hostname" --backtitle "$back_title" --inputbox "Please specify a Fully Qualified Hostname" --nocancel 10 50 3>&1 1>&2 2>&3)
done
if (whiptail --title "Install Web Server" --backtitle "$back_title" --yesno "Install Web Server?" 10 50) then
	install_web_server=Yes
	while [ "x$web_server" == "x" ]
	do
	web_server=$(whiptail --title "Web Server" --backtitle "$back_title" --nocancel --radiolist "Select Web Server Software" 10 50 2 "Apache" "(default)" ON "NginX" "" OFF 3>&1 1>&2 2>&3)
	done
	else
	install_web_server=No
fi
if (whiptail --title "Install Mail Server" --backtitle "$back_title" --yesno "Install Mail Server?" 10 50) then
	install_mail_server=Yes
	while [ "x$mail_server" == "x" ]
	do
	mail_server=$(whiptail --title "Mail Server" --backtitle "$back_title" --nocancel --radiolist "Select Mail Server Software" 10 50 2 "Dovecot" "(default)" ON "Courier" "" OFF 3>&1 1>&2 2>&3)
	done
	else
	install_mail_server=No
fi
while [ "x$sql_server" == "x" ]
do
sql_server=$(whiptail --title "SQL Server" --backtitle "$back_title" --nocancel --radiolist "Select SQL Server Software" 10 50 2 "MySQL" "(default)" ON "MariaDB" "" OFF 3>&1 1>&2 2>&3)
done
while [ "x$mysql_pass" == "x" ]
do
mysql_pass=$(whiptail --title "MySQL Root Password" --backtitle "$back_title" --inputbox "Please specify a MySQL Root Password" --nocancel 10 50 3>&1 1>&2 2>&3)
done
if (whiptail --title "Install FTP Server" --backtitle "$back_title" --yesno "Install FTP Server?" 10 50) then
	install_ftp_server=Yes
	else
	install_ftp_server=No
fi
if (whiptail --title "Install DNS Server" --backtitle "$back_title" --yesno "Install DNS Server?" 10 50) then
	install_dns_server=Yes
	else
	install_dns_server=No
fi
if (whiptail --title "Install Quota" --backtitle "$back_title" --yesno "Setup User Quotas?" 10 50) then
	quota=Yes
	else
	quota=No
fi
if (whiptail --title "Install Mailman" --backtitle "$back_title" --yesno "Setup Mailman?" 10 50) then
	mailman=Yes
	else
	mailman=No
fi
if (whiptail --title "Install Jailkit" --backtitle "$back_title" --yesno "Setup User Jailkits?" 10 50) then
	jailkit=Yes
	else
	jailkit=No
fi

}

install_Basic () {

#Set hostname and FQDN
sed -i "s/${serverIP}.*/${serverIP} ${HOSTNAMEFQDN} ${HOSTNAMESHORT}/" /etc/hosts
echo "$HOSTNAMESHORT" > /etc/hostname
/etc/init.d/hostname.sh start >/dev/null 2>&1

package_update
package_upgrade
package_install vim-nox dnsutils unzip rkhunter binutils sudo bzip2 zip

echo "dash dash/sh boolean false" | debconf-set-selections
dpkg-reconfigure -f noninteractive dash > /dev/null 2>&1

#Synchronize the System Clock
package_install ntp ntpdate

} # end function install_Basic

install_ISPConfig (){
	
#Install ISPConfig 3
cd /tmp
wget http://www.ispconfig.org/downloads/ISPConfig-3-stable.tar.gz
tar xfz ISPConfig-3-stable.tar.gz
cd /tmp/ispconfig3_install/install/
php -q install.php

} # end function install_ISPConfig


