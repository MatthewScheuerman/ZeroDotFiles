#!/bin/bash
set -e
#
#
##################################################################################################################
#
#   DO NOT JUST RUN THIS...AT ALL...IT IS CURRENTLY IN DEVELOPMENT. NOT TESTED!!! . EXAMINE AND JUDGE. USE AT YOUR OWN RISK.
#
##################################################################################################################

# Dependencies

apt install wget git
sudo apt-get install -y autoconf
sudo apt-get install -y automake
sudo apt-get install -y build-essential
sudo apt-get install -y libtool
sudo apt-get install -y xutils-dev xcb libxcb-composite0-dev
sudo apt-get install -y doxygen

sudo apt-get install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev 
sudo apt-get install -y libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev
sudo apt-get install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev 
sudo apt-get install -y libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev

echo "###############################"
echo "Xcb-util-xrm"
echo "###############################"

rm -rf /tmp/xcb-util-xrm
git clone --recursive https://github.com/Airblader/xcb-util-xrm.git /tmp/xcb-util-xrm
cd /tmp/xcb-util-xrm
git submodule update --init
sh /tmp/xcb-util-xrm/autogen.sh --prefix=/usr
make && sudo make install

rm -rf /tmp/xcb-util-xrm

echo
echo
echo "###############################"
echo "Xcb-util-xrm installed"
echo "###############################"
sleep 3

# install i3

$ sudo apt update & sudo apt install i3 suckless-tools

sed -i s/greeter-session=pi-greeter/greeter-session=lightdm-gtk-greeter/g /etc/lightdm/lightdm.conf

#Disable auto log in via raspi-config
$ sudo raspi-config

# end of i3 install

# Applications


# core applications
sudo apt-get install -y i3status i3lock

#sudo apt-get install -y i3-wm
sudo apt-get install -y dmenu
# conky
sudo apt-get install -y conky-all
# numerick lock on
sudo apt-get install -y numlockx
numlockx on

# change wallpapers with feh and variety
sudo apt-get install -y feh

# take picture of screen
sudo apt-get install -y scrot

# transparency of non active window
sudo apt-get install -y compton

# thunar
sudo apt-get install -y thunar

#https://github.com/vivien/i3blocks
if hash i3blocks 2>/dev/null; then
    	echo "i3blocks is already installed"
else

	rm -rf /tmp/i3blocks
	git clone https://github.com/vivien/i3blocks.git /tmp/i3blocks
	cd /tmp/i3blocks
    ./autogen.sh
    ./configure
	make
	sudo make install
	rm -rf /tmp/i3blocks

fi

sudo apt-get install -y terminator

# not sure if this works or not
apt install  zsh
chsh -s /usr/bin/zsh root

wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
source ~/.zshrc

sudo apt-get install fonts-powerline

#sudo apt-get install mc
#
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. AT YOUR OWN RISK.
#
##################################################################################################################


##################################################################################################################
########################                        D I S T R O                             ##########################
##################################################################################################################

echo "################################################################"
echo "This script will copy/paste all the i3 configuration files "
echo "to the ~/.config/i3 folder."


echo "################################################################"
echo "Checking presence of lsb-release and install it when missing"

	if ! location="$(type -p "lsb_release")" || [ -z "lsb_release" ]; then

		# check if apt-get is installed
		if which apt-get > /dev/null; then

			sudo apt-get install -y lsb-release

		fi

		# check if pacman is installed
		if which pacman > /dev/null; then

			sudo pacman -S --noconfirm lsb-release

		fi

		# check if eopkg is installed
		if which eopkg > /dev/null; then

			sudo eopkg -y install lsb-release

		fi

	fi


DISTRO=$(lsb_release -si)

echo "################################################################"
echo "You are working on " $DISTRO




##################################################################################################################
########################                    S O F T W A R E                             ##########################
##################################################################################################################




echo "################################################################"
echo "Checking if git is installed and install it if it is not installed yet."



case $DISTRO in 

	LinuxMint|linuxmint|Ubuntu|ubuntu)

		echo "Installing software for "$DISTRO

		# check if git is installed
		if ! location="$(type -p "git")" || [ -z "git" ]; then

			echo "################################################################"
			echo "installing git for this script to work"


		   	sudo apt-get install -y git

		  else
		  	echo "################################################################"
		  	echo "git was already installed. Proceeding..."
		fi

	
		;;

	Arch|arch)
		echo "################################################################"
		echo "Installing software for "$DISTRO

		if ! location="$(type -p "git")" || [ -z "git" ]; then

			echo "################################################################"
			echo "installing git for this script to work"


		  	sudo pacman -S --noconfirm git

		  else
		  	echo "################################################################"
		  	echo "git was already installed. Proceeding..."


		fi

		;;

	Solus|solus)
		echo "################################################################"
		echo "Installing software for "$DISTRO

		if ! location="$(type -p "git")" || [ -z "git" ]; then

			echo "################################################################"
			echo "installing git for this script to work"


		  	sudo eopkg install -y git

		  else
		  	echo "################################################################"
		  	echo "git was already installed. Proceeding..."


		fi
		;;




	*)
		echo "################################################################"
		echo "There were no installation lines for your distro " $DISTRO

		;;
esac





##################################################################################################################
###################### C H E C K I N G   E X I S T E N C E   O F   F O L D E R S            ######################
##################################################################################################################b

# define the github here, just last part

GITHUB=i3-installation-on-latest-linux-mint

echo "################################################################"
echo "Checking if /tmp folder is clean"
[ -d /tmp/$GITHUB ] && rm -rf "/tmp/$GITHUB" & echo "/tmp is clean now" || echo "/tmp is clean"

echo "################################################################"
echo "Downloading the files from github to /tmp directory " $GITHUB


git clone https://github.com/erikdubois/$GITHUB /tmp/$GITHUB


echo "################################################################"
echo "Check if there is a ~/.config/i3 folder else make one"

[ -d $HOME"/./config/i3" ] || mkdir -p $HOME"/.config/i3"




##################################################################################################################
######################              C L E A N I N G  U P  O L D  F I L E S                    ####################
##################################################################################################################

# removing all the old files that may be in .config/i3 with confirm deletion

if find ~/.config/i3 -mindepth 1 > /dev/null ; then

	read -p "Everything in folder ~/.config/i3 will be deleted. Are you sure? (y/n)?" choice
	case "$choice" in 
 	 y|Y ) rm -rf ~/.config/i3/* ;;
 	 n|N ) echo "Nothing has changed." & echo "Script ended!" & exit;;
 	 * ) echo "Type y or n." & echo "Script ended!" & exit;;
	esac

else
	echo "################################################################" 
	echo ".config/i3 folder is ready and empty. Files will now be copied."

fi

##################################################################################################################
######################              M O V I N G  I N  N E W  F I L E S                        ####################
##################################################################################################################


# copy all config files to this hidden folder
rm /tmp/$GITHUB/git-v1.sh 
rm /tmp/$GITHUB/setup-git-v1.sh

cp -rf /tmp/$GITHUB/* ~/.config/i3
rm -rf /tmp/$GITHUB

echo "################################################################"
echo "In this hidden folder ~/.config/i3 you will find"
echo "the most recent configs."
echo "################################################################"
echo "##############  LOG OFF AND LOG ON WITH I3     #################"
echo "################################################################"
