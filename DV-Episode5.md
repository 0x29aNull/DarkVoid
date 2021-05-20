# DarkVoid: A Weekly Blog on Void Linux for Nefarious uses.

## Episode 5 - Ricing/Customizing the look of Void Linux

![](https://github.com/0x29aNull/DarkVoid/blob/main/DVLogo.png?raw=true)

Ricing is one of the greatest features of Linux. Being able to fully customize every single part of your operating system not only makes your computing experience more pleasant and visually appealing, it can actually increase your Linux skill set. I frequent a subreddit called [r/UnixPorn](https://reddit.com/r/unixporn). It is a community of people that like to 'rice' their Linux window managers, desktop environments, terminals, and virtually every and any other aspect of their system. In this tutorial we will go over installing and configuring BSPWM with PolyBar. We will also install and configure a compositor from source, theme a terminal, the Bash/ZSH shell, customize Firefox, and then clean up any unneeded dependencies. This blog isn't meant to leave you with a polished window manager at the end, but rather give you an idea of the direction you need go when you start customizing your setup.



## Prerequisites

A fresh install of Void Linux and an internet connection.



## Base packages

We will need some packages installed to get things started. Void's repositories contain just about everything we need. So let's get installing!

```xbps-install -Su xorg-minimal firefox kitty polybar zsh neovim python3-pip python3-devel meson ninja base-devel git feh uthash nerd-fonts wget bspwm sxhkd dunst xsetroot rofi neofetch font-Siji```

Now we will install some packages that we will later remove

````xbps-install -Su pixman-devel xcb-util-keysyms-devel xcb-util-image-devel xcb-util-renderutil-devel xcb-util-wm-devel xcb-util-devel libev-devel MesaLib-devel libconfig-devel````



### Picom

Picom is a compositor, it can give you awesome effects for your desktop. We could install the default picom in the Void repos, but we won't get the fancy dual-kawasee blur and rounded corners. So let's clone Ibhagwan's fork of picom.

````git clone https://github.com/ibhagwan/picom````

Picom is built using meson and ninja, Which are python tools to help automate the process. We should have everything we need since we installed all of those packages. 

````meson --buildtype=release . build -Ddbus=false -Dregex=false````

````ninja -C build````

````ninja -C build install````

In the above commands we're telling meson to build the standard picom release and to compile without dbus and libpcre. Should you want dbus or pcre enabled just omit ````-Ddbus=false -Dregex=false```` and install the 2 packages 'dbus-devel' and 'libpcre-devel'. Ninja -C build will do exactly what you think it does, it builds the program and can you guess what the third command does?

Now we will need to download a picom configuration so that it knows what to we want our effects to look like.

````curl https://raw.githubusercontent.com/0x29aNull/DarkVoidDots/main/picom.conf -o ~/.config/picom.conf````

You should note that depending on your system, the config we downloaded may not work for you. You may need to change your backend if you get weird artifacts or it just doesn't run, check out the [wiki](https://wiki.archlinux.org/title/Picom).



### Picking a colorscheme

Before we go any further if you want your desktop to shine and everything to match and look great together we need a colorscheme. There are a few ways we can get one.. We could use a pre-existing colorscheme like Nord or Dracula, or we could make our own. Creating one is fairly easy to do, You just pick out colors you think look good together. What we need are the hex values of the color. Hex values are 6 digit codes that tell a program what exact color we want. The graphics creation program GIMP has a tool that can give us these colors from any image we choose or if you want something a little faster (yet a little less control) [ImageColorPicker](https://imagecolorpicker.com/en) is a tool that will give you a complete palette based off of an image. No matter which method you choose, a colorscheme will be the backbone of our rice.

To install GIMP just give the command ````xbps-install -Su gimp````



### Bash or ZSH?

Now, you have a question to ask yourself. Should you go with bash or zsh? Should you choose zsh you can customize the look as well as functionality with plugins using a script called oh-my-zsh. Installing oh-my-zsh is easy, it can be done with one command..

````sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"````

Now answer the prompts, type your password and you're good to go. If you don't care for the default theme you can either google "oh-my-zsh themes" or type ````ls ~/.oh-my-zsh/themes/```` and replace the name of the theme in your ````~/.zshrc```` file with one you think sounds interesting. You can find more themes and plugins on the official [site](https://ohmyz.sh/).

If you're a traditionalist at heart or just prefer the way bash operates then not all hope is lost. There is a version of oh-my-zsh for bash, and it's name is oh-my-bash (how original). It can also be installed in the same easy way as the zsh varient

````sh -c "$(curl -fsSL https://raw.github.com/ohmybash/oh-my-bash/master/tools/install.sh)"````

Much like oh-my-zsh, plugins and themes can be found on their official [site](https://ohmybash.nntoan.com/). Whether you choose bash or zsh is up to you. Recently on [UnixPorn](https://www.reddit.com/r/unixporn) user u/ChickenManPL had posted a set of scripts that make commands like ls, pwd, mkdir, and touch have colorful icons and a better layout. He calls it prettifier and it looks great. It can also be installed with one command

````sh -c "$(curl -fsSL https://github.com/jszczerbinsky/ptSh/releases/download/v0.1-alpha/install.sh)"````



### BSPWM

BSPWM (Binary Space Window Manager) is a very light weight and flexible window manager. It is keyboard driven, meaning to launch applications and control windows, you use key combinations. These key combinations are actually configured and controlled with SXHKD (Simple X Hot Key Daemon). All configuration files for BSPWM are done with shell scripts. In the 'ricing' community you will hear the term 'dots'. This refers to any configuration files which are mostly .conf, .config, or end in 'rc'. Most of these live in ~/.config/. The first dot we need to work on is our bspwmrc. Before we get started we need to make some directories and download the file.

````mkdir ~/.config/{bspwm,sxhkd,dunst,polybar,kitty} ````

````curl https://raw.githubusercontent.com/0x29aNull/DarkVoidDots/main/bspwmrc -o ~/.config/bspwm/bspwmrc````



You can see by the ````#!```` at the start of the text that this is a shell script. We are telling the window manager to automatically run some programs at start. Any application you want to run at start should be put in here with an '&' after it. In the above script we're running xsetroot to change the mouse pointer, the dunst notification daemon, xset to turn off beeps, sxhkd for our keyboard commands, picom compositor for effects, and polybar to display our time, date, and any other information we tell it. We also have padding options but more importantly rules. bspwm rules allow us to to tell it when we run a program or class or programs, how to open it. You can open them in monocle mode (fullscreen), floating (small defined window size), or in tiling mode.

###  SXHKD

We need to create our 'sxhkdrc' file in ~/.config/sxhkd/ and tell it what keys we want to launch our programs and control our windows.

````curl https://raw.githubusercontent.com/0x29aNull/DarkVoidDots/main/sxhkdrc -o ~/.config/sxhkd/sxhkdrc````

When going through the config for sxhkd you will probably wonder 'what's a node?'. Nodes are what bspwm calls windows. You will probably want to add additional programs to your sxhkdrc, just make sure to verify that the key combination does not use the same combination as other programs or bspwm as this can cause a conflict.



### First run

We can now test to see if bspwm will run. Before we can startx we need to create a file that tells xinit to start bspwm by default. ````echo bspwm > ~/.xinitrc```` and now we can type ````startx````. We should be greeted with by a blackscreen with a cursor in the center. Press 'super + enter', Kitty terminal should now be in the center of your screen. The super key, if you dont know, is your windows key. Now we can do some customization!

Picking a good wallpaper is essential. Whether you find one at [wallhaven](https://wallhaven.cc/) or [wallpaperaccess](https://wallpaperaccess.com/) or [pexels](https://www.pexels.com/), without a good desktop background, your rice will be lacking. To set a wallpaper manually use the command ````feh --bg-scale /path/to/wallpaper.jpg```` to have bspwm set the wallpaper automatically put that command with '&' at the end in your bspwmrc autostart programs list. 



### Kitty

Terminal emulators are a big part of using Linux, Picking the right one could make or break your setup. With so many terminals available (xterm, urxvt, alacritty, terminator, etc.) it's hard to figure out which one is best for you. I prefer kitty for several reasons: it's fast, it can display images, it has a built in multiplexer, it supports ligatures, it has text based tabs and more. Some others have some of the features but only one has all of them.. Kitty. You can make your own colorscheme but for now, we're going to pick a pre-made scheme from [dexpota's repo](https://github.com/dexpota/kitty-themes). Just clone and move the files ````git clone https://github.com/dexpota/kitty-themes && cp -r kitty-themes/themes ~/.config/kitty/```` once this done you can remove the git directory. Now change directories to ~/.config/kitty/ and visit [dexpota's repo](https://github.com/dexpota/kitty-themes), look for a theme that matches your wallpaper. Now copy the theme from the themes directory (~/.config/kitty/themes) into the kitty directory and name it 'theme.conf'.

We need to setup our kitty.conf. In the interest of saving time we're going to curl a pre-existing dot and edit it.

 ````curl https://raw.githubusercontent.com/0x29aNull/DarkVoidDots/main/kitty.conf -o ~/.config/kitty/kitty.conf```` 

In our kitty config the first 21 lines are the most important in regards to getting our look. The first line we tell kitty to load the theme we picked. The next 3 lines are in regards to transparency. Picom gives are real nice blurred glass/dual kawase blur effect, if that's something you don't want just put a '#' infront of lines 3,4, & 5. The sixth line is padding, this tells your terminal to give a space between your font and the window border. After that you have fonts, I suggest using a nerd font which we installed earlier. The [nerd font site](https://www.nerdfonts.com/font-downloads) has examples of all the fonts.  In Linux the name of a font on the site may be different than what it's named in the system. To get it's actual name give the following command

````fc-list | grep FONTNAME````

Example, if the font I was looking for was "Deja Vu Sans Mono" I would use the name "Deja" ie. ````fc-list | grep Deja````. The results you will get back will look something like this

````/usr/share/fonts/X11/TTF/DejaVuSansMono.ttf: DejaVu Sans Mono:style=Book````

The name you would use in your kitty.conf is right before ':style=Book', "DejaVu Sans Mono". This lets Kitty know how to call the font you want to use.

Should you want to go a step further with your colors, You can edit the theme.conf but you'll need 2 of each colors. A light and a dark for red, green, blue, yellow, cyan, white, and black. Here is a list of which colors are which.

Colors 0 & 8 black

Colors 1 & 9 red

Colors 2 & 10 green

Colors 3 & 11 yellow

Colors 4 & 12 blue

Colors 5 & 13 purple

Colors 6 & 14 Cyan

Colors 7 & 15 White



### Music

Are you a fan of music? If so, it's fairly easy to get a good looking music player on Void. If your music is local (on your hard drive), I suggest the program NCMPCPP (No idea what it stands for) running on MPD (Music Player Daemon). Both the client (NCMPCPP) and server (MPD) are feature rich and highly customizable. Installation is fast and easy

````xbps-install -Su ncmpcpp mpd mpc````

The first thing we need to do before linking our MPD service is to get a configuration in place and create some files

````curl https://raw.githubusercontent.com/0x29aNull/DarkVoidDots/main/mpd.conf -o /etc/mpd.conf````

Now, you will need to replace the name "USER" in mpd.conf with the name of your user. Make sure you're running these commands as your regular user. Also be sure to change the directory of where your music is stored.

````sudo sed -i 's/USER/YourUser/g' /etc/mpd.conf ````

````mkdir ~/.mpd/````

````mkdir ~/.mpd/playlists````

````mkdir ~/.ncmpcpp/````

````touch ~/.mpd/{mpd.db,mpd.log,mpd.pid,mpdstate}````

Now, Find a theme that matches your over all colorscheme (or make your own). I suggest going to [DotShare](http://dotshare.it/category/mpd/ncmpcpp/) and finding one or looking at them for examples. Some use older configuration options that are no longer available in newer versions of NCMPCPP, so the program may complain at launch. I typically just edit those lines out. We can now create our database, link our daemon, and start NCMPCPP.

```` cd /path/to/music && mpc ls | mpc add````

````ln -s /etc/sv/mpc/ /var/service/````

````sv start mpd````

````ncmpcpp````

Should your playlist be empty, just press 'u' to update. For more keys see [this site](https://pkgbuild.com/~jelle/ncmpcpp/).



### Polybar

System status is important to know. We need to know our time and date, but other things are just as important like battery life, the name of your current workspace, name of the focused application, packages waiting to be installed, current network connection, etc. Polybar is a great light weight tol to give us all this information and more. Configuring Polybar can be daunting as it makes a big impact aesthetically, but once you you know direction you want to go in. The Nerd Fonts we installed earlier play a big role in giving Polybar it's look. To find font icons you want to use try [CharMap](https://char-map.herokuapp.com/). The best way to start off with Polybar is to find something someone else has made and go over the config and make it your own. There are a few repos I recommend for amazing premade configs. [ngynLk's repo](https://github.com/ngynLk/polybar-themes) and [adi1090x's repo](https://github.com/adi1090x/polybar-themes) both have some of the best Polybar themes I have seen. For our setup I'm going to choose the "tiny" config made by ngynLk, but you can use any one that better matches the look you're going for. Let's download the config and create a launch script...

````mkdir ~/.polybar/````

````curl https://raw.githubusercontent.com/ngynLk/polybar-themes/master/tiny/config -o ~/.polybar/config````

````cat <<EOF> ~/.polybar/launch.sh````

````#!/bin/sh````

````pkill polybar````

````while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done````

````polybar -r bar &````

````echo "polybar loaded"````

````EOF````

````chmod +x ~/.polybar/launch.sh````

Now, if your bspwmrc has "exec ~/.polybar/launch.sh &" in it, Polybar will start automatically everytime you start your window manager.  There are somethings that will differ on your system from the Polybar script you download. Things like your battery name may differ, so you may need to change that. In the config file near the top you'll notice an offset-x and offset-y, the x offset is the horizontal placement on your screen and the y offset is the vertical placement. Depending on your font size you may want to adjust the height and width of the bar. You can also define colors simply, here is an example ````blue = #0000FF````. Of course, changing the background and foreground colors are as easy as finding the hex value and changing it.

The way fonts work in Polybar is similar to how we used them in the Kitty config, just find the name and put it under 'font-0'. For any icons you will need a font like Nerd Fonts or Siji, if you've installed all packages this far you should be good. The font sizes and antialiasing is pretty straight forward. Something that perplexed me for awhile is the numbers at the end of font lines in other peoples configs. Here's an example.. ````font-0=CozetteVector:size=10:antialias=false;2```` That number at the very end is padding, it can make the font move up or down in the bar depending on the amount of padding.

In the config file if you scroll down towards the middle you will notice things like this..

````[module/time]````

````type = internal/date````

These are what Polybar calls 'modules'. They are internal scripts that handle specific functions you want to use in your configuration. There are tons of built-in modules and you can even create your own with shell scripts! Here is an example script that will show you any pending updates for your Void install (credit goes to [u/siduck76](https://www.reddit.com/u/siduck76)).

````cat <<EOF> ~/.polybar/xbps-updates.sh````

````#!/bin/bash````

````updates=$(bps-install  -un | cut -d' ' -f2 | sort | uniq -c | xargs)````

````if [ -z "$updates" ]; then````

````	echo "Fully Updated"````

````else````

````echo "$updates""s"````

````fi````

````EOF````

Next, add the following in your Polybar config under your modules section

````[module/updates]````

````type = custom/script````

````exec doas xbps-install -S > /dev/null 2>&1; xbps-updates````

````format = <label>````

````format-prefix = X````

````format-prefix-foreground = #DE8C92````

````interval = 4600````

````label = %output%````

````label-padding = 1````

````format-foreground = #D8DEE9````

Please note that for 'format-prefix' you should change the X to an icon from Nerd Fonts or Siji using [CharMap](https://char-map.herokuapp.com/). There is one more thing that we would need to do to get the updates to show up in our Polybar. We need to find the line in our config that declares which modules to use in our bar. It will look like this..

````modules-left = bspwm````

````modules-center = pulseaudio````

````modules-right = time````

This is the area in which we can add or remove modules from our Polybar. I would prefer to have it before the volume which will look like this ````modules-center = updates pulseaudio````. Not everyone is going to run pulseaudio, So you can find an ALSA module if you like. Don't forget that since we have added a new module to our bar, the bar will need to be longer to accommendate the new updates module.



### NeoVim

NeoVim is one of the greatest editors there is. It is lightweight, fast, flexible, and completely customizable. There are a ton plugins to make it a nearly full featured IDE. The first thing we need to do is install the plugin manager.

````mkdir ~/.config/nvim````

````curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim````

Now run NeoVim by using ````nvim```` once the program launches, quit by typing ':' then 'q!' and hit enter. Now we need to install some python utilities.

````pip3 install --user neovim````

````cat <<EOF> ~/.config/neovim/init.vim````

````call plug#begin()````

````Plug 'SirVer/ultisnips'````

````call plug#end()````

````EOF````

Now run NeoVim and install the plugins and quit twice

````nvim````

````:PlugInstall````

````:UpdateRemotePlugins````

````:q!````

````:q!````

We can now start to customize our NeoVim setup. The biggest difference you can make is with the general colors/syntax highlighting. Head to [VimColors](https://vimcolors.com/) and find a colorscheme that matches what you're going for. We can of course make our own, but that will have to wait for another episode of DarkVoid. The NeoVim plugin manager works off of GitHub. Say you find a colorscheme you like, you use the username and repo name. Example: The URL of the colorscheme (or plugin) is http://github.com/Username/PluginRepo you would put ````Plug 'Username/Pluginrepo'```` in your init.vim between ````call plug#begin()```` and ````call plug#end()````. After you've added that to your init.vim, open NeoVim and run ````:PlugInstall````. This will download and install the new plugins you have added. After you've installed your colorscheme, edit your init.vim again and in the body, below ````call plug#end()```` add ````colorscheme SchemeName````. This will load it everytime. While there, add ````set noshowmode```` to hide your current mode.

As I said earlier, there are many, many plugins for NeoVim. Adding them is just as easy as adding a colorscheme in most instances. [VimAwesome](https://vimawesome.com/) is a great resource for Vim plugins. The plugins I recommend are NerdTree, vim-airline, ALE, and vim-devicons. 

 

### Firefox

Yes, Firefox can too be riced. We can do amazing things with the userchrome.css, such as a custom start page, hiding or changing buttons, transparency, tab color and shape, making features disappear unless your mouse is over it and much more. Themeing Firefox can be a bit more difficult as it is not like any of the other programs we have themed previously. However, userchrome.css still uses hex color codes. I prefer the clean look with the tree style tab bar of [FlyingFox](https://github.com/akshat46/FlyingFox). To install it, we just have to run a few commands..

````git clone https://github.com/akshat46/FlyingFox````

````mv FlyingFox/chrome/ ~/.mozilla/firefox/xxxxx-default-default/````

````mv FlyingFox/user.js ~/.mozilla/firefox/xxxxx-default-default/````

Change the 'xxxxxx' in 'xxxxxx-default-default' to whatever your directory name is in ~/.mozilla/firefox/. There will be 2 directories, make sure it ends in default-default.

If you want to learn more about userchrome for Firefox head over to [r/FirefoxCSS](https://www.reddit.com/r/FirefoxCSS/).



### Dunst

Least but not last, Dunst as mentioned earlier, is a notification daemon. It can give us system events, the current song playing, network status, and more. Much like BSPWM, SXHKD, and Kitty, Dunst is very flexible. You can alter its appearance to however you like, It's also scriptable. You can change the height, width, color, font, corner radius, add a border, even add icons. I've slimmed down the default dunstrc file so that it hopefully makes a little more sense. Let's download the config and get it running.

````curl https://github.com/0x29aNull/DarkVoidDots/raw/main/dunstrc -o ~/.config/dunst/dunstrc````

Everything in the file is pretty straight forward. For our font, use the same method of obtaining the name that we did with Kitty. If you would prefer to use Rofi over dmenu just change the line ````dmenu = /usr/bin/dmenu -p dunst:```` to ````dmenu = /usr/bin/rofi -dmenu -p dunst:````. Want icons? Just give the direct path to your prefered icons. For colors, use the same hex colors we got for our colorscheme. You may or may not want to give critical notifications a different, more eye catching color but thats up to you. I'm not going to go in to details on scripting, but if you would like to know more go to the [Dunst Wiki](https://dunst-project.org/documentation/#SCRIPTING).









### Clean up

At the start of this journey we installed a whole bunch of dependencies we no longer need. You could leave them installed, but I prefer a leaner, cleaner system. Easily enough they can be removed with one command.. albeit a rather long command.

```` xbps-remove pixman-devel, xcb-util-keysyms-devel xcb-util-image-devel xcb-util-renderutil-devel xcb-util-wm-devel xcb-devel libev-devel libconfig-devel libxshmfence-devel libX11-devel libXext-devel libXxf86vm-devel libXfixes-devel libXdamage-devel expat-devel eudev-libudev-devel libpciaccess-devel libdrm-devel libglvnd-devel MesaLib-devel````

This could taken even further, I typically remove any package that isn't 100% needed. Be careful though, you could end up taking out something vital!



### Closing

By now you should have a pretty much complete setup. Depending on the path you took, you might not have ended up at the exact spot you wanted, but thats ok. Ricing isn't the easiest thing to do. It took me at least 6 months before I got something I was proud of. You need to learn the commands, learn shell scripting, learn how runit works. In the end it will get you closer to your Void Linux install and make you a better system administrator.



#### Bonus programs

Here are some additional programs that are popular on [r/UnixPorn](https://www.reddit.com/r/unixporn)..

* Neofetch (In repo)
* TTY-Clock (In repo)
* Ranger (In repo)
* aFetch [13-CF Repo](https://github.com/13-CF/aFetch)
* Sam Tay's Tetris [Sam's Repo](https://github.com/samtay/tetris)



Copyright © 2021 [0x29aNull](mailto:0x29a@null.net) 