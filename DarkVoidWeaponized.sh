#!/bin/bash

TMP=/tmp/DarkVoid
BINDIR=/usr/local/bin/

dvdeps() {
	printf "\n[-] Installing Dependencies\n"
	xbps-install -Syu base-devel postgresql postgresql-client ruby-devel \
	ruby-multi_xml zlib-devel libpqxx-devel postgresql-libs-devel \
	libpcap-devel sqlite-devel apr apr-devel apr-util libuuid-devel \
	readline libsvn libressl-devel libxslt-devel libyaml-devel \
	libffi-devel ncurses-devel readline-devel gdm-devel gdbm-devel \
	db-devel libnet-devel glib-devel bettercap nmap arpfox dnsmasq \
	gnupg proxychains-ng openjdk-jre sqlmap termshark openvpn \
	openconnect aircrack-ng john reaver hcxtools hashcat \
	hashcat-utils python3-devel python3-pip ettercap thc-hydra \
	kismet rust cargo gobuster wfuzz black pyqt5 openbsd-netcat \
	2>&1 | awk 'BEGIN {ORS=" "} {if(NR%260==0) print "+"}'
}

wordlists() {
	printf "\n[-] Creating Directories\n"
	LISTDIR=/usr/share/wordlists
	SECLISTS=https://github.com/danielmiessler/SecLists
	ROCKYOU=https://github.com/praetorian-inc/Hob0Rules/raw/master/wordlists/rockyou.txt.gz
	WRDCTL=https://github.com/BlackArch/wordlistctl
	mkdir $LISTDIR
	cd "$TMP"
	printf "\n[-] Downloading SecLists\n"
	git clone "$SECLISTS" 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%260==0) print "+"}'
	mv SecLists/ "$LISTDIR"
	printf "\n[-] Downloading RockYou\n"
	wget --progress=dot "$ROCKYOU" 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
	gunzip -c rockyou.txt.gz > /usr/share/wordlists
	printf "\n[-] Downloading Wordlistctl\n"
	cd /opt/
	git clone "$WRDCTL" 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%260==0) print "+"}'
	cd wordlistctl
	pip install -r requirements.txt
	cd "$TMP"
	cat << EOF >> wordlistctl
	#!/bin/bash
	python3 /opt/wordlistctl/wordlistctl.py
	EOF
	chmod +x wordlistctl
	mv wordlistctl "$BINDIR"
}

cewl() {
	CEWLURL=https://github.com/digininja/cewl
	CEWLDIR=/opt/cewl
	cd $TMP
	printf "\n[-] Downloading Cewl"
	git clone "$CEWLURL" 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
	cd cewl
	printf "\n[-] Updating Bundler"
	bundle update --bundler 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
	printf "\n[-] Installing Cewl Gems"
	bundle install 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
	mkdir "$CEWLDIR"
	cp *.rb /opt/cewl
	cd ~/tmp
	rm -rf cewl/
	cat << EOF >> cewl
	#!/bin/bash
	ruby -W0 /opt/cewl
	EOF
	chmod +x cewl
	mv cewl "$BINDIR"
}

nikto() {
	NIKGIT=https://github.com/sullo/nikto
	NIKDIR=/opt/nikto
	cd "$TMP"
	printf "\n[-] Downloading Nikto"
	git clone "$NIKGIT" 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
	mkdir "$NIKDIR"
	printf "\n[-] Installing Nikto"
	cp -r "$TMP"/nikto/program/* "$NIKDIR"
	ln -s "$NIKDIR"/nikto.pl "$BINDIR"/nikto
}

dirble() {
	DIRBURL=https://github.com/nccgroup/dirble
	DIRBDIR=/opt/dirble/
	cd "$TMP"
	printf "\n[-] Downloading Dirble"
	git clone "$DIRBURL" 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
	cd dirble
	printf "\n[-] Building Dirble"
	cargo build --release 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
	mkdir "$DIRBDIR"
	printf "\n[-] Installing Dirble"
	cd target/release/
	cp -r ./* "$DIRBDIR" 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
	ln -s /opt/dirble/target/release/dirble "$BINDIR"
}

exploitdb() {
	EDBURL=https://github.com/offensive-security/exploitdb
	cd /opt/
	printf "\n[-] Downloading ExploitDB"
	git clone "$EDBURL" 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
	printf "\n[-] Installing ExploitDB"
	ln -s /opt/exploitdb/searchsploit "$BINDIR"
}

msf() {
	cd $TMP
	printf "\n[-] Downloading Metasploit\n"
	wget --progress=dot "$MSFURL" 2>&1 | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
	printf "\n[-] Extracting Metasploit\n"
	unzip master.zip -d $TMP | awk 'BEGIN {ORS=" "} {if(NR%350==0) print "+"}'
	printf "\n[-] Creating Directories\n"
	mkdir "$MSFDIR"
	cp -r $TMP/metasploit-framework-master/* $MSFDIR
	printf "\n[-] Installing Ruby Gems\n"
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
	printf "\n[-] Linking and starting Postgresql Service\n"
	ln -s /etc/sv/postgresql /var/service
	sv enable postgresql & sv start postgresql
	printf "\n[-] Linking binaries"
	ln -s "$MSFDIR"/msfdb "$BINDIR"
	ln -s "$MSFDIR"/msfconsole "$BINDIR"
	ln -s "$MSFDIR"/msfvenom "$BINDIR"
	printf "\n[!] Run 'msfdb init' as a non-root user\n"
}

if [[ $EUID -ne 0 ]]; then
	printf "\n"
	printf "\n[!] This script must be ran as root"
	printf "\n[-] Exiting..\n"
	exit 1
fi

if [ ! -f $UNZIP ]; then
	printf "\n[-] Unzip Not Found, Installing"
	xbps-install -Syu unzip 2>1& | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'
fi

if [ ! -f $GIT ]; then
	printf "\n[-] Git Not Found, Installing"
	xbps-install -Syu git 2>1& | awk 'BEGIN {ORS=" "} {if(NR%50==0) print "+"}'

read -n1 -s -r -p "Install Metasploit?: " key
if [ "$key" = "n" ]; then exit
elif [ "$key" = "y" ]; then main
fi

main() {
	msf
	nikto
	dirble
	exploitdb
	cewl
	wordlists
}
