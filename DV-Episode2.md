# DarkVoid: A Weekly Blog on Void Linux for Nefarious uses.
## Episode 2 - Fuzzers & ExploitDB
![](https://github.com/0x29aNull/DarkVoid/blob/main/DVLogo.png?raw=true)

Fuzzing is essential to pentesting. While there are many types of fuzzing
we will be focusing on web fuzzing. This is a technique where we use a piece
of software to scan hosts for files or directories. You give it a list of
files, services, directories, and a host name and it will try to connect to
them and outputs the results of what it has found. This would be a VERY tedious
and time consuming process without these programs.

I am using the MUSL based version of Void Linux and have found that some of the
older more traditional fuzzing applications (such as dirb) will not compile.
However, I have found faster replacements written in rust.

### Dirble

Dirble is a very fast Dirb replacement. Installing it is simple, and we
can achieve this by running the following

``` xbps-install -Syu rust cargo ``` \
``` git clone https://github.com/nccgroup/dirble ``` \
``` cd dirble & cargo build --release ```

Once the build has completed we need to make a new directory for the final
application. I typically keep files like this in /opt, So let's move Dirble there.

``` mkdir /opt/dirble & cp -r target/release/* /opt/dirble/ ```

You can now create a symlink to the binary in /usr/local/bin or add /opt/dirble to your $PATH.

### Gobuster & Wfuzz

Void Linux does have a few Fuzzers in its repositories. You can install them
with the following command..

``` xbps-install -Syu gobuster wfuzz ```

Using fuzzers typically requires wordlists, There are many on the internet
and I highly recommend [SecLists](https://github.com/danielmiessler/SecLists) by Daniel Miessler\
and the [RockYou](https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt) list.
Aside from premade wordlists, The best way to use fuzzers is to use short specialized lists that
you create based off of your target.

### Cewl
Cewl is a spider program that takes a URL and compiles a wordlist. It crawls the URL and all associated
links then outputs a unique wordlist that can be used in fuzzers, password cracking utilities such as john,
and other such tools. Cewl is a ruby application, so if you followed my [Episode 1](https://github.com/0x29aNull/DarkVoid/blob/main/DV-Episode1.md) you will have most of the required dependencies installed.

Let's start by cloning the repository in to our home directory
``` git clone https://github.com/digininja/cewl ```

Now CD into the Cewl directory that we've just cloned and start let's start by updating our ruby bundler \
``` bundler update --bundler ```

After bundler has updated we can install the required Gems and then create a new directory in /opt to
house our new executable and create a shell script to launch Cewl with 1 command.\
``` bundle install ``` \
``` mkdir /opt/cewl ``` \
``` cp *.rb /opt/cewl ``` \
``` cat << EOF >> /usr/local/bin/cewl ```
``` #!/bin/bash ``` \
``` ruby -W0 /opt/cewl ``` \
``` EOF ``` \
``` chmod +x /usr/local/bin/cewl ```

Now we have 3 very powerful fuzzers installed on our machine and a way to generate wordlists to use with them.

### ExploitDB
Metasploit is an amazing tool but it doesn't have everything. For these times it's good to have a quick way to look up and download exploits.. Enter ExploitDB. This tool searches and pulls exploits from the (Exploit-DB)[https://www.exploit-db.com] website. Before we can install this tool we need to install a few required packages.

``` xbps-install -Syu python3 python3-devel python3-pip ```

Now CD to /opt and clone the repository and link the binary to /usr/local/bin \
``` git clone https://github.com/offensive-security/exploitdb ```
``` ln -s /opt/exploitdb/searchsploit
