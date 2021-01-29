#!/bin/bash
#DarkVoid v0.1a

if [[ $EUID -ne 0 ]]; then
  echo "DarkVoid must be ran as root!"
  exit 1
fi

gitcheck

mainmenu () {
clear
banner
options=(
    "Install Everything"
    "Install Metasploit"
    "Install Routersploit"
    "Install WiFi Utils"
    "Install Fuzzing Utils"
    "Install Password Utils"
    "Exit"
    )
  select option in "${options[@]}"; do
    case $option in
      ${option[0]})
      installall
      break
    ;;
      ${options[1]})
      installmsf
      break
    ;;
      ${options[2]})
      installrsf
      break
    ;;
      ${options[3]})
      installwifi
      break
    ;;
      ${options[4]})
      installfuzz
    ;;
      ${options[5]})
      installpass
      break
    ;;
    *)
      echo invalid options
    ;;
    esac
  done

  banner () {
    echo "DarkVoid v0.1a - Void Linux Weaponization"
    echo "0x29a@null.net - https://github.com/0x29aNull/DarkVoid"
  }

  gitcheck () {
    git --version "$1" >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      echo "Git required. "
      read -p "Install Git Now? [y/n]: " installgit
      if [ $installgit = 'y' ]; then xbps-install -Sy git >/dev/null & mainmenu
      if [ $installgit = 'n' ]; then exit
    else
      mainmenu
  }
}
mainmenu
