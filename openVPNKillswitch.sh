#!/bin/bash

PROTOCOL="udp"
VPNHOST="nord"

# Command: vswitch

function vswitch(){
	################
	# HELP/MAN PAGES
	################
	if [ "$1" = "" ]; then
		echo "Enter an argument or use \"man vswitch\" to view usage"
	fi
	if [ "$1" = "help" ] || [ "$1" = "/?" ] ; then
		man vswitch
	fi
	

	##########
	# SETTINGS
	##########
	if [ "$1" = "update" ] || [ "$1" = "up" ] ; then
		# Taken from:   https://nordvpn.com/tutorials/linux/openvpn/
		cd  /etc/openvpn
			if [ "$VPNHOST" = "nord" ]; then	
				sudo wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
				if [ $(uname -s) = *solus* ]; then
				sudo eopkg install ca-certificates
			else
				sudo apt-get install ca-certificates	
			fi
			sudo unzip ovpn.zip
			sudo rm ovpn.zip
			cd /etc/openvpn/ovpn_${PROTOCOL,,}   # Sets ovpn_ to declared variable in lower case
		fi
	fi
	if [ "$1" = "host*" ]; then
		VPNHOST="$2"
		if [ "$2" = "" ] || [ "$2" != "Nord*" ] || [ "$2" != "nord*" ]; then
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
	if [ "$1" = "protocol" ] || [ "$1" = "pr" ]; then
		PROTOCOL="$2"
		if [ "$2" = "" ] || [ "$2" != "udp" ] || [ "$2" != "tcp" ]; then
			PS3='What protocol would you like to connect via? '
			options=("UDP" "TCP" "Either" "Quit")
			select method in "${options[@]}"
			do
				case $method in
				"UDP")
					PROTOCOL=${method,,}; echo "$method entered"; break;;
				"TCP")
					PROTOCOL=${method,,}; echo "$method entered"; break;;
				"Either")
					PROTOCOL="udp"; echo "$method entered"; break;;
				"Quit")
					echo "Quiting program"; exit; break;;
				*) echo "invalid option $REPLY";;
			esac
			done
		fi
		vswitch protocol $PROTOCOL
	fi
#	if [ "$1" = "status" ]; then
#
#	fi
	

	####################
	# CONNECT AND ENABLE
	####################
#	if [ "$1" = "connect*" ]; then
#		
#	fi
#	if [ "$1" = "disconnect*" ]; then
#		
#	fi
	if [ "$1" = "on" ] || [ "$1" = "engage" ] || [ "$1" = "enable" ] ; then
		# Copied from:	https://thetinhat.com/tutorials/misc/linux-vpn-drop-protection-firewall.html
		sudo ufw reset
		sudo ufw default deny incoming
		sudo ufw default deny outgoing
		sudo ufw allow out on tun0 from any to any
		sudo ufw enable
		echo "VPN killswitch enabled"
	fi
	if [ "$1" = "off*" ] || [ "$1" = "disengage*" ] || [ "$1" = "disenable" ] ; then
		# Copied from:	https://thetinhat.com/tutorials/misc/linux-vpn-drop-protection-firewall.html
		sudo ufw reset
		sudo ufw default deny incoming
		sudo ufw default allow outgoing
		sudo ufw enable
		echo "VPN killswitch disabled"
	fi
}



################################################
# TESTING SECTION - delete when script completed
################################################
echo you typed \(as raw\) $1
echo you typed \(as bracket\) ${1}
echo "you typed (as raw ouside quotes)" $1
echo "you typed (as bracket outside quotes)" ${1}
echo you may have typed $2
TESTER="$2"
echo $TESTER "var in quotes"
TESTER=$2
echo $TESTER "var NOT in quotes"


#sudo echo "source /home/solus/Desktop/openVPNKillswitch.sh">>/etc/skel/.bashrc














