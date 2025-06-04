
framework_options+=(
	["initialize_interface,author"]="@tearran"
	["initialize_interface,feature"]="initialize_interface"
	["initialize_interface,desc"]="Check for (Whiptail, DIALOG) tools and set the user interface."
	["initialize_interface,options"]=""
	["initialize_interface,group"]="Initialize"
)
#
# Check for (Whiptail, DIALOG, READ) tools and set the user interface
initialize_interface() {
	# Set dialog tool hierarchy based on environment
	if [[ -x "$(command -v whiptail)" ]]; then
		DIALOG="whiptail"
	elif [[ -x "$(command -v dialog)" ]]; then
		DIALOG="dialog"
	else
		die "TUI unavailable"
	fi
	checkpoint debug "Initialized (TUI) text user interface is ($DIALOG)..."
}
