framework_options+=(
	["interface_yes_no,author"]="@Tearran"
	["interface_yes_no,ref_link"]=""
	["interface_yes_no,feature"]="interface_yes_no"
	["interface_yes_no,desc"]="yes/no User Interface box"
	["interface_yes_no,options"]="'<string>' process_input"
	["interface_yes_no,doc_link"]=""
	["interface_yes_no,group"]="Interface"
)
#
# Secure version of get_user_continue
# Displays a secure yes/no dialog box and invokes a permitted callback function based on user input.
#
# Globals:
#
# * DIALOG: Command used to display the dialog box.
#
# Arguments:
#
# * message: The message string to display in the dialog box.
# * next_action: The name of the callback function to invoke, which must be in the allowed list.
#
# Outputs:
#
# * Displays a yes/no dialog to the user.
#
# Returns:
#
# * Calls the specified callback function with no arguments if "yes" is selected, or with "No" as an argument if "no" is selected.
# * Exits with status 1 and prints an error if the callback function is not allowed.
#
# Example:
#
# ```bash
# interface_yes_no "Proceed with operation?" process_input
# ```
function interface_yes_no() {
	local message="$1"
	local next_action="$2"

	# Define a list of allowed functions
	local allowed_functions=("process_input" "other_function")
	# Check if the next_action is in the list of allowed functions
	local found=0
	for func in "${allowed_functions[@]}"; do
		if [[ "$func" == "$next_action" ]]; then
			found=1
			break
		fi
	done

	if [[ "$found" -eq 1 ]]; then
		if $DIALOG --yesno "$message" 10 80 3>&1 1>&2 2>&3; then
			$next_action
		else
			$next_action "No"
		fi
	else
		die "Error: Invalid function"
		exit 1
	fi
}


