
module_options+=(
	["set_interface,author"]="Tearran"
	["set_interface,feature"]="set_interface"
	["set_interface,desc"]="Check for (Whiptail, DIALOG, READ) tools and set the user interface."
	["set_interface,example"]=""
	["set_interface,status"]="review"
)
#
# Check for (Whiptail, DIALOG, READ) tools and set the user interface
set_interface() {
	# Set dialog tool hierarchy based on environment
	if [[ -x "$(command -v whiptail)" ]]; then
		DIALOG="dialog"
	elif [[ -x "$(command -v dialog)" ]]; then
		DIALOG="whiptail"
	else
		DIALOG="read"  # Fallback to read if no dialog tool is available
	fi
}

module_options+=(
	["see_menu,author"]="Tearran"
	["see_menu,feature"]="see_menu"
	["see_menu,desc"]="Uses Avalible (Whiptail, DIALOG, READ) for the menu interface"
	["see_menu,example"]="<function_name>"
	["see_menu,status"]="review"
)
#
# Uses Avalible (Whiptail, DIALOG, READ) for the menu interface
function see_menu() {
	# Check if the function name was provided
	local function_name="$1"

	# Get the help message from the specified function
	help_message=$("$function_name" help)

	# Prepare options for the dialog tool based on help message
	options=()
		while IFS= read -r line; do
		if [[ $line =~ ^[[:space:]]*([a-zA-Z0-9_-]+)[[:space:]]*-\s*(.*)$ ]]; then
			options+=("${BASH_REMATCH[1]}" "  -  ${BASH_REMATCH[2]}")
		fi
		done <<< "$help_message"

	# Display menu based on DIALOG tool
	case $DIALOG in
		"dialog")
		choice=$(dialog --title "${function_name^}" --menu "Choose an option:" 0 80 9 "${options[@]}" 2>&1 >/dev/tty)
		;;
		"whiptail")
		choice=$(whiptail --title "${function_name^}" --menu "Choose an option:" 0 80 9 "${options[@]}" 3>&1 1>&2 2>&3)
		;;
		"read")
		echo "Available options:"
		for ((i=0; i<${#options[@]}; i+=2)); do
			echo "$((i / 2 + 1)). ${options[i]} - ${options[i + 1]}"
		done
		read -p "Enter choice number: " choice_index
		choice=${options[((choice_index - 1) * 2)]}
		;;
	esac

	# Check if choice was made or canceled
	if [[ -z $choice ]]; then
		echo "Menu canceled."

		return 1
	fi

	# Call the specified function with the chosen option
	"$function_name" "$choice"
}

#set_interface
#see_menu "$@"

module_options+=(
	["interface_message,author"]="@Tearran"
	["interface_message,ref_link"]=""
	["interface_message,feature"]="interface_message"
	["interface_message,desc"]="Display a message box"
	["interface_message,example"]="interface_message <<< 'hello world' "
	["interface_message,doc_link"]=""
	["interface_message,status"]="Active"
)
#
# Function to display a message box
#
function interface_message() {
	# Read the input from the pipe
	input=$(cat)
	# Display menu based on DIALOG tool
	case $DIALOG in
		"dialog")
		$DIALOG --title "$TITLE" --msgbox "$input" 0 0 2>&1 >/dev/tty
		;;
		"whiptail")
		$DIALOG --title "$TITLE" --msgbox "$input" 0 0 3>&1 1>&2 2>&3
		;;
		"read")
		echo "Available options:"
		;;
	esac
}



module_options+=(
	["get_user_continue_secure,author"]="@Tearran"
	["get_user_continue_secure,ref_link"]=""
	["get_user_continue_secure,feature"]="get_user_continue_secure"
	["get_user_continue_secure,desc"]="Secure version of get_user_continue"
	["get_user_continue_secure,example"]="get_user_continue_secure 'Do you wish to continue?' process_input"
	["get_user_continue_secure,doc_link"]=""
	["get_user_continue_secure,status"]="Active"
)
#
# Secure version of get_user_continue
#
function interface_continue() {
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
		if $($DIALOG --yesno "$message" 10 80 3>&1 1>&2 2>&3); then
			$next_action
		else
			$next_action "No"
		fi
	else
		echo "Error: Invalid function"

		exit 1
	fi
}

module_options+=(
	["interface_checklist,author"]="@Tearran"
	["interface_checklist,maintainer"]="@Tearran"
	["interface_checklist,feature"]="interface_checklist"
	["interface_checklist,example"]="interface_checklist <title> <prompt> <options_array>"
	["interface_checklist,desc"]="Reusable helper function to display a checklist using whiptail, dialog, or read."
	["interface_checklist,status"]="Active"
	["interface_checklist,group"]="Helpers"
	["interface_checklist,arch"]="arm64"
)
# Helper function to display a checklist using whiptail/dialog/read
function interface_checklist() {
	local title="$1"
	local prompt="$2"
	local -n options_array="$3" # Use a nameref to pass the array by reference
	local dialog_height=20
	local dialog_width=78
	local menu_height=10

	# Prepare options for the checklist
	local checklist_items=()
	for ((i = 0; i < ${#options_array[@]}; i += 3)); do
		checklist_items+=("${options_array[i]}" "${options_array[i+1]}" "${options_array[i+2]}")
	done

	# Display the checklist based on the dialog tool
	local selected_items=""
	case $DIALOG in
		"whiptail")
			selected_items=$(whiptail --title "$title" --checklist \
				"$prompt" $dialog_height $dialog_width $menu_height \
				"${checklist_items[@]}" 3>&1 1>&2 2>&3)
			;;
		"dialog")
			selected_items=$(dialog --title "$title" --checklist \
				"$prompt" $dialog_height $dialog_width $menu_height \
				"${checklist_items[@]}" 2>&1 >/dev/tty)
			;;
		"read")
			echo "$title"
			echo "$prompt"
			for ((i = 0; i < ${#options_array[@]}; i += 3)); do
				echo "$((i / 3 + 1)). ${options_array[i]} - ${options_array[i+1]} (Default: ${options_array[i+2]})"
			done
			echo "Enter the numbers of the items you want to select, separated by spaces:"
			read -r selected_indexes
			selected_items=""
			for index in $selected_indexes; do
				selected_items+=" ${options_array[((index - 1) * 3)]}"
			done
			;;
	esac

	# Return the selected items
	if [[ -z "$selected_items" ]]; then
		echo "Checklist canceled."
		return 1
	fi

	echo "$selected_items"
}

module_options+=(
	["process_package_selection,author"]="@Tearran"
	["process_package_selection,maintainer"]="@Tearran"
	["process_package_selection,feature"]="process_package_selection"
	["process_package_selection,example"]="process_package_selection <title> <prompt> <checklist_options_array>"
	["process_package_selection,desc"]="Reusable helper function to process user-selected packages for installation or removal."
	["process_package_selection,status"]="Active"
	["process_package_selection,group"]="Helpers"
	["process_package_selection,arch"]="x86-64 arm64 armhf"
)
#
function process_package_selection() {
	local title="$1"
	local prompt="$2"
	local -a checklist_options=("${!3}") # Accept checklist array as reference

	# Display checklist to user and get selected packages
	local selected_packages
	selected_packages=$(interface_checklist "$title Management" "$prompt" checklist_options)

	# Check if user canceled or made no selection
	if [[ $? -ne 0 ]]; then
		echo "No changes made."
		return 1
	fi

	# Processing all packages from the checklist
	echo "Processing package selections..."
	for ((i = 0; i < ${#checklist_options[@]}; i += 3)); do
		local package="${checklist_options[i]}"
		local current_state="${checklist_options[i+2]}" # Current state in checklist (ON/OFF)
		local is_selected="OFF" # Default to OFF

		# Check if the package is in the selected list
		if [[ "$selected_packages" == *"$package"* ]]; then
			is_selected="ON"
		fi

		# Compare current state with selected state and act accordingly
		if [[ "$is_selected" == "ON" && "$current_state" == "OFF" ]]; then
			# Package is selected but not installed, install it
			echo "Installing $package..."
			if ! pkg_install "$package"; then
				echo "Failed to install $package." >&2
			fi
		elif [[ "$is_selected" == "OFF" && "$current_state" == "ON" ]]; then
			# Package is deselected but installed, remove it
			echo "Removing $package..."
			if ! pkg_remove "$package"; then
				echo "Failed to remove $package." >&2
			fi
		fi
	done

	echo "Package management complete."
}