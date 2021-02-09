# DarkVoid: A Weekly Blog on Void Linux for Nefarious uses.
## Episode 1 - Metasploit & Weaponization

I have enjoyed Linux for the better part of 20 years. However,
I have constantly distro hopped for the same amount of time. Void Linux
stopped my hopping. It is simple, elegant, and very powerful. Do one thing and
do it well; the UNIX philosophy.

Tools like Kali Linux are great, but in my opinion it is bloated, resource
hungry, and some of the tools are outdated (I'm looking at you, Python2.7!).
Not to mention distribution fragmentation. Who needs yet another distro? With
Void being a blank slate, We can shape it into anything we like. Today, We are
going to do just that: Weaponize Void Linux.

The Void Linux repositories have some tools, but not everything a modern
cyber criminal would need. The main being Metasploit. This guide will walk
you through installing and configuring Void Linux as a specialized pentest
operating system.

## Metasploit
  First let us start by installing the required dependencies. I am assuming
  this is going to be from a fresh Void installation, So if there are any
  programs you already have installed, go ahead and skip them. All of these
  commands should be ran as root aside from initializing the Metasploit
  database.

  Before we begin, it's always good to make sure you're fully updated.
  You can do this with
  > xbps-install -Syu

  Before we can install any additional programs, We should first install the
  base development software. We can accomplish this with the following command:
  > xbps-install -Syu base-devel

  This gives us the software needed to compile
  any source applications needed later on.

  Metasploit uses Postgresql as a database for its exploits and modules.
  Installation on Void Linux is fairly simple, This can be done by running
  > xbps-install -Syu postgresql postgresql-client

  Now that Postgresql is installed we need to enable the daemon to run as a
  service. Void Linux uses 'runit' as an init system, To start a new service all
  you need to do is create a symlink to a shell script that starts the service.
  To do this we need to issue the command
  > ln -s /etc/sv/postgresql /var/service/

  Start the service with:
  > sv start postgresql

  The next set of packages are specifically needed for Metasploit framework
  to run. You can install all of these packages by running the following:

  > xbps-install -Syu ruby-devel ruby-multi_xml zlib-devel libpqxx-devel gnupg \
  postgresql-libs-devel libpcap-devel sqlite-devel apr apr-devel apr-util \
  libuuid-devel readline libsvn libressl-devel libxslt-devel libyaml-devel \
  libffi-devel ncurses-devel readline-devel gdm-devel gdbm-devel db-devel nmap \
  git curl wget

  Before we clone the Metasploit repository and get to the main event, we should
  import the GPG keys for the ruby RVM program we will be using. You can See
  above that GnuPG is one of the applications installed. Using a GPG key is
  important as it ensures that the program you're downloading is authentic.
  You can import the keys with these commands:
  > curl -sSL https://rvm.io/mpapis.asc | gpg --import - \
  > curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - \
  > curl -L https://get.rvm.io | source /etc/profile.d/rvm.sh

  We are now ready for the actual installation of Metasploit! We will be
  cloning the Git repository in to the /opt/ directory. This is the typical
  directory for tools like this and where we will be installing most other
  tools in this blog. Change directories to /opt/ and clone the repo
  > git clone https://github.com/rapid7/metasploit-framework

  Once completed, CD into metasploit-framework and install the Ruby Gems.
  > bundle install

  After the bundler is done installing, as a non-root user, CD to the
  metasploit-framework directory and run 'msfdb init'. This will create the
  database locally. That's it! Metasploit is now installed on your Void Linux
  machine! You can add /opt/metasploit-framework to your $PATH or create
  symlinks to the binaries in /usr/local/bin or just run them with './'.

  If you plan to use this on pentesting sites like HackTheBox or TryHackMe,
  I would suggest installing openvpn as well. Next week I will go over
  installing fuzzers and ExploitDB.

  Copyright 2021 [0x29aNull](0x29a@null.net)
