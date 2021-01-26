#!/bin/bash
echo "                                                         ,,        ,,"
echo "`7MM"""Yb.                   `7MM   `7MMF'   `7MF'       db      `7MM"
echo "  MM    `Yb.                   MM     `MA     ,V                   MM"
echo "  MM     `Mb  ,6"Yb.  `7Mb,od8 MM  ,MP'VM:   ,V ,pW"Wq.`7MM   ,M""bMM"
echo "  MM      MM 8)   MM    MM' "' MM ;Y    MM.  M'6W'   `Wb MM ,AP    MM"
echo "  MM     ,MP  ,pm9MM    MM     MM;Mm    `MM A' 8M     M8 MM 8MI    MM"
echo "  MM    ,dP' 8M   MM    MM     MM `Mb.   :MM;  YA.   ,A9 MM `Mb    MM"
echo ".JMMmmmdP'   `Moo9^Yo..JMML. .JMML. YA.   VF    `Ybmd9'.JMML.`Wbmd"MML."
echo "-----------------------------------------------------------------------"
echo "                          0x29a@null.net                               "
echo "               ...Distro fragmentation is for chumps...                "
echo "                                                                       "

if [[ $EUID -ne 0 ]]; then
  echo "DarkVoid must be ran as root!"
  exit 1
fi

xbps-install -S postgresql postgresql-client ruby ruby-devel \
ruby-multi_xml zlib-devel libpqxx-devel postgresql-libs-devel \
libpcap-devel sqlite-devel apr apr-devel apr-util libuuid-devel \
readline libsvn libressl-devel libxslt-devel libyaml-devel \
libffi-devel ncurses-devel readline-devel gdm-devel gdbm-devel \
db-devel libnet-devel glib-devel bettercap nmap arpfox dnsmasq \
gnupg proxychains-ng openjdk-jre sqlmap termshark openvpn \
openconnect aircrack-ng john reaver hxctools hashcat \
hashcat-utils python3-devel python3-pip ettercap thc-hydra \
kismet rust cargo gobuster wfuzz

# Metasploit Install
gem install bundler
mkdir ~/tmp
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
cd ~/tmp
git clone https://github.com/rapid7/metasploit-framework.git
cd metasploit-framework
bundle install
mv metasploit-framework/ /opt/

# Nikto Install
cd ~/tmp
git clone https://github.com/sullo/nikto
mkdir /opt/nikto
cp -r ~/nikto/program/* /opt/nikto
ln -s /opt/nikto/nikto.pl /usr/bin/nikto

# Wordlists Download
mkdir /usr/share/wordlists
cd ~/tmp
git clone https://github.com/danielmiessler/SecLists


# Cewl Install
cd ~/tmp
git clone https://github.com/digininja/cewl
cd cewl
bundle update --bundler
bundle install
mkdir /opt/cewl
cp *.rb /opt/cewl
cd ~/tmp
rm -rf cewl/
cat << EOF >> cewl
#!/bin/bash
ruby -W0 /opt/cewl
EOF
chmod +x cewl
mv cewl /usr/bin

# Dirble Install
cd ~/tmp
git clone https://github.com/nccgroup/dirble
cd dirble
cargo build --release
mkdir /opt/dirble
cd target/release/
cp -r ./* /opt/dirble
ln -s /opt/dirble/target/release/dirble /usr/bin/
cd ~/tmp

# RustScan Install
git clone https://github.com/RustScan/RustScan
cd RustScan
cargo build --release
mkdir /opt/rustscan
cd target/release/
cp -r ./* /opt/rustscan
ln -s /opt/rustscan/rustscan /usr/bin

# Searchsploit Install
cd ~/tmp
git clone https://github.com/offensive-security/exploitdb
mv exploitdb/ /opt/
ln -s /opt/exploitdb/searchsploit /usr/bin/

# Routersploit Install
cd ~/tmp
git clone https://github.com/threat9/routersploit
cd routersploit
python3 -m pip install -r requirements.txt
cd ..
mv routersploit /opt/
cat << EOF >> rsf
#!/bin/bash
python3 /opt/routersploit/rsf.py
EOF
chmod +x rsf
mv rsf /usr/bin

echo DarkVoid has been installed.
echo Cleaning Up...
rm -rf ~/tmp
