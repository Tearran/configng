module_options+=(
	["default_wireless_network_config,author"]="@igorpecovnik"
	["default_wireless_network_config,ref_link"]=""
	["default_wireless_network_config,feature"]="default_wireless_network_config"
	["default_wireless_network_config,desc"]="Stop hostapd, clean config"
	["default_wireless_network_config,options"]=""
	["default_wireless_network_config,doc_link"]=""
	["default_wireless_network_config,group"]="Network"
)
# Removes wireless access point configuration and cleans up related services and files.
#
# Arguments:
#
# * yamlfile: (Optional) Name of the netplan YAML file (without extension) to modify. Defaults to "armbian".
# * adapter: (Optional) Name of the wireless adapter to remove. Defaults to "wlan0".
#
# Globals:
#
# * NETWORK_RENDERER: Determines which network management backend is active.
#
# Outputs:
#
# * Modifies or deletes configuration files and may output errors or status messages from invoked commands.
#
# Returns:
#
# * None.
#
# Example:
#
# ```bash
# default_wireless_network_config myconfig wlan1
# ```
#
# This function removes WiFi configuration for the specified adapter from the given netplan YAML file, deletes dispatcher hooks, stops and disables hostapd if running, applies netplan changes, and uninstalls related packages depending on the network renderer.
function default_wireless_network_config(){

	# defaul yaml file
	local yamlfile=${1:-armbian}
	local adapter=${2:-wlan0}

	# remove wifi from netplan
	if [[ -f /etc/netplan/${yamlfile}.yaml ]]; then
		sed -i -e 'H;x;/^\(  *\)\n\1/{s/\n.*//;x;d;}' -e 's/.*//;x;/'$adapter':/{s/^\( *\).*/ \1/;x;d;}' /etc/netplan/${yamlfile}.yaml
		sed -i -e 'H;x;/^\(  *\)\n\1/{s/\n.*//;x;d;}' -e 's/.*//;x;/- '$adapter'/{s/^\( *\).*/ \1/;x;d;}' /etc/netplan/${yamlfile}.yaml
		sed -i -e 'H;x;/^\(  *\)\n\1/{s/\n.*//;x;d;}' -e 's/.*//;x;/wifis:/{s/^\( *\).*/ \1/;x;d;}' /etc/netplan/${yamlfile}.yaml
	fi

	# remove networkd-dispatcher hook
	rm -f /etc/networkd-dispatcher/carrier.d/armbian-ap
	# remove network-manager dispatcher hook
	rm -f /etc/NetworkManager/dispatcher.d/armbian-ap

	# hostapd needs more cleaning
	if srv_active hostapd; then
		srv_stop hostapd
		srv_disable hostapd
	fi

	# apply config
	netplan apply

	# exceptions
	if [[ "${NETWORK_RENDERER}" == "NetworkManager" ]]; then
		# uninstall packages
		pkg_remove hostapd
		srv_restart NetworkManager
	else
		# uninstall packages
		pkg_remove hostapd networkd-dispatcher
		brctl delif br0 $adapter 2> /dev/null
		networkctl reconfigure br0
	fi

}
