

set_interface() {
	# Set dialog tool hierarchy based on environment
	if [[ -x "$(command -v whiptail)" ]]; then
		DIALOG="whiptail"
	elif [[ -x "$(command -v dialog)" ]]; then
		DIALOG="dialog"
	else
		DIALOG="read"  # Fallback to read if no dialog tool is available
	fi
}

# Uses Avalible (Whiptail, DIALOG, READ, Zenity(untested)) for the interface
function see_menu() {
	local function_name="$1"

	# Get the help message from the specified function
	help_message=$("$function_name" help)

	# Prepare options for the dialog tool based on help message
	options=()
		while IFS= read -r line; do
		if [[ $line =~ ^[[:space:]]*([a-zA-Z0-9_-]+)[[:space:]]*-\s*(.*)$ ]]; then
			options+=("${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}")
		fi
		done <<< "$help_message"

	# Display menu based on DIALOG tool
	case $DIALOG in
		"dialog")
		choice=$(dialog --title "${function_name^} Management" --menu "Choose an option:" 15 60 9 "${options[@]}" 2>&1 >/dev/tty)
		;;
		"whiptail")
		choice=$(whiptail --title "${function_name^} Management" --menu "Choose an option:" 15 60 9 "${options[@]}" 3>&1 1>&2 2>&3)
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