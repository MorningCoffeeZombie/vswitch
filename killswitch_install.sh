#!/bin/bash


# Set common variables
DISTRO="unknown"
VPNHOST="nord"
TUNNEL=tun0
TODAYISO=`date '+%Y%m%d-%H%M'`


# Offer a more secure hosts file
while true; do
	read -p "Install a new hosts file to increase security and prevent ads? (y/n) " yn
	case $yn in
		[Yy]* ) INSTALLHOSTS="install"; break;;
		[Nn]* ) INSTALLHOSTS="skip"; break;;
		* ) echo "Please answer yes or no.";;
	esac
done		

# Make package management agnostic
# Supporting Ubuntu + derivatives, Mint, Pure, Kali, Parrot and Tails
if [ $(uname -s) = *solus* ]; then
	alias 'apt-get'=eopkg
	DISTRO="solus"
elif [ $(uname -s) = *ubuntu* ] ||  [ $(uname -s) = *mint* ] || [ $(uname -s) = *pure* ] || [ $(uname -s) = *kali* ] || [ $(uname -s) = *parrot* ] || [ $(uname -s) = *tails* ]; then
        alias eopkg="apt-get"
	DISTRO="debian"
fi

# Check for dependencies, install if absent
if [ $(eopkg check ufw) != "Checking integrity of ufw*OK" ] || [ $(dpkg -s ufw) != "*not installed*" ]; then
	sudo eopkg install ufw
fi



# Setting terminal commands/service
# Saving known VPNs
# Finding fastest VPN


# Saving original host file as a .BAK with today's date in ISO format and then installing modified verson
if [ $INSTALLHOSTS = "install" ]; then
	sudo cp /etc/hosts /etc/hosts.BAK$TODAYISO
	if [ $DISTRO = "solus" ]; then
		sudo cp solus_hosts /etc/hosts
	elif [ $DISTRO = "debian" ]; then
		sudo cp debian_hosts /etc/hosts
	fi
fi





##################
# UNUSED RESOURCES
##################









