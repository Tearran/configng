
framework_options+=(
	["interface_colors,author"]="@Tearran"
	["interface_colors,ref_link"]=""
	["interface_colors,feature"]="interface_colors"
	["interface_colors,desc"]="Change the background color of the User Interface box"
	["interface_colors,options"]="0 1 2 3 4 5 6 7 8 9"
	["interface_colors,doc_link"]=""
	["interface_colors,group"]="Interface"
)
#
# Function to set the tui colors
#
function interface_colors() {
	local color_code=$1

	if [ "$DIALOG" = "whiptail" ]; then
		checkpoint debug "$DIALOG color code: $color_code" ;
		_newt_colors "$color_code" || die "unknown error"
		
	elif [ "$DIALOG" = "dialog" ]; then
		checkpoint debug "$DIALOG color code: $color_code" ;
		_term_colors "$color_code"  || die "unknown error"
	else
		die "Invalid dialog type"
	fi
}
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
			die "Invalid color code"
			;;
	esac
	echo -e "$color"
}

#
# Function to reset the colors
#
function reset_interface_colors() {
	echo -e "\e[0m"
}
