#!/bin/bash

PROTOCOL="udp"
VPNHOST="nord"

# Command: vswitch

function vswitch(){
	# Help/manual pages
	if [ "$1" = "" ]; then
		echo "Enter an argument or use \"man vswitch\" to view usage"
	fi
	if [ "$1" = "help" ] || [ "$1" = "/?" ] ; then
		man vswitch
	fi
	
	# Settings
	if [ "$1" = "update" ] || [ "$1" = "up" ] ; then
		# Taken from:   https://nordvpn.com/tutorials/linux/openvpn/
		cd  /etc/openvpn
		sudo wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
		sudo eopkg install ca-certificates
		sudo unzip ovpn.zip
		sudo rm ovpn.zip
		cd ovpn_${PROTOCOL,,}   # Sets ovpn_ to declared variable in lower case
	fi
	if [ "$1" = "host*" ]; then
		VPNHOST="$2"
			if [ "$2" = "" ]; then
				PS3='Choose from a list of supported VPN providers: '
				options=("NordVPN" "Quit")
				select provider in "${options[@]}"
				do
				case $provider in
					"NordVPN")
						VPNHOST="nord"; echo "$provider entered"; break;;
					"Quit")
						break;;
					*) echo "invalid option $REPLY";;
				esac
				done				
			fi
	fi
	
	# Connect and engage
	if [ "$1" = "connect*" ]; then
	
	fi
	if [ "$1" = "disconnect*" ]; then
	
	fi
	if [ "$1" = "on" ] || [ "$1" = "engage" ] ; then

	fi
	if [ "$1" = "off*" ] || [ "$1" = "disengage*" ] ; then
	
	fi
}


echo you typed $1
echo you may have typed $2





