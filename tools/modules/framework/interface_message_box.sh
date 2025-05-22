
framework_options+=(
	["interface_message,author"]="@Tearran"
	["interface_message,ref_link"]=""
	["interface_message,feature"]="interface_message"
	["interface_message,desc"]="OK message User Interface box"
	["interface_message,example"]="<<< 'hello world' "
	["interface_message,doc_link"]=""
	["interface_message,status"]=""
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

