
module_options+=(
	["check_os_status,author"]="@Tearran"
	["check_os_status,feature"]="check_os_status"
	["check_os_status,example"]="help"
	["check_os_status,desc"]="Check if the current OS is supported based on /etc/armbian-distribution-status"
	["check_os_status,group"]="Initialize"
)
#
function check_distro_status() {
	case "$1" in
		help)
			echo "Usage: check_os_status"
			echo "This function checks if the current OS is supported based on /etc/armbian-distribution-status."
			echo "It retrieves the current OS distribution and checks if it is listed as supported in the specified file."
		;;
		*)

			# Ensure OS detection succeeded
			# if [[ -z "$DISTROID" && -z "$ARMBIAN" ]]; then
			if [[ -z "$DISTROID" ]]; then
				checkpoint debug "Error: Unable to detect the current OS distribution."
				die "Error: Unable to detect the current OS distribution."
			fi

			# Check if the OS is listed as supported in the DISTRO_STATUS
			if grep -qE "^${DISTROID}=.*supported" "$DISTRO_STATUS" 2> /dev/null; then
				checkpoint debug "The current $ARMBIAN ($DISTROID) is supported."
			else
			BACKTITLE="Warning: The current OS ($DISTROID) is not supported or not listed"
			set_colors 1
			info_wait_continue "Warning:

			The current OS ($DISTROID) is not a officially supported distro!

			The tool might still work well, but be aware that issues may
			not be accepted and addressed by the maintainers. However, you
			are welcome to contribute fixes for any problems you encounter.
			" process_input
			fi
		;;
	esac
}
#
# Functions to display warning for 10 seconds with a gauge
#
module_options+=(
	["info_wait_autocontinue,author"]="@igorpecovnik"
	["info_wait_autocontinue,ref_link"]=""
	["info_wait_autocontinue,feature"]="info_wait_autocontinue"
	["info_wait_autocontinue,desc"]="Display a warning with a gauge for 10 seconds then continue"
	["info_wait_autocontinue,group"]="Initialize"
)
#
function info_wait_continue() {
	local message="$1"
	local next_action="$2"
	{
	for ((i=0; i<=100; i+=10)); do
		sleep 1
		echo $i
	done
	} | $DIALOG --gauge "$message" 15 80 0
}


process_input() {
	local input="$1"
	if [ "$input" = "No" ]; then
		# user canceled
		echo "User canceled. exiting"
		exit 0
	fi
}