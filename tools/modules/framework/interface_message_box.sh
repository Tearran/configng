framework_options+=(
	["interface_message,author"]="@Tearran"
	["interface_message,ref_link"]=""
	["interface_message,feature"]="interface_message"
	["interface_message,desc"]="OK message User Interface box"
	["interface_message,options"]="<<< 'hello world' "
	["interface_message,doc_link"]=""
	["interface_message,group"]="Interface"
)
#
# Function to display a message box
# Displays a message box with the provided input using the specified dialog tool.
#
# Globals:
#
# * DIALOG: Specifies which dialog tool to use ("dialog", "whiptail", or "read").
# * TITLE: The title to display in the message box window.
#
# Arguments:
#
# * None. The message to display is read from standard input.
#
# Outputs:
#
# * Displays a message box with the input text using the selected dialog tool, or prints "Available options:" if DIALOG is "read".
#
# Example:
#
# ```bash
# echo "Hello, world!" | interface_message
# ```
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

