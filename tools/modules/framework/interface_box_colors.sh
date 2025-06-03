framework_options+=(
	["interface_colors,author"]="@Tearran"
	["interface_colors,ref_link"]=""
	["interface_colors,feature"]="interface_colors"
	["interface_colors,desc"]="Change the background color of the User Interface box"
	["interface_colors,options"]="0 1 2 3 4 5 6 7"
	["interface_colors,doc_link"]=""
	["interface_colors,group"]="Interface"
)
#
# Function to set the tui colors
# Sets the UI box background color based on the dialog tool in use.
#
# Arguments:
#
# * color_code: Numeric code (0-7) representing the desired background color.
#
# Returns:
#
# * 0 on success.
# * 1 if the dialog type is invalid.
#
# Example:
#
# ```bash
# interface_colors 4  # Sets background color to blue if supported by the dialog tool.
# ```
function interface_colors() {
	local color_code=$1

	if [ "$DIALOG" = "whiptail" ]; then
		_newt_colors "$color_code"
		#echo "color code: $color_code" | show_infobox ;
	elif [ "$DIALOG" = "dialog" ]; then
		_term_colors "$color_code"
	else
		echo "Invalid dialog type"
		return 1
	fi
}

#
# Function to set the colors for newt
# Sets the NEWT_COLORS environment variable for the newt UI library based on a numeric color code.
#
# Arguments:
#
# * color_code: Numeric code (0-7, 8-9) representing the desired background color.
#
# Globals:
#
# * Sets the NEWT_COLORS environment variable to specify the root background color for newt-based dialogs.
#
# Returns:
#
# * No output. Returns non-zero exit status if the color code is invalid.
#
# Example:
#
# ```bash
# _newt_colors 3  # Sets NEWT_COLORS to use yellow as the background color.
# ```
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
		*) return ;;
	esac
	export NEWT_COLORS="root=,$color"
}

#
# Function to set the colors for terminal
# Outputs the ANSI escape sequence for a terminal background color based on the provided color code.
#
# Arguments:
#
# * color_code: Integer from 0 to 7 representing the desired background color (0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan, 7=white).
#
# Outputs:
#
# * The ANSI escape sequence for the specified background color to STDOUT.
# * Prints "Invalid color code" to STDOUT and returns 1 if the color code is not in the valid range.
#
# Example:
#
# ```bash
# _term_colors 4 # outputs the escape sequence for blue background
# ```
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
		*)
			echo "Invalid color code"
			return 1
			;;
	esac
	echo -e "$color"
}

#
# Function to reset the colors
# Resets terminal colors to their default settings.
#
# Outputs:
#
# * ANSI escape sequence to reset all terminal colors and attributes.
#
# Example:
#
# ```bash
# reset_interface_colors
# ```
function reset_interface_colors() {
	echo -e "\e[0m"
}
