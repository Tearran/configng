
framework_options+=(
	["interface_colors,author"]="@Tearran"
	["interface_colors,ref_link"]=""
	["interface_colors,feature"]="interface_colors"
	["interface_colors,desc"]="Change the background color of the User Interface box"
	["interface_colors,options"]="0 1 2 3 4 5 6 7 8 9"
	["interface_colors,doc_link"]=""
	["interface_colors,group"]="Interface"
	["interface_colors,arch"]="all"
)
#
# Function to set the tui colors
#
function interface_colors() {
	local color_code=$1

	if [ "$DIALOG" = "whiptail" ]; then
		checkpoint debug "$DIALOG color code: $color_code" ;
		_newt_colors "$color_code" || die "Failed to set NEWT for code '$color_code'"
	elif [ "$DIALOG" = "dialog" ]; then
		checkpoint debug "$DIALOG color code: $color_code" ;
		_term_colors "$color_code" || die "Failed to set NCUSES terminal for code '$color_code'"
	else
		die "Invalid dialog type"
	fi
}
module_helpers+=(
	["_newt_colors,author"]="@Tearran"
	["_newt_colors,feature"]="_newt_colors"
	["_newt_colors,desc"]="Set NEWT colors for whiptail dialog"
	["_newt_colors,options"]="<color_code>"
	["_newt_colors,group"]="Interface"
)
#
# Function to set the colors for newt
#
function _newt_colors() {
	local color_code=$1
	case $color_code in
		0) color="black" ;;
		1) color="red" ;;
		2) color="green" ;;
		3) color="yellow" ;;
		4) color="blue" ;;
		5) color="magenta" ;;
		6) color="cyan" ;;
		7) color="white" ;;
		8) color="black" ;;
		9) color="red" ;;
		*)
			die "Warning: Invalid color code '$color_code' passed to _newt_colors" >&2
			;;
	esac
	export NEWT_COLORS="root=,$color"
}

module_helpers+=(
	["_term_colors,author"]="@Tearran"
	["_term_colors,feature"]="_term_colors"
	["_term_colors,desc"]="Set terminal background colors for dialog"
	["_term_colors,options"]="<color_code>"
	["_term_colors,group"]="Interface"
)
#
# Function to set the colors for terminal
#
function _term_colors() {
	local color_code=$1
	case $color_code in
		0) color="\e[40m" ;; # black
		1) color="\e[41m" ;; # red
		2) color="\e[42m" ;; # green
		3) color="\e[43m" ;; # yellow
		4) color="\e[44m" ;; # blue
		5) color="\e[45m" ;; # magenta
		6) color="\e[46m" ;; # cyan
		7) color="\e[47m" ;; # white
		8) color="\e[100m" ;; # gray
		9) color="\e[101m" ;; # bright red
		*)
			reset_interface_colors
			die "Invalid color code"
			;;
	esac
	echo -e "$color"
}



module_helpers+=(
	["reset_interface_colors,author"]="@Tearran"
	["reset_interface_colors,feature"]="reset_interface_colors"
	["reset_interface_colors,desc"]="Reset terminal colors to default"
	["reset_interface_colors,options"]=""
	["reset_interface_colors,group"]="Interface"
)
#
# Function to reset the colors
#
function reset_interface_colors() {
	echo -e "\e[0m"
}
