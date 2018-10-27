#!/bin/bash


# Set common variables
DISTRO="unknown"
VPNHOST="nord"
TODAYISO=`date '+%Y%m%d-%H%M'`


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
# Saving original host file as a .BAK with today's date in ISO format




