
# Armbian Configuration Utility
Updated: Thu Sep 26 01:00:23 PM CDT 2024

Utility for configuring your board, adjusting services, and installing applications. It comes with Armbian by default and divided into four main sections:

- System       - system and security settings,
- Network      - wired, wireless, Bluetooth, access point,
- Localisation - timezone, language, hostname,
- Software     - system and 3rd party software install.

To start the Armbian configuration utility, use the following command:
~~~
sudo armbian-configng
~~~

## Install
Armbian installation
~~~
sudo apt install armbian-configng
~~~

3rd party Debian based distributions
~~~
{
	sudo wget https://apt.armbian.com/armbian.key -O key
	sudo gpg --dearmor < key | sudo tee /usr/share/keyrings/armbian.gpg > /dev/null
	sudo chmod go+r /usr/share/keyrings/armbian.gpg
	sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/armbian.gpg] http://apt.armbian.com $(lsb_release -cs) main  $(lsb_release -cs)-utils  $(lsb_release -cs)-desktop" | sudo tee /etc/apt/sources.list.d/armbian.list
	sudo apt update
	sudo apt install armbian-configng
}
~~~

***

## Command line options.

Use:
~~~
armbian-configng --help [System|Network|Localisation|Software]
~~~

Outputs:
~~~

  System - System wide and admin settings (aarch64)
    --cmd S01 - Enable Armbian kernel/firmware upgrades
    --cmd S02 - Disable Armbian kernel upgrades
    --cmd S03 - Edit the boot environment
    --cmd S04 - Install Linux headers
    --cmd S05 - Remove Linux headers
    --cmd S06 - Install to internal storage
    S07.1 - Manage SSH login options
	--cmd S07 - Disable root login
	--cmd S08 - Enable root login
	--cmd S09 - Disable password login
	--cmd S10 - Enable password login
	--cmd S11 - Disable Public key authentication login
	--cmd S12 - Enable Public key authentication login
	--cmd S13 - Disable OTP authentication
	--cmd S14 - Enable OTP authentication
	--cmd S15 - Generate new OTP authentication QR code
	--cmd S16 - Show OTP authentication QR code
	--cmd S30 - Disable last login banner
	--cmd S31 - Enable last login banner
    --cmd S17 - Change shell system wide to BASH
    --cmd S18 - Change shell system wide to ZSH
    --cmd S19 - Switch to rolling release
    --cmd S20 - Switch to stable release
    --cmd S21 - Enable read only filesystem
    --cmd S22 - Disable read only filesystem
    --cmd S23 - Adjust welcome screen (motd)
    --cmd S24 - Install alternative kernels
~~~

~~~

  Network - Fixed and wireless network settings (wlan0)
    N01 - Configure network interfaces
	--cmd N02 - Add interface
	--cmd N03 - Revert to defaults
	--cmd N04 - Show draft configuration
	--cmd N05 - Apply changes
	--cmd N06 - Show active status
    --cmd N15 - Install Bluetooth support
    --cmd N16 - Remove Bluetooth support
    --cmd N17 - Bluetooth Discover
    --cmd N18 - Toggle system IPv6/IPv4 internet protocol
~~~

~~~

  Localisation - Localisation (en_US.UTF-8)
    --cmd L00 - Change Global timezone (WIP)
    --cmd L01 - Change Locales reconfigure the language and character set
    --cmd L02 - Change Keyboard layout
    --cmd L03 - Change APT mirrors
~~~

~~~

  Software - Run/Install 3rd party applications (Update the package lists.)
    Desktops - Install Desktop Environments
	--cmd SW02 - Install XFCE desktop
	--cmd SW03 - Install Gnome desktop
	--cmd SW04 - Install i3-wm desktop
	--cmd SW05 - Install Cinnamon desktop
	--cmd SW06 - Install kde-neon desktop
    Netconfig - Network tools
	--cmd SW08 - Install realtime console network usage monitor (nload)
	--cmd SW09 - Remove realtime console network usage monitor (nload)
	--cmd SW10 - Install bandwidth measuring tool (iperf3)
	--cmd SW11 - Remove bandwidth measuring tool (iperf3)
	--cmd SW12 - Install IP LAN monitor (iptraf-ng)
	--cmd SW13 - Remove IP LAN monitor (iptraf-ng)
	--cmd SW14 - Install hostname broadcast via mDNS (avahi-daemon)
	--cmd SW15 - Remove hostname broadcast via mDNS (avahi-daemon)
    DevTools - Development
	--cmd SW17 - Install tools for cloning and managing repositories (git)
	--cmd SW18 - Remove tools for cloning and managing repositories (git)
    --cmd Benchy - System benchmaking and diagnostics
    Containers - Containerlization and Virtual Machines
	--cmd SW25 - Install Docker Minimal
	--cmd SW26 - Install Docker Engine
	--cmd SW27 - Remove Docker
	--cmd SW28 - Purge all Docker images, containers, and volumes
    Media - Media Servers and Editors
	--cmd SW21 - Install Plex Media server
	--cmd SW22 - Remove Plex Media server
	--cmd SW23 - Install Emby server
	--cmd SW24 - Remove Emby server
    Management - Remote Management tools
	--cmd M00 - Install Cockpit web-based management tool
	--cmd M01 - Purge Cockpit web-based management tool
	--cmd M02 - Start Cockpit Service
	--cmd M03 - Stop Cockpit Service
~~~

***

## Development

Development is divided into two sections:

## Jobs / JSON Object

~~~
lib/armbian-configng/config.ng.jobs.json
~~~

## Jobs API / Helper Functions

These helper functions facilitate various operations related to job management, such as creation, updating, deletion, and listing of jobs, acting as a practical API for developers.

| Description | Example | Credit |
|:----------- | ------- |:------:|
| Generate a Help message legacy cli commands. | see_cli_legacy | Joey Turner 
| Run time variables Migrated procedures from Armbian config. | set_runtime_variables | Igor Pecovnik 
| Toggle SSH lastlog | toggle_ssh_lastlog | tearran 
| Set Armbian to rolling release | set_rolling | Tearran 
| Generate this markdown table of all module_options | see_function_table_md | Joey Turner 
| Switching to alternative kernels |  | Igor 
| Set Armbian root filesystem to read only | manage_overlayfs enable|disable | igorpecovnik 
| Display a menu from pipe | show_menu <<< armbianmonitor -h  ;  | Joey Turner 
| Build the main menu from a object | generate_top_menu 'json_data' | Joey Turner 
| Migrated procedures from Armbian config. | is_package_manager_running | Igor Pecovnik 
| Migrated procedures from Armbian config. | check_desktop | Igor Pecovnik 
| Generate Document files. | generate_readme | Joey Turner 
| Needed by generate_menu |  | Joey Turner 
| Display a Yes/No dialog box and process continue/exit | get_user_continue 'Do you wish to continue?' process_input | Joey Turner 
| Display a message box | show_message <<< 'hello world'  | Joey Turner 
| Migrated procedures from Armbian config. | connect_bt_interface | Igor Pecovnik 
| Menu for armbianmonitor features | see_monitoring | Joey Turner 
| Show or generate QR code for Google OTP | qr_code generate | Igor Pecovnik 
| Check if kernel headers are installed | are_headers_installed | Gunjan Gupta 
| Check when apt list was last updated and suggest updating or update | see_current_apt || see_current_apt update | Joey Turner 
| Migrated procedures from Armbian config. | check_if_installed nano | Igor Pecovnik 
| Generate 'Armbian CPU logo' SVG for document file. | generate_svg | Joey Turner 
| Remove Linux headers | Headers_remove | Joey Turner 
| Update submenu descriptions based on conditions | update_submenu_data | Joey Turner 
| sanitize input cli | sanitize_input |  
| Check if a domain is reachable via IPv4 and IPv6 | check_ip_version google.com | Joey Turner 
| Migrated procedures from Armbian config. | set_header_remove | Igor Pecovnik 
| Generate a submenu from a parent_id | generate_menu 'parent_id' | Joey Turner 
| Generate a markdown list json objects using jq. | see_jq_menu_list | Joey Turner 
| Generate jobs from JSON file. | generate_jobs_from_json | Joey Turner 
| Install kernel headers | is_package_manager_running | Joey Turner 
| Toggle IPv6 on or off | toggle_ipv6 | Joey Turner 
| Adjust welcome screen (motd) |  | igorpecovnik 
| Generate JSON-like object file. | generate_json | Joey Turner 
| Install DE | install_de | Igor Pecovnik 
| Install wrapper | apt_install_wrapper apt-get -y purge armbian-zsh | igorpecovnik 
| Netplan wrapper | network_config | Igor Pecovnik 
| Change the background color of the terminal or dialog box | set_colors 0-7 | Joey Turner 
| Serve the edit and debug server. | serve_doc | Joey Turner 
| Update JSON data with system information | update_json_data | Joey Turner 
| pipeline strings to an infobox  | show_infobox <<< 'hello world' ;  | Joey Turner 
| Parse json to get list of desired menu or submenu items | parse_menu_items 'menu_options_array' | Gunjan Gupta 
| Show the usage of the functions. | see_use | Joey Turner 
| Generate a Help message for cli commands. | see_cmd_list [catagory] | Joey Turner 
| Revert network config back to Armbian defaults | default_network_config | Igor Pecovnik 
| freeze/unhold/reinstall armbian related packages. | armbian_fw_manipulate unhold|freeze|reinstall | Igor Pecovnik 
| Check the internet connection with fallback DNS | see_ping | Joey Turner 
| Install docker from a repo using apt | install_docker engine | Kat Schwarz 
| Set Armbian to stable release | set_stable | Tearran 
| Secure version of get_user_continue | get_user_continue_secure 'Do you wish to continue?' process_input | Joey Turner 



## Testing and contributing


Get Development and contribute:

Install the dependencies:
~~~
sudo apt install git jq whiptail
~~~

Get Development and contribute:
~~~
{
git clone https://github.com/armbian/configng
cd configng
./armbian-configng --help
}
~~~

Install and test Development deb:
~~~
{
	sudo apt install whiptail
	latest_release=$(curl -s https://api.github.com/repos/armbian/configng/releases/latest)
	deb_url=$(echo "$latest_release" | jq -r '.assets[] | select(.name | endswith(".deb")) | .browser_download_url')
	curl -LO "$deb_url"
	deb_file=$(echo "$deb_url" | awk -F"/" '{print $NF}')
	sudo dpkg -i "$deb_file"
	sudo dpkg --configure -a
	sudo apt --fix-broken install
}
~~~


