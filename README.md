![VPN](http://ais.its.psu.edu/files/2015/06/vpn-logo.png)

# Dependencies
ufw	# Used for network management  
openvpn	# Connects to VPN hosts/servers  
jq	# Simple json reader for Linux  

# Compatibility
Linux: Solus OS  
Linux: Debian based systems (Ubuntu + derivatives, Mint, Debian, Pure, Kali, Parrot and Tails)  
VPN Provider: NordVPN  
VPN Provider: Publicly available VPNs (use at your own risk)  

# LinuxVPNKillswitch
**vswitch**: "VPN kill Switch"  
A Linux VPN killswitch designed, primarily, for OpenVPN via NordVPN hosting.  

This script was written natively on Solus OS built with compatibility in-mind for Debian based systems.  

The methodology employed is to utilize ufw, an uncomplicated firewall, to block out all traffic not traveling through tun0. In the event of a VPN disconnect all traffic will be blocked via firewall until either the connection is reestablished or the vswitch is disabled.  

A custom hosts file is also included. This will attempt to limit spam/ads/intrusive behavior from less reputable domains. At time of installation you will be prompted to install or skip this file. Should you choose to install; a backup hosts file will be created in the same directory and named "hosts.BAK20181027-1735" where the string of numbers represent the date of installation in ISO format.  

Once installation is complete you may remove the repo from your PC. To uninstall simply run the command **vswitch remove** to remove all remaining files.  

Usage documentation has been provided via man page. Run **man vswitch** to view options and settings.  




