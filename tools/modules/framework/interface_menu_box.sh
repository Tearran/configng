
module_options+=(
	["interface_menu,author"]="Tearran"
	["interface_menu,feature"]="interface_menu"
	["interface_menu,desc"]="menu User Interface box"
	["interface_menu,example"]="<function_name>"
	["interface_menu,status"]=""
)
#
# Uses Avalible (Whiptail, DIALOG, READ) for the menu interface
function interface_menu() {
	# Check if the function name was provided
	local function_name="$1"

	# Get the help message from the specified function
	help_message=$("$function_name" menu)

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