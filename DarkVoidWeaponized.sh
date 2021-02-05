#!/bin/bash

dvdeps() {
	printf "\n[-] Installing Dependencies\n"
	xbps-install -Syu base-devel postgresql postgresql-client ruby-devel \
	ruby-multi_xml zlib-devel libpqxx-devel postgresql-libs-devel \
	libpcap-devel sqlite-devel apr apr-devel apr-util libuuid-devel \
	readline libsvn libressl-devel libxslt-devel libyaml-devel \
	libffi-devel ncurses-devel readline-devel gdm-devel gdbm-devel \
	db-devel libnet-devel glib-devel bettercap nmap arpfox dnsmasq \
	gnupg proxychains-ng openjdk-jre sqlmap termshark openvpn \
	openconnect aircrack-ng john reaver hxctools hashcat \
	hashcat-utils python3-devel python3-pip ettercap thc-hydra \
	kismet rust cargo gobuster wfuzz 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%500==0) print "+"}'
}

mainmsf() {
	URL=https://github.com/rapid7/metasploit-framework/archive/master.zip
	TMP=/tmp/DarkVoid
	MSFDIR=/opt/metasploit-framework/
  mkdir $TMP
	cd $TMP
	printf "[-] Downloading Metasploit\n"
	wget --progress=dot "$URL" 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
	printf "\n[-] Extracting Metasploit\n"
	unzip master.zip -d $TMP | awk 'BEGIN {ORS=" "} {if(NR%350==0) print "+"}'
	printf "\n[-] Creating Directories & Installing Dependencies\n"
	mkdir /opt/metasploit-framework
	cp -r $TMP/metasploit-framework-master/* $MSFDIR
	cd ~
	gem install bundler 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
	curl -sSL https://rvm.io/mpapis.asc > /dev/null 2>&1 | gpg --import - > /dev/null 2>&1
	curl -sSL https://rvm.io/pkuczynski.asc > /dev/null 2>&1 | gpg --import - > /dev/null 2>&1
	curl -L https://get.rvm.io > /dev/null 2>&1 | bash -s stable > /dev/null 2>&1
	source /etc/profile.d/rvm.sh > /dev/null 2>&1
	cd $MSFDIR
	bundle install 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
	printf "\n[-] Cleaning up.."
	rm -rf $TMP/metasploit-framework-master/
	rm -rf $TMP/master.zip
	printf "\n"
}

if [[ $EUID -ne 0 ]]; then
	printf "\n"
	printf "\n[!] This script must be ran as root"
	printf "\n[-] Exiting..\n"
	exit 1
fi

read -n1 -s -r -p "Install Metasploit?: " key
if [ "$key" = "n" ]; then exit
elif [ "$key" = "y" ]; then dvdeps
fi
