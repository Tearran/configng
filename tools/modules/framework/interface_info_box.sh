framework_options+=(
	["interface_infobox,author"]="@Tearran"
	["interface_infobox,ref_link"]=""
	["interface_infobox,feature"]="interface_infobox"
	["interface_infobox,desc"]="info User Interface box"
	["interface_infobox,example"]="<<< 'hello world' ; "
	["interface_infobox,doc_link"]=""
	["interface_infobox,group"]="Interface"
)
#
# Function to display an infobox with a message
#
function interface_infobox() {
	export TERM=ansi
	local input
	local BACKTITLE="$BACKTITLE"
	local -a buffer # Declare buffer as an array
	if [ -p /dev/stdin ]; then
		while IFS= read -r line; do
			buffer+=("$line") # Add the line to the buffer
			# If the buffer has more than 10 lines, remove the oldest line
			if ((${#buffer[@]} > 18)); then
				buffer=("${buffer[@]:1}")
			fi
			# Display the lines in the buffer in the infobox

			TERM=ansi $DIALOG --title "$TITLE" --infobox "$(printf "%s\n" "${buffer[@]}")" 16 90
			sleep 0.5
		done
	else

		input="$1"
		TERM=ansi $DIALOG --title "$TITLE" --infobox "$input" 6 80
	fi
	echo -ne '\033[3J' # clear the screen
}

