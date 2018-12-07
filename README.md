![VPN](Resources/logo.png)

# Dependencies
**Dependencies will be installed during installation if missing**  
ufw	# Used for network management  
openvpn	# Connects to VPN hosts/servers  
jq	# Simple json reader for Linux  
networkmanager-openvpn	# Improved integration of OpenVPN  
network-manager-openvpn	# Required for Debian based systems  
network-manager-openvpn-gnome	# Required for Debian based systems  


# Compatibility
Linux: Solus OS  
Linux: Debian based systems (anything using *apt-get* for package management)  
VPN Provider: NordVPN  
VPN Provider: Publicly available VPNs (use at your own risk)  

# LinuxVPNKillswitch (vswitch)
**vswitch**: "VPN kill Switch"  
A Linux VPN killswitch designed, primarily, for OpenVPN via NordVPN hosting.  

This script was written natively on Solus OS built with compatibility in-mind for Debian based systems.  

The methodology employed is to utilize ufw, an uncomplicated firewall, to block out all traffic not traveling through tun+ (tun0). In the event of a VPN disconnect all traffic will be blocked via firewall until either the connection is reestablished or the vswitch is disabled.  

A custom hosts file is also included. This will attempt to limit spam/ads/intrusive behavior from less reputable domains. At time of installation you will be prompted to install or skip this file. Should you choose to install; a backup hosts file will be created in the same directory and named "hosts.BAK20181027-1735" where the string of numbers represent the date of installation in ISO format.  

Once installation is complete you may remove the repo from your PC. To uninstall simply run the command **vswitch remove** to remove all remaining files.  

Usage documentation has been provided via man page. Run **man vswitch** to view options and settings.  

# Installation
Run `./install_vswitch.sh` script and `source /etc/bash_completion.d/vswitch`. Root permissions will be required.  
**For the lazy:**  
```shell
git clone https://github.com/MorningCoffeeZombie/LinuxVPNKillswitch.git
cd LinuxVPNKillswitch
./install_vswitch.sh
source /etc/bash_completion.d/vswitch
```


