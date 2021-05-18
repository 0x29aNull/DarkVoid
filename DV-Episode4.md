# DarkVoid: A Weekly Blog on Void Linux for Nefarious uses.

## Episode 4 - Burpsuite, Web Applications & Databases

![](https://github.com/0x29aNull/DarkVoid/blob/main/DVLogo.png?raw=true)

Web applications can be one of the weakest parts on a website. The tools we're going to be installing will allow us to test these applications for security flaws and vulnerabilities. Databases are what we're after when we try to 'break' these applications in most cases. They contain everything from usernames to passwords to PII (Personally Identifying Information). Luckily, we have tools for this too. Let's dive in to it.



## Prerequisites

Before we can install any of the following applications we need a few things. First and foremost is Void Linux. This tutorial will probably work for just about any Linux distro but why would you run anything other than Void? The second is XWindows. We're going to need to be able to use graphical applications. 



### BurpSuite

BurpSuite is one of the best applications for monitoring website traffic and analyzing web applications. You can fuzz,  Alter and re-send data, and so much more. For 

First we need to download BurpSuite Community Edition in the standalone .jar format. Open your browser and go to

````https://portswigger.net/burp/communitydownload```` click download, and in the second drop down menu select JAR. Portswigger has a Linux shell script installer however, I have not been able to make this work on Void. After we've downloaded the java binary we need to install OpenJDK11 to run it and create a shell script so that we can run the application with one command.



````xbps-install -Su openjdk11````

````mv burp*.jar /opt/burpsuite.jar````

````cat << EOF > burpsuite````

````#!/bin/sh````\

````Java -jar /opt/burpsuite.jar````

````EOF````

````mv burpsuite /usr/local/bin````

````chmod +x /usr/local/bin/burpsuite````

Now that we have burpsuite installed we will need some other tools such as sqlmap, sqlninja, and wpscan. Only one of these applications is in the Void repos so let's install that and download the others. WPScan is a WordPress scanner written in Ruby, If you've followed my [first episode](https://github.com/0x29aNull/DarkVoid/blob/main/DV-Episode1.md) you should already have most of the required packages. Sqlmap is just as its name implies, an SQL database scanner and tester. Sqlninja is essentially the same thing, but one may be able to find things the other may not. Before we install, if you already have Ruby with RVM installed, skip lines 3 - 5.

````sudo xbps-install -Su ruby-multi_xml zlib-devel gnupg````

````cd /opt/ && sudo git clone https://github.com/wpscanteam/wpscan````

````curl -sSL https://rvm.io/mpapis.asc | gpg --import -````

````curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -````

````curl -L https://get.rvm.io | sudo source /etc/profile.d/rvm.sh````

````cd wpscan && bundle install````

````gem install wpscan````

````sudo cat << EOF> /usr/local/bin/wpscan````

````#!/bin/sh````

````ruby /opt/wpscan/bin/wpscan````

````EOF````

````sudo chmod +x /usr/local/bin/wpscan````

What we did in the above commands is install some dependencies and sqlmap. We then cloned the wpscan repo to our /opt directory. After that we imported RVM (Ruby Version Manager) and installed bundler. With my other tutorials I suggest you run things as root however, running ````bundle install```` as root can cause issues. We use gem to install the wpscan modules and then create a shell script in '/usr/local/bin' to launch the program with one command. 

To use wpscan to its full potential we need an API. Head over to the [wpscan site](https://wpscan.com/) and register an account. Once you have your API token we need to add it to a file so that wpscan will use it every time instead of having to declare it in a flag. Use your favorite editor to add the following 2 lines and wpscan is ready to be used.

````cli_options:````

​	````api_token: YOUR_API_TOKEN````



### ZAProxy

Web application vulnerability scanner? Fuzzer? Web crawler? ZAProxy is all of that and more. It is similar to burpsuite but has some differences that set it apart. Just like burpsuite it is written in java and requires jdk to be installed. ZAProxy is one of my favorite applications to use after I've done my recon and data gathering. It has a lot of tools all in one place. To install it we start with one command..

````curl -sSLhttps://github.com/zaproxy/zaproxy/releases/download/v2.10.0/ZAP_2_10_0_unix.sh -o zap.sh && bash zap.sh ````

ZAProxy can be installed in the shell, however if you install in xwindows you will get a graphical install. I suggest the graphical install as it is easier and contains more options. Once installed you can run ZAProxy by typing ````zap.sh```` in your terminal. We can create symlinks to have the program run by typing ```zap``` instead.

````ln -s /usr/local/bin/zap.sh /usr/local/bin/zap````

###  Nikto

Nikto is a perl script that gathers data about many parts of a site. You can analyze web applications, XSS, and many other elements of a server. You can even use nmap to dump open ports to log file and then feed that file into nikto to have it scan those ports. Installation is pretty easy.

````xbps-install -Su perl````

````cd /opt && git clone https://github.com/sullo/nikto````

````cat <<EOF> /usr/local/bin/nikto````

````#!/bin/sh````

````perl /opt/nikto/program/nikto.pl````

````EOF````

````chmod +x /usr/local/bin/nikto````



### SQLMap

Databases are some of the juciest targets. Usernames, passwords, e-mail addresses and more all live within these databases. We could manually try to hack these databases by looking for a page that ends in 'id=1' and adding things like 'fakeurl.com/index.php?id=-1 union select 1,database(),3' over and over until we finally get a result, or we can use sqlmap to do the work for us! Installing sqlmap is easy because it's already in the Void repos. 

````xbps-install -Su sqlmap````

To run sqlmap all you need to do is give the command ````sqlmap.py````. With sqlmap you don't need to find any php pages, just give it a domain with the --crawl and --forms switches, set your threads and relax while it does all the heavy lifting. 



### Closing

Web apps are a great place to start when trying to gain access to a system or database. Programs like Burpsuite and ZAProxy make it easy to manipulate sites, data, and view what goes on behind the scenes of your browser. SQLMap makes the tedious act of sql injection as easy as a simple command. These are powerful tools and should be treated with the respect you would give any tool that could have damaging consequences.



Copyright © 2021 [0x29aNull](mailto:0x29a@null.net)

