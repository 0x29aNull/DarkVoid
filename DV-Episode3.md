# Void Pirate Box
## Sail the 7 Sea of Movies

The current state of digital entertainment is a mess.
If you purchase the most basic service from each platform you would
be spending more than $250 per month. That includes advertisements
and does not include all content. Streaming services were originally
started to have tons of content in one location with a reasonable price.

What if i were to tell you there's a better way? A way to get all of your
favorite shows, movies, and music streaming on all of your devices for free?
Of course it's illegal, but who can afford $250+ a month? Hoist your sails,
we're going to commit some piracy!

* Warning: This tutorial is for educational purposes only. Piracy is illegal
and may result in fines and/or imprisonment. I have written this article to
demonstrate the capabilities of Void Linux. I am not responsible for any
misuse of this information or of any piracy that may occur due to users installing
this software.

As always, I suggest that you start off with a fresh bare bones install of
Void Linux. Installing on a BTRFS filesystem would be best as it allows for snapshots,
backups, and larger hard drives. I will publish a tutorial on installing Void on
BTRFS in the future. If you plan on storing more than a few movies I would suggest
having multiple multi-terabyte hard drives.

Upon first login to your new Void install you have to install some dependencies..

```` xbps-install -Su mono wget curl openvpn ufw deluge deluge-web ````

The packages wget and curl are both awesome little applications. They are very handy
in downloading packages or pages directly from URLs. Mono is a Micro$oft .NET
implementation for Linux, This is the program that will allow 2 of our applications
to run. Deluge is a torrent daemon and deluge-web is its webUI front-end. OpenVPN
is what we will use for our VPN client (privacy first!) and UFW is our firewall.

### Downloading and daemonizing Radarr & Sonarr

Sonarr (Formerly NzbDrone) is a windows program that uses indexers and APIs to search torrent
sites for shows. Radarr is a fork of Sonarr that does the same thing, but for movies.
Be sure to run all of the commands on this tutorial as root..

````cd /opt ````\
````wget https://download.sonarr.tv/v2/master/mono/NzbDrone.master.2.0.0.5344.mono.tar.gz ````\
````tar xvf Nzb*.tar.gz````\
````rm -r Nzb*.tar.gz````\
````wget https://github.com/Radarr/Radarr/releases/download/v3.1.1.4954/Radarr.master.3.1.1.4954.linux.tar.gz````\
````tar xvf Radarr*.tar.gz````\
````rm -r Radarr*.tar.gz````

Now that we have Sonarr & Radarr downloaded and extracted to their proper destination we need to daemonize them
so that they run on startup. If you don't want them to start on boot and would rather run them manually you can do so
with the following command..

````mono --debug /opt/NzbDrone/NzbDrone.exe````\
````mono --debug /opt/Radarr/Radarr.exe````

Setting up a new service on Void Linux is easy, You're basically creating a shell script and symlinking it to
/var/service. First you need to create the directories and copy over the supervise directory:

````mkdir /etc/sv/radarr && mkdir /etc/sv/sonarr````\
````cp -r /etc/sv/sshd/supervise /etc/sv/radarr````\
````cp -r /etc/sv/sshd/supervise /etc/sv/sonarr````\
````cat << EOF > /etc/sv/sonarr/run````\
````#!/bin/sh````\
````mono --debug /opt/NzbDrone/NzbDrone.exe > /dev/null 2>&1````\
````EOF````\
````cp /etc/sv/radarr/run /etc/sv/sonarr/````\
````cd /etc/sv/radarr/````\
````sed -i 's/NzbDrone/Radarr/g' run````\
````chmod +x /etc/sv/sonarr/run````\
````chmod +x /etc/sv/radarr/run````\
````ln -s /etc/sv/sonarr/ /var/service/````\
````ln -s /etc/sv/radarr/ /var/service/````

Next, We need to download Docker and pull the JellyFin container and link the service
so that it runs at boot.

````xbps-install -Su docker````\
````ln -s /etv/sv/docker/ /var/service/````\
````sv start docker````\
````docker pull jellyfin/jellyfin:latest````\
````mkdir /srv/jellyfin/{config,cache}````\
````docker run -d -v /srv/jellyfin/config:/config -v /srv/jellyfin/cache:/cache \````\
````-v /media:/media --net=host jellyfin/jellyfin:latest````\
````mkdir /media/jellyfin && chown $USER -R /media/jellyfin````\
````chmod 777 /media/jellyfin````

What the above commands do is install the docker container application and service.
We give the docker pull command to automatically download the latest Jellyfin
version. After that, we need to create a few directories which Jellyfin needs to run.
You don't need to create the directories in /srv, If you would rather create them in /opt or
some other directory just remember to make the changes reflect in the docker run command.

Now we need to create a service just like the Sonarr and Radarr daemon services we created earlier.
The same command that we used to start the docker will be turned into a shell script after we make
a new service directory and copy over some files.

````mkdir /etc/sv/jellyfin````\
````cp -r /etc/sv/sshd/services/ /etc/sv/jellyfin/````\
````cat << EOF > /etc/sv/jellyfin/run````\
````#!/bin/sh````\
````docker run -d -v /srv/jellyfin/config:/config -v /srv/jellyfin/cache:/cache \````\
````-v /media:/media --net=host jellyfin/jellyfin:latest````\
````EOF````\
````chmod +x /etc/sv/jellyfin/run````\
````ln -s /etc/sv/jellyfin/ /var/service/````

## Setting static IP and port forwarding

If you're going to be accessing any of your services, especially Jellyfin, You're going to need
to give your Void box a static IP on whatever interface you're using to access the network.
I suggest connecting your box directly to your router via ethernet. Start by editing the dhcpcd.conf file.
You can use whatever editor you like, i prefer neovim...

````nvim /etc/dhcpcd.conf````

Scroll to the bottom and add the following lines...

````interface eth0````\
````static ip_address=192.168.1.169/24````\
````static routers=192.168.1.1````\
````static domain_name_servers=192.168.1.1 8.8.8.8````

You can use wlan0 or any other network interface, as well as change your IP to any free IP on your network.
You can find available IPs by using tools such as nmap, ipscan, or fing on your smartphone. To add the port forward
we will need to access your routers configuration. This will vary widely depending on what your device is.
I use a Linksys WRT1900AC with DD-WRT installed. In most routers to add a port forward you need to open a
web browser and go to http://192.168.1.1 (or whatever your router's IP is) and find your port
forwarding menu, it is generally in the NAT/QOS tab. You will click on Port Forwarding and in the "from"
box add ````0.0.0.0/0```` and place ````192.168.1.169```` as the destination. You will need to do this 4 times,
one for each port. Unless you have changed any of the default ports you will need to add the following...
````7878```` ````8989```` ````8112```` ````8096````. When you're done, your port forwarding  table should look
like this:

Name:````Radarr````   From:````0.0.0.0/0```` To:````192.168.1.169```` Port:````7878````\
Name:````Sonarr````   From:````0.0.0.0/0```` To:````192.168.1.169```` Port:````8989````\
Name:````Deluge````   From:````0.0.0.0/0```` To:````192.168.1.169```` Port:````8112````\
Name:````Jellyfin```` From:````0.0.0.0/0```` To:````192.168.1.169```` Port:````8096````

Now all you need is your router's external IP address and you can use any browser on any device to connect to your
Void box anywhere in the world. Just put http://routerip:port/ and you can queue downloads, check whats currently
downloading, and stream media. However, Unless you've setup your VPN or firewall, I wouldn't start downloading just yet.

Since we're here.. I run my box as a headless box so I also added an SSH port forward as well in case i need to do any
additional configuration or maintenance. Setting up SSH on Void is as easy as running ````ln -s /etc/sv/sshd/ /var/service/````
, Although I highly recommend changing the default port from 22 to a higher port, so you aren't attacked.



## VPN and firewall
Earlier we installed the UFW (Uncomplicated FireWall) package. This is something that you would want setup
unless you want Lars Ulrich of Metallica and the RIAA knocking at your door with fines and a subpoena. I use SurfShark
which has both a CLI client and certificates available for Linux. You might not use SurfShark so in this tutorial I
will be using the certificates they provide. Download the OpenVPN certificate(s) from your VPN provider and place them
in ````/etc/vpn````, which you will have to create. For SurfShark you need to either login with each reconnect or alter
the certificates so point to a text file that contains your unique username and password. If you have more than one
certificate you can use sed to quickly change all of the files.

````cd /etc/vpn/ && sed -i 's/auth-user-pass/auth-user-pass user.txt/g' *````

Now we will need to disable IPv6, as it may cause problems down the road with the VPN. This can be done
by editing /etc/default/grub and adding ````ipv6.disable=1```` in the quotations on the ````GRUB_CMDLINE_LINUX```` line.
Once this has been done run ````grub-mkconfig -o /boot/grub/grub.cfg```` and give your machine a reboot.

When your machine comes back online verify that your VPN connect works by connecting manually\
````openvpn /etc/vpn/cert.ovpn````\
Once successfully connected you can CTRL+C out of the connection. This is where the real fun begins.
Some VPNs come with multiple connection location choices, We will only be using one for the time being.
The reason for this is that we would need to manually change the config file by hand. We will need to know
the subnet of the internal network our Void box is on, This is to allow internal communication between
devices. You can get this by running:\

````ip addr | grep inet````

you should get a return similar to this..

````inet 192.168.61.3/24 brd 192.168.61.255 scope global dynamic noprefixroute eth0````

Your subnet is the number after the / on the first IP. Now we can define some rules for UFW to allow internal traffic...

````ufw allow in to 192.168.1.0/24````\
````ufw allow out to 192.168.1.0/24````

Now we tell UFW to reject all incoming and outgoing traffic by default

````ufw default deny outgoing````\
````ufw default deny incoming````

UFW will need to know what we're going to communicate through as well as your VPN's IP and what your tun interface name is.
We can get all that with a few easy steps. First type ````head certificate.ovpn```` the information we're after is at the
top. Namely, the server name/IP and the port. This is what mine looks like..

````client````\
````dev tun````\
````proto udp````\
````remote us-slc.prod.surfshark.com 1194````

What we're after is on the last line. us-slc.prod.surfshark.com is the server and 1194 is the port. If we ping that server
name it will return the IP we need. However, in my case everytime I ping it the IP changes so, I will change the last digit
to a 0 and add a /24 to the following command

````ufw allow out to 104.200.131.0/24 port 1194 proto udp````

Here's where we tell the firewall to let any traffic in and out of the tun VPN interface.

````ufw allow out on tun0 from any to any````\
````ufw allow in on tun0 from any to any````

Once again, we will need to link UFW service folder to /var/service so that it starts when we boot our computer.

````ln -s /etc/sv/ufw/ /var/service/````

If at anytime the UFW becomes an issue or we need to change anything, We can start and stop the firewall with...

````ufw disable````\
````ufw enable````

Don't forget to run ````sv stop ufw```` after disabling the firewall and ````sv start ufw```` before enabling it.

## Setting up Deluge, Radarr, Sonarr, & Jellyfin to download & stream

At this point we have our Void Pirate box installed, the services created and running. It's time to connect to our
running services with a browser on a separate computer or phone and configure them. Although, We could install the
Xwindows system and set them up locally, I prefer to keep my install small and lean. If you decide to go the Xwindows
route, just skip the part of obtaining your IP and put ````http://127.0.0.1:PORT/```` in your browser's address bar.
You can also skip curl'ing your IP address if you are accessing the services from within your home network since we
told to firewall to allow all traffic from anything connected to 192.168.1.x. We need to find out what our outside
IP address is so that we can connect to it. we can do this with a simple curl command... ````curl ifconfig.me````

#### Deluge

First service we're going to configure is deluge. This is pretty easy, Just login with the password ````deluge````
and then change the password. It should prompt you automatically to change it and bring up the configuration menu
on first login. Click on the 'Preferences' button and You can set your downloads location and any other configurations
you may need. I'm not going to go in to details on this as it's not the most important part and there are numerous
tutorials online on configuring deluge.

#### Radarr & Sonarr

Open ````http://IP:7878```` in your browser and in the left hand panel scroll down and click on settings.
Open 'Indexers'. Here we can add our torrent sites. Some sites require either an API or a cookie to be able to
use them with Radarr. To add a site, simply click the plus button in the box for the site you want to add and
enter any relevant information. Once our sites have been added we need to tell Radarr to use deluge to be our
download client. Scroll down to the "Torrent" section and click on "Deluge". Put in the password you created
and make sure that it's configured to the correct port. Sonarr is nearly identical in setup except the settings
button is located at the top right. There are lots of other sites that will show you how to change the media
format and metadata, This tutorial is on how to set it up and get it working.

#### JellyFin

In your browser navigate to ````http://IP:8096/````. You will be greeted with a Welcome page, Select your
language and press "Next". Setup a username and password in the next field. This will be what we will use
to manage the JellyFin server with, You can add individual user accounts later. On the next page we're given
the option to setup our media locations. If you have followed this tutorial exactly as I had set things up
then /media will be your main folder. I create subfolders ````/media/movies```` and ````/media/shows````.
After we've selected our appropriate media folders, Go on to the next, Select your language again and press
next. The following screen allows you to select if you want to incoming connections from outside sources.
It should already be selected, The other option has JellyFin attempt to configure your router automatically.
Since we've already gone over this go ahead and leave it unchecked. Click next then finish.

### Finishing notes

For the most part, We're done! Sure, There are some configuration settings you'll want to tweak and adjust
but for the most part you have a fully working Void Pirate box. You can install the JellyFin application on
your phone, tablet, laptop, even on an xbox. I've done this whole process on other operating systems (Ubuntu,
Debian, Windows) and Void Linux makes it truly painless, not to mention very fast.

At the start I had mentioned BTRFS, Which I will make a tutorial on in a future episode. There are other guides
online but none that were very easy to follow along or that explained the process in any depth. BTRFS is important
in situations like this as it provides snapshots and for filesystems that span across multiple drives. Until I
write that tutorial on BTRFS or if you use ext4 I suggest getting 2 large drives (a minimum of 1TB each), Formatting
them in your filesystem type and mounting them as your ````/media/movies```` and ````/media/shows```` drives.

I hope this has been informative on how flexible, light, and powerful Void Linux is.

Copyright 2021 [0x29aNull](0x29a@null.net)
