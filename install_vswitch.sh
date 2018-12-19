#!/bin/bash


# Set common variables
DISTRO="solus"
PROTOCOL="udp"
VPNHOST="nordvpn"
TUNNEL="tun+"
TODAYISO=`date '+%Y%m%d-%H%M'`
INSTALLDIR=$(pwd)

function fn_check_distro(){
	if [[ $(apropos "package manager" &>/dev/null) = *eopkg* ]] || [[ $(lsb_release -a) = *olus* ]] || [[ $(cat /etc/issue) = *olus* ]];then
		alias 'apt-get'=eopkg
		DISTRO="solus"
	elif [[ $(apropos "package manager" &>/dev/null) = *apt-get* ]] || [[ $(lsb_release -a) = *buntu* ]] || [[ $(lsb_release -a) = *ebian* ]];then
		alias eopkg="apt-get"
		DISTRO="debian"
	elif [[ $(apropos "package manager" &>/dev/null) = *pacman* ]]; then
		# If the `apropos` command is not working you'll need to run `sudo mandb`
		DISTRO="arch"
	fi
}
function fn_vswitch_ascii(){
	echo "                      _ __       __  "
	echo " _   ________      __(_) /______/ /_ "
	echo "| | / / ___/ | /| / / / __/ ___/ __ \ "
	echo "| |/ (__  )| |/ |/ / / /_/ /__/ / / /"
	echo "|___/____/ |__/|__/_/\__/\___/_/ /_/ "
}

cd $INSTALLDIR

# Questionaire: offer a more secure hosts file
fn_vswitch_ascii
while true; do
	read -p "Install a new hosts file to increase security and prevent ads? (y/n) " yn
	case $yn in
		[Yy]* ) INSTALLHOSTS="install"; break;;
		[Nn]* ) INSTALLHOSTS="skip"; break;;
		* ) echo "Please answer yes or no.";;
	esac
done

# Make package management agnostic
# Supporting Ubuntu + derivatives, Mint, Debian, Pure, Kali, Parrot and Tails
# Could also run:	uname -a | grep -i ubuntu
fn_check_distro

# Check for dependencies, install if absent
# Could also run:	 dpkg -s openvpn | grep -i "Status:"
if [[ $DISTRO="solus" ]]; then
	sudo eopkg install ca-certificates
	sudo eopkg install ca-certs
	if [[ $(sudo eopkg check ufw) != *integrity*of*ufw*OK* ]] &>/dev/null; then
		sudo eopkg install ufw -y
		sudo apt-get install ufw -y
	fi
	if [[ $(sudo eopkg check openvpn) != *integrity*of*openvpn*OK* ]] &>/dev/null; then
		sudo eopkg install openvpn -y
		sudo apt-get install openvpn -y
	fi
	if [[ $(sudo eopkg check networkmanager-openvpn) != *integrity*of*networkmanager-openvpn*OK* ]] &>/dev/null; then
		sudo eopkg install networkmanager-openvpn -y
		sudo apt-get install jqnetworkmanager-openvpn -y
	fi
	if [[ $(sudo eopkg check jq) != *integrity*of*jq*OK* ]] &>/dev/null; then
		sudo eopkg install jq -y
		sudo apt-get install jq -y
	fi
fi
if [[ $DISTRO="debian" ]]; then
	sudo apt-get install ca-certificates
	sudo apt-get install ca-certs
	if [[ $(dpkg -s ufw | grep -i status) = *not*installed* ]] &>/dev/null; then
		sudo eopkg install ufw -y
		sudo apt-get install ufw -y
	fi
	if [[ $(dpkg -s openvpn | grep -i status) = *not*installed* ]] &>/dev/null; then
		sudo eopkg install openvpn -y
		sudo apt-get install openvpn -y
	fi
	if [[ $(dpkg -s network-manager-openvpn | grep -i status) = *not*installed* ]] &>/dev/null; then
		sudo eopkg install network-manager-openvpn -y
		sudo apt-get install network-manager-openvpn -y
	fi
	if [[ $(dpkg -s network-manager-openvpn-gnome | grep -i status) = *not*installed* ]] &>/dev/null; then
		sudo eopkg install network-manager-openvpn-gnome -y
		sudo apt-get install network-manager-openvpn-gnome -y
	fi
	if [[ $(dpkg -s jq) = *not*installed* ]] &>/dev/null; then
		sudo eopkg install jq -y
		sudo apt-get install jq -y
	fi
fi
if [[ $DISTRO="arch" ]]; then
	sudo pacman -Syu install ca-certificates
	sudo pacman -Syu install ca-certs
	if [[ $(dpkg -s ufw | grep -i status) = *not*installed* ]] &>/dev/null; then
		sudo pacman -Syu install ufw -y
	fi
	if [[ $(dpkg -s openvpn | grep -i status) = *not*installed* ]] &>/dev/null; then
		sudo pacman -Syu install openvpn -y
	fi
	if [[ $(dpkg -s network-manager-openvpn | grep -i status) = *not*installed* ]] &>/dev/null; then
		sudo pacman -Syu install network-manager-openvpn -y
	fi
	if [[ $(dpkg -s network-manager-openvpn-gnome | grep -i status) = *not*installed* ]] &>/dev/null; then
		sudo pacman -Syu install network-manager-openvpn-gnome -y
	fi
	if [[ $(dpkg -s jq) = *not*installed* ]] &>/dev/null; then
		sudo pacman -Syu install jq -y
	fi
fi


# Set ufw to accept connections via OpenVPN (if firewall is on)
sudo cp /etc/default/ufw /etc/default/ufw.BAK$TODAYISO
sudo ufw default allow FORWARD # Below is a more dangerous way of accomplishing this same command:
#sudo sed -i '/DEFAULT_FORWARD_POLICY/ s/.*/DEFAULT_FORWARD_POLICY='\"ACCEPT\"'/' /etc/default/ufw
sudo sed -i '/IPV6/ s/.*/IPV6='yes'/' /etc/default/ufw


# Saving known VPNs
# Taken from:	https://nordvpn.com/tutorials/linux/openvpn/
sudo mkdir /etc/openvpn/${VPNHOST,,}
cd  /etc/openvpn/${VPNHOST,,}
sudo wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
sudo unzip /etc/openvpn/${VPNHOST,,}/ovpn.zip
sudo rm /etc/openvpn/${VPNHOST,,}/ovpn.zip
cd /etc/openvpn/${VPNHOST,,}/ovpn_${PROTOCOL,,}	# Sets cd ovpn_ to declared variable in lower case

# Saving original host file as a .BAK with today's date in ISO format and then installing modified verson
if [ $INSTALLHOSTS = "install" ]; then
	cd $INSTALLDIR
	sudo cp /etc/hosts /etc/hosts.BAK$TODAYISO
#	if [ -f /etc/hosts.BAK$TODAYISO ]l then
#		if [ $DISTRO = "solus" ]; then
#			sudo cp custom_hosts /etc/hosts
#		elif [ $DISTRO = "debian" ]; then
			sudo cp Resources/custom_hosts /etc/hosts
#		fi
		echo "Your /etc/hosts file has been backed up and replaced"
#	fi
fi

# Install shell commands and man page
cd $INSTALLDIR
sudo cp vswitch /usr/bin/vswitch
sudo chmod +x /usr/bin/vswitch
sudo cp Resources/vswitch.conf /etc/openvpn/vswitch.conf
sudo chmod +r /etc/openvpn/vswitch.conf
sudo cp Resources/vswitch.1 /usr/share/man/man1/
sudo cp Resources/vswitch_autocomplete.sh /etc/bash_completion.d/vswitch
sudo chmod +rx /etc/bash_completion.d/vswitch
source /etc/bash_completion.d/vswitch
#sudo mandb

# Adding call for custom functions to ~/.bashrc
#sudo echo "# Added by \"vswitch\": ">>/etc/skel/.bashrc
#sudo echo "# Added by: git clone https://github.com/MorningCoffeeZombie/vswitch.git">>/etc/skel/.bashrc
#sudo echo "source /etc/openvpn/vswitch">>/etc/skel/.bashrc


 
echo "Installation complete!"
echo "Use the \"vswitch\" command to engage killswitch"

##################
# UNUSED RESOURCES
##################


# This is the old 'distro checker'. It's fully functional but was depricated by optimized version:
#function fn_check_distro{
#	if [[ $(uname -s) = *olus* ]] || [[ $(lsb_release -a) = *olus* ]] || [[ $(cat /etc/issue) = *olus* ]]; then
#		alias 'apt-get'=eopkg
#		DISTRO="solus"
#	elif [[ $(uname -a) = *ubuntu* ]] ||  [[ $(uname -a) = *mint* ]] ||  [[ $(uname -a) = *debian* ]] || [[ $(uname -a) = *pure* ]] || [[ $(uname -a) = *kali* ]] || [[ $(uname -a) = *parrot* ]] || [[ $(uname -a) = *tails* ]]; then
#		alias eopkg="apt-get"
#		DISTRO="debian"
#	fi
#}






