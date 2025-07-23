#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Script   : install virtual box
# Descrição: instalação do virtual box
# Versão   : 1.0
# Autor    : Renato Linard <renatolinardjr@gmail.com>
# Data     : 22/07/2025
# Licença  : GNU/GPL v3.0
# -----------------------------------------------------------------------------
# Uso: virtual_box.sh
# -----------------------------------------------------------------------------

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

echo "###################################################################################"
echo "##      This script assumes you have the linux kernel running        ##"
echo "###################################################################################"


if pacman -Qi linux &> /dev/null; then

	tput setaf 2
	echo "########################################################################"
	echo "#########  Installing linux-headers"
	echo "########################################################################"
	tput sgr0

	sudo pacman -S --noconfirm --needed linux-headers
fi

sudo pacman -S --noconfirm --needed virtualbox
sudo pacman -S --needed --noconfirm virtualbox-host-dkms

echo "###################################################################################"
echo "##      Removing all the messages virtualbox produces         ##"
echo "###################################################################################"
VBoxManage setextradata global GUI/SuppressMessages "all"

# resolution issues Jan/2023
# VBoxManage setextradata "Your Virtual Machine Name" "VBoxInternal2/EfiGraphicsResolution" "2560x1440"
# VBoxManage setextradata "Your Virtual Machine Name" "VBoxInternal2/EfiGraphicsResolution" "1920x1080"
# graphical driver - VMSVGA !
# see : https://wiki.archlinux.org/title/VirtualBox#Set_guest_starting_resolution

echo "###################################################################################"
echo "#########               You have to reboot.                       #########"
echo "###################################################################################"

