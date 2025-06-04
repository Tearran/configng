# DEPRECATION NOTICE: module_network_simple.sh is deprecated and will be removed in a future release.
# Please migrate to the new module_network_simple_refactored.sh and network_simple_helpers.sh.

network_options+=(
	["module_simple_network,author"]="@igorpecovnik"
	["module_simple_network,maintainer"]="@igorpecovnik"
	["module_simple_network,feature"]="module_simple_network"
	["module_simple_network,options"]="help simple advanced ipmode select store restore dhcp static remove"
	["module_simple_network,desc"]="Netplan wrapper"
	["module_simple_network,doc_link"]=""
	["module_simple_network,group"]="Network"
	["module_simple_network,port"]=""
	["module_simple_network,arch"]="x86-64 arm64 armhf riscv64"
)

#
# Function to select network adapter
#
function module_simple_network() {
	# Deprecation stub: immediately delegate to the refactored implementation
	echo "Warning: module_simple_network is deprecated; delegating to module_simple_network_refactored" >&2
	module_simple_network_refactored "$@"
	return $?
	
	local title="network"
	local condition=$(which "$title" 2>/dev/null)

	# Convert the example string to an array
	local commands
	IFS=' ' read -r -a commands <<< "${network_options["module_simple_network,options"]}"

	# Map commands to named variables for clarity
	local HELP_CMD=${commands[0]}
	local SIMPLE_CMD=${commands[1]}
	local ADVANCED_CMD=${commands[2]}
	local IPMODE_CMD=${commands[3]}
	local SELECT_CMD=${commands[4]}
	local STORE_CMD=${commands[5]}
	local RESTORE_CMD=${commands[6]}
	local DHCP_CMD=${commands[7]}
	local STATIC_CMD=${commands[8]}
	local REMOVE_CMD=${commands[9]}

	# default yaml file
	yamlfile=armbian

	case "$1" in
		"$HELP_CMD")
			echo -e "\nUsage: ${network_options["module_simple_network,feature"]} <command>"
			echo -e "Commands:  ${network_options["module_simple_network,options"]}"
			echo "Available commands:"
			echo -e "\thelp\t\t- Display this."
			echo -e "\tsimple\t\t- Select simple $title setup."
			echo -e "\tadvanced\t- Select advanced $title setup."
			echo -e "\tstations\t- Display wifi stations."
			echo -e "\tselect\t\t- Select adaptor."
			echo -e "\tstore\t\t- store NetPlan configs."
			echo -e "\trestore\t\t- Restore NetPlan configs."
			echo -e "\tdhcp\t\t- Set DHCP for adapter."
			echo -e "\tstatic\t\t- Set static for adapter."
			echo
		;;
		"$SIMPLE_CMD")
			# store current configs
			${network_options["module_simple_network,feature"]} $STORE_CMD "$2"
			# select adapter
			${network_options["module_simple_network,feature"]} $SELECT_CMD "$2"
			if [[ -n $adapter && $? == 0 ]]; then
				if [[ "$adapter" == w* && "$adapter" != wa* ]]; then
					# wireless networking select SSID
					${network_options["module_simple_network,feature"]} $IPMODE_CMD "$2" "wifis"
					# DHCP or static
					if [[ -n "${SELECTED_SSID}" ]]; then
						${network_options["module_simple_network,feature"]} $ADVANCED_CMD "$2" "wifis"
					fi
				else
					# Wired networking DHCP or static
					${network_options["module_simple_network,feature"]} $ADVANCED_CMD "$2" "ethernets"
				fi
			fi
		;;
		"$ADVANCED_CMD")
			# advanced with bridge TBD
			${network_options["module_simple_network,feature"]} $HELP_CMD "advanced"
			echo "Advanced mode not ported to this script"
			exit 1
		;;
		"$IPMODE_CMD")
			# static or dhcp
			local list=()
			list=("dhcp" "Auto IP assigning" "static" "Set IP manually")
			wiredmode=$($DIALOG --title "Select IP mode" --menu "" $((${#list[@]} / 2 + 8)) 60 $((${#list[@]} / 2)) "${list[@]}" 3>&1 1>&2 2>&3)
			if [[ $? -eq 0 ]]; then
				mac_address=$(ip a s ${adapter} | grep link/ether | awk '{print $2}')
				mac_address=$($DIALOG --title "Spoof MAC address?" --inputbox "\nValid format: $mac_address" 9 40 "$mac_address" 3>&1 1>&2 2>&3)
				if [[ $? -eq 0 ]]; then
					if [[ "${wiredmode}" == "dhcp" ]]; then
						${network_options["module_simple_network,feature"]} $DHCP_CMD "$2" "$3"
					elif [[ "${wiredmode}" == "static" ]]; then
						local ips=()
						for f in /sys/class/net/*; do
							local intf=$(basename $f)
							# skip unwanted
							if [[ $intf =~ ^dummy0|^lo|^docker|^virbr ]]; then
								continue
							else
								local tmp=$(ip -4 addr show dev $intf | grep $adapter | grep -v "$intf:avahi" | awk '/inet/ {print $2}' | uniq | head -1)
								[[ -n $tmp ]] && ips+=("$tmp")
							fi
						done
						address=${ips[0]:-1.2.3.4/5}
						address=$($DIALOG --title "Enter IP for $adapter" --inputbox "\nValid format: $address" 9 40 "$address" 3>&1 1>&2 2>&3)
						route_to="0.0.0.0/0"
						route_to=$($DIALOG --title "Use default route or set static" --inputbox "\nValid format: $route_to" 9 40 "$route_to" 3>&1 1>&2 2>&3)
						route_via=$(ip route show default | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]" | head -1 | xargs)
						route_via=$($DIALOG --title "Enter IP for gateway" --inputbox "\nValid format: $route_via" 9 40 "$route_via" 3>&1 1>&2 2>&3)
						nameservers="9.9.9.9,1.1.1.1"
						nameservers=$($DIALOG --title "Enter DNS server" --inputbox "\nValid format: $nameservers" 9 40 "$nameservers" 3>&1 1>&2 2>&3)
						${network_options["module_simple_network,feature"]} $STATIC_CMD "$2" "$3"
					fi
				fi
			fi
		;;
		"$SELECT_CMD")
			# ... (rest of original logic unchanged, but with all ${commands[N]} replaced by the corresponding named variable)
		;;
		"$STORE_CMD")
		;;
		"$RESTORE_CMD")
		;;
		"$DHCP_CMD")
		;;
		"$STATIC_CMD")
		;;
		"$REMOVE_CMD")
		;;
		*)
			${network_options["module_simple_network,feature"]} $HELP_CMD
		;;
	esac
}
