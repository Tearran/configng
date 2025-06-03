framework_options+=(
	["interface_categories,author"]="@tearran"
	["interface_categories,maintainer"]="@igorpecovnik"
	["interface_categories,feature"]="interface_categories"
	["interface_categories,options"]="System Network Localisation Software About"
	["interface_categories,desc"]="The main TUI menu list"
	["interface_categories,doc_link"]=""
	["interface_categories,group"]="Interface"
	["interface_categories,arch"]="x86-64 arm64 armhf"
)


_tui_system() {
	checkpoint debug "Text User Interface (TUI) is ($DIALOG)..."
	# Ordered list of keys
	local keys=(
		"Kernel"
		"Storage"
		"Access"
		"User"
		"Updates"
	)

	local -A description=(
		["Kernel"]="Alternative kernels, headers, rolling updates, overlays"
		["Storage"]="Install to internal media, ZFS, NFS, read-only rootfs"
		["Access"]="Manage SSH daemon options, enable 2FA"
		["User"]="Change shell, adjust MOTD"
		["Updates"]="OS updates and distribution upgrades"
	)

	for key in "${keys[@]}"; do
		eval "desc=\"$key - ${description[$key]}\""
		echo -e "$desc"
	done
}

_tui_network() {
	checkpoint debug "Text User Interface (TUI) is ($DIALOG)..."
	# Ordered list of keys
	local keys=(
		"Configuration"
		"Connectivity"
		"Security"
		"Diagnostics"
	)

	local -A description=(
		["Configuration"]="Network interfaces, wireless setup, IP configuration"
		["Connectivity"]="Bluetooth pairing, IPv6 toggle, connection management"
		["Security"]="QR codes for authentication, network security tools"
		["Diagnostics"]="Network testing, ping tools, connection status"
	)

	for key in "${keys[@]}"; do
		eval "desc=\"$key - ${description[$key]}\""
		echo -e "$desc"
	done
}

_tui_localisation() {
	checkpoint debug "Text User Interface (TUI) is ($DIALOG)..."
	# Ordered list of keys
	local keys=(
		"Timezone"
		"Language"
		"Keyboard"
	)

	local -A description=(
		["Timezone"]="Set global timezone and time settings"
		["Language"]="Configure locales, language and character set"
		["Keyboard"]="Change keyboard layout and input methods"
	)

	for key in "${keys[@]}"; do
		eval "desc=\"$key - ${description[$key]}\""
		echo -e "$desc"
	done
}

_tui_software() {
	checkpoint debug "Text User Interface (TUI) is ($DIALOG)..."

	local keys=(
		"WebHosting"
		"HomeAutomation"
		"DNS"
		"Music"
		"Desktops"
		"Downloaders"
		"Database"
		"DevTools"
		"Containers"
		"Media"
		"Monitoring"
		"Management"
		"Printing"
		"Netconfig"
	)

	local -A description=(
		["WebHosting"]="Web server, LEMP, reverse proxy, Let's Encrypt SSL"
		["HomeAutomation"]="Home Automation for control home appliances"
		["DNS"]="Network-wide ad blockers servers"
		["Music"]="Music servers and streamers"
		["Desktops"]="Desktop Environments"
		["Downloaders"]="Download apps for movies, TV shows, music and subtitles"
		["Database"]="SQL database servers and web interface managers"
		["DevTools"]="Applications and tools for development"
		["Containers"]="Docker containerization and KVM virtual machines"
		["Media"]="Media servers, organizers and editors"
		["Monitoring"]="Real-time monitoring, collecting metrics, up-time status"
		["Management"]="Remote Management tools"
		["Printing"]="Tools for printing and 3D printing"
		["Netconfig"]="Console network tools for measuring load and bandwidth"
	)

	for key in "${keys[@]}"; do
		eval "desc=\"$key - ${description[$key]}\""
		echo -e "$desc"
	done

}

_tui_about() {
	checkpoint debug "Text User Interface (TUI) is ($DIALOG)..."
	echo "Armbian Config: V3 Framework"
	echo
	echo "help"

	}

function interface_categories() {
	# Ordered list of keys
	local keys
	IFS=' ' read -r -a keys <<< "${framework_options["interface_categories,options"]}"

	local -A description=(
		["System"]="System wide and admin settings (\$(uname -m))"
		["Network"]="Fixed and wireless network settings (\$DEFAULT_ADAPTER)"
		["Localisation"]="Localisation (\$LANG)"
		["Software"]="Run/Install 3rd party applications (\$(see_current_apt))"
		["About"]="About this tool"
	)

	case "$1" in
		"${keys[0]}") interface_menu _tui_system ;;
		"${keys[1]}") interface_menu _tui_network ;;
		"${keys[2]}") interface_menu _tui_localisation	;;
		"${keys[3]}") interface_menu _tui_software	;;
		"${keys[4]}") interface_menu _tui_about | interface_message ;;
		"help")
		echo -e "\nUsage: ${framework_options["interface_categories,feature"]} <command>"
		echo -e "Options:  ${framework_options["interface_categories,options"]}"
		echo "Available Options:"
		for key in "${keys[@]}"; do
			eval "desc=\"${description[$key]}\""
			echo -e "\t$key\t- $desc"
		done
		echo
		;;
		*) ${framework_options["interface_categories,feature"]} ${keys[2]}	;;
	esac
}
