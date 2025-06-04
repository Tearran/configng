# DEPRECATION NOTICE: module_network_simple.sh is deprecated and will be removed in a future release.
# Please migrate to the new module_network_simple_refactored.sh and network_simple_helpers.sh.
network_options+=(
	["module_simple_network,author"]="@igorpecovnik"
	["module_simple_network,maintainer"]="@igorpecovnik"
	["module_simple_network,feature"]="module_simple_network"
	["module_simple_network,options"]="help simple advanced ipmode select store restore dhcp static remove"
	["module_simple_network,desc"]="Netplan wrapper"
	["module_simple_network,doc_link"]="tools/modules/network/module_network_simple_refactored.sh and tools/modules/network/network_simple_helpers.sh"
	["module_simple_network,group"]="Network"
	["module_simple_network,port"]=""
	["module_simple_network,arch"]="x86-64 arm64 armhf riscv64"
)

#
# Function to select network adapter
#
function module_simple_network() {
	# Runtime deprecation warning & forward to the new implementation
	echo "Warning: module_simple_network is deprecated; delegating to module_simple_network_refactored" >&2
	module_simple_network_refactored "$@"
	return $?

	local title="network"
	local condition=$(which "$title" 2>/dev/null)

	# Convert the options string to an array
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
			# store current configs to temporal folder
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
						# set dhcp on adapter
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
						address=${ips[0]} # use only 1st one
						[[ -z "${address}" ]] && address="1.2.3.4/5"
						address=$($DIALOG --title "Enter IP for $adapter" --inputbox "\nValid format: $address" 9 40 "$address" 3>&1 1>&2 2>&3)
						route_to="0.0.0.0/0"
						route_to=$($DIALOG --title "Use default route or set static" --inputbox "\nValid format: $route_to" 9 40 "$route_to" 3>&1 1>&2 2>&3)
						route_via=$(ip route show default | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]" | head -1 | xargs)
						route_via=$($DIALOG --title "Enter IP for gateway" --inputbox "\nValid format: $route_via" 9 40 "$route_via" 3>&1 1>&2 2>&3)
						nameservers="9.9.9.9,1.1.1.1"
						nameservers=$($DIALOG --title "Enter DNS server" --inputbox "\nValid format: $nameservers" 9 40 "$nameservers" 3>&1 1>&2 2>&3)
						# set fixed ip on adapter
						${network_options["module_simple_network,feature"]} $STATIC_CMD "$2" "$3"
					fi
				fi
			fi
			;;
		"$SELECT_CMD")
			# init arrays
			list=()
			pair=()

			# base of channels
			declare -A CHANNELS=(
				['2412']='1' ['2417']='2' ['2422']='3' ['2427']='4'
				['2432']='5' ['2437']='6' ['2442']='7' ['2447']='8'
				['2452']='9' ['2457']='10' ['2462']='11' ['2467']='12'
				['2472']='13' ['5180']='36' ['5200']='40' ['5220']='44'
				['5240']='48' ['5260']='52' ['5280']='56' ['5300']='60'
				['5320']='64' ['5500']='100' ['5520']='104' ['5540']='108'
				['5560']='112' ['5580']='116' ['5600']='120' ['5620']='124'
				['5640']='128' ['5660']='132' ['5680']='136' ['5700']='140'
				['5720']='144' ['5745']='149' ['5765']='153' ['5785']='157'
				['5805']='161' ['5825']='165'
			)

			# ensure line-end splitting only
			default_IFS=$IFS
			IFS='
'
			# capture grep output in "iw" scan command into array
			local iw_command=( \
				$(lc_all=C sudo iw dev $adapter scan \
				| grep -o 'BSS ..\:..\:..:..\:..\:..\|SSID: .*\|signal\: .* \|freq\: .*') \
			)
			# Reset IFS
			IFS=$default_IFS

			COUNT=1
			# parse scan output
			for line in "${iw_command[@]}"; do
				default_IFS=$IFS
				IFS=" 	"
				if [[ $line =~ BSS ]]; then
					bss_array=( $line )
					bssid=${bss_array[1]}
				fi
				if [[ $line =~ "freq:" ]]; then
					freq_array=( $line )
					freq=$(echo ${freq_array[1]} | cut -d"." -f1)
				fi
				if [[ $line =~ "signal:" ]]; then
					signal_array=( $line )
					rssi=$(echo ${signal_array[1]} | cut -d"." -f1)
				fi
				if [[ $line =~ "SSID" ]]; then
					ssid_array=( $line )
					unset ssid_array[0]
					ssid=${ssid_array[@]}
				fi
				if [ $COUNT -eq 4 ]; then
					channel=$(printf '%3s' "${CHANNELS[$freq]}")
					list+=("${bssid}" "$(printf "%-25s%6s%8s Mhz %7s" "${ssid:-"Invisible SSID"}" ${rssi} ${freq} ${channel})")
					pair+=(${bssid}="${ssid}")
					COUNT=0
					unset bssid ssid freq rssi channel ssid_array signal_array freq_array bss_array grep_output
				fi
				((COUNT++))
			done
			SELECTED_BSSID=$($DIALOG \
				--notags \
				--title "Select SSID" \
				--menu "\nSSID                     Signal   Frequency Channel" \
				$((${#list[@]}/2 + 10 )) 57 $((${#list[@]}/2 )) "${list[@]}" 3>&1 1>&2 2>&3)
			if [[ $? -eq 0 ]]; then
				for elt in "${pair[@]}"; do
					if [[ $elt == *$SELECTED_BSSID* && -n "{SELECTED_BSSID}" ]]; then
						SELECTED_SSID=$(echo "$elt" | cut -d"=" -f2)
						while true; do
							SELECTED_PASSWORD=$($DIALOG --title "Enter password for ${SELECTED_SSID}" --passwordbox "" 7 50 3>&1 1>&2 2>&3)
							if [[ -z "$SELECTED_PASSWORD" || ${#SELECTED_PASSWORD} -ge 8 ]]; then
								break
							else
								$DIALOG --msgbox "Passphrase must be between 8 and 63 characters!" 7 51 --title "Error"
							fi
						done
					fi
				done
			fi
			;;
		"$STORE_CMD")
			# list adapters
			local list=()
			for f in /sys/class/net/*; do
				local interface=$(basename $f)
				if [[ $interface =~ ^dummy0|^lo|^docker|^virbr|^br ]]; then continue; fi
				[[ $interface == w* && $interface != wa* ]] && devicetype="wifi" || devicetype="wired"
				local query=$(ip -4 -br addr show dev $interface | awk '{print $3}')
				list+=("${interface}" "$(printf "%-16s%18s%9s" ${interface} ${query:-unasigned} ${devicetype})")
			done
			adapter=$($DIALOG --notags --title "Select interface" --menu "\n Adaptor                 IP address     Type" \
				$((${#list[@]}/2 + 10 )) 50 $((${#list[@]}/2 + 1)) "${list[@]}" 3>&1 1>&2 2>&3)
			if [[ $? -eq 0 ]]; then
				if $DIALOG --title "Action for ${adapter}" --yes-button "Configure" --no-button "Drop" --yesno "$1" 5 60; then
					ip link set ${adapter} up
				else
					${network_options["module_simple_network,feature"]} $REMOVE_CMD "${adapter}"
					netplan apply
					${network_options["module_simple_network,feature"]} $SELECT_CMD "$2"
				fi
			fi
			;;
		"$RESTORE_CMD")
			# restore current NetPlan configs
			if [[ -n ${restore_netplan_config_folder} ]]; then
				rm -f /etc/netplan/*
				rsync -ar ${restore_netplan_config_folder}/. /etc/netplan
			fi
			;;
		"$DHCP_CMD")
			# drop current settings
			${network_options["module_simple_network,feature"]} $REMOVE_CMD "${adapter}"
			# dhcp
			netplan set --origin-hint ${yamlfile} renderer=${NETWORK_RENDERER}
			# wifi needs ap
			if [[ $3 == wifis ]]; then
				if [[ -z "${SELECTED_PASSWORD}" ]]; then
					netplan set --origin-hint ${yamlfile} $3.$adapter.access-points."${SELECTED_SSID//./\\.}".auth.key-management=none
				else
					netplan set --origin-hint ${yamlfile} $3.$adapter.access-points."${SELECTED_SSID//./\\.}".password="${SELECTED_PASSWORD}"
				fi
			fi
			netplan set --origin-hint ${yamlfile} $3.$adapter.dhcp4=yes
			netplan set --origin-hint ${yamlfile} $3.$adapter.dhcp6=yes
			netplan set --origin-hint ${yamlfile} $3.$adapter.macaddress=''$mac_address''
			netplan apply
			;;
		"$STATIC_CMD")
			# drop current settings
			${network_options["module_simple_network,feature"]} $REMOVE_CMD "${adapter}"
			# static
			netplan set --origin-hint ${yamlfile} renderer=${NETWORK_RENDERER}
			# wifi needs ap
			if [[ $3 == wifis ]]; then
				if [[ -z "${SELECTED_PASSWORD}" ]]; then
					netplan set --origin-hint ${yamlfile} $3.$adapter.access-points."${SELECTED_SSID//./\\.}".auth.key-management=none
				else
					netplan set --origin-hint ${yamlfile} $3.$adapter.access-points."${SELECTED_SSID//./\\.}".password="${SELECTED_PASSWORD}"
				fi
			fi
			netplan set --origin-hint ${yamlfile} $3.$adapter.dhcp4=no
			netplan set --origin-hint ${yamlfile} $3.$adapter.dhcp6=no
			netplan set --origin-hint ${yamlfile} $3.$adapter.macaddress=''$mac_address''
			netplan set --origin-hint ${yamlfile} $3.$adapter.addresses='['$address']'
			netplan set --origin-hint ${yamlfile} $3.$adapter.routes='[{"to":"'$route_to'", "via": "'$route_via'","metric":200}]'
			netplan set --origin-hint ${yamlfile} $3.$adapter.nameservers.addresses='['$nameservers']'
			netplan apply
			;;
		"$REMOVE_CMD")
			# remove adapter from yaml file
			sed -i -e 'H;x;/^\(  *\)\n\1/{s/\n.*//;x;d;}' \
				-e 's/.*//;x;/'${2}'/{s/^\( *\).*/ \1/;x;d;}' /etc/netplan/${yamlfile}.yaml
			# awk solution to clean out empty wifis or ethernets sections
			cat /etc/netplan/${yamlfile}.yaml | awk 'BEGIN {
				re = "[^[:space:]-]"
				if (getline != 1) exit
				while (1) {
					last = $0; last_nf = NF
					if (getline != 1) {
						if (last_nf != 1) print last
						exit
					}
					if (last_nf == 1 && match(last, re) == match($0, re)) continue
					print last
				}
			} $1' > /etc/netplan/${yamlfile}.yaml.tmp
			mv /etc/netplan/${yamlfile}.yaml.tmp /etc/netplan/${yamlfile}.yaml
			chmod 600 /etc/netplan/${yamlfile}.yaml
			;;
		*)
			${network_options["module_simple_network,feature"]} $HELP_CMD
			;;
	esac
