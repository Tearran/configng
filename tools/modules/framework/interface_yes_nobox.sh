

framework_options+=(
	["interface_yes_no,author"]="@Tearran"
	["interface_yes_no,ref_link"]=""
	["interface_yes_no,feature"]="interface_yes_no"
	["interface_yes_no,desc"]="yes/no User Interface box"
	["interface_yes_no,example"]="'<string>' process_input"
	["interface_yes_no,doc_link"]=""
	["interface_yes_no,group"]="Interface"
)
#
# Secure version of get_user_continue
#
function interface_yes_no() {
	local message="$1"
	local next_action="$2"

	# Define a list of allowed functions
	local allowed_functions=("process_input" "other_function")
	# Check if the next_action is in the list of allowed functions
	found=0
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


