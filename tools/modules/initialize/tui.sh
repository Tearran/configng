framework_options+=(
	["initialize_interface,author"]="@tearran"
	["initialize_interface,feature"]="initialize_interface"
	["initialize_interface,desc"]="Check for (Whiptail, DIALOG) tools and set the user interface."
	["initialize_interface,options"]=""
	["initialize_interface,group"]="Initialize"
)
#
# Detects and initializes the available text user interface (TUI) tool.
#
# Globals:
#
# * DIALOG: Set to "whiptail" or "dialog" depending on availability.
#
# Arguments:
#
# * None
#
# Outputs:
#
# * Error message to STDERR and exits if no TUI tool is available.
#
# Example:
#
# ```bash
# initialize_interface
# # DIALOG is now set to "whiptail" or "dialog"
# ```
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
