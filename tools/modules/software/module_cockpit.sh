software_options+=(
	["module_cockpit,maintainer"]="@igorpecovnik"
	["module_cockpit,feature"]="module_cockpit"
	["module_cockpit,desc"]="Cockpit setup and service setting."
	["module_cockpit,options"]="help install remove start stop enable disable status check"
	["module_cockpit,about"]=""
	["module_cockpit,doc_link"]="https://cockpit-project.org/guide/latest/"
	["module_cockpit,author"]="@tearran"
	["module_cockpit,parent"]="software"
	["module_cockpit,group"]="Management"
	["module_cockpit,port"]="9090"
	["module_cockpit,arch"]="x86-64 arm64 armhf"
)
# Manages the installation, removal, and service control of the Cockpit software module.
#
# Globals:
#
# * software_options: Associative array containing configuration and command options for the Cockpit module.
#
# Arguments:
#
# * $1: Command to execute (e.g., help, install, remove, start, stop, enable, disable, status, check).
#
# Outputs:
#
# * Prints usage instructions, status messages, or error messages to STDOUT.
#
# Returns:
#
# * 0 if the command completes successfully or the Cockpit service is active/disabled when using 'check'.
# * 1 if the 'check' command is used and the service is neither active nor disabled.
#
# Example:
#
#   module_cockpit install
#   module_cockpit start
#   module_cockpit status
#   module_cockpit remove
function module_cockpit() {
	local title="cockpit"
	local condition=$(dpkg -s "cockpit" 2>/dev/null | sed -n "s/Status: //p")
	# Convert the example string to an array
	local commands
	IFS=' ' read -r -a commands <<< "${software_options["module_cockpit,options"]}"

	case "$1" in
		"${commands[0]}")
		## help/menu options for the module
		echo -e "\nUsage: ${software_options["module_cockpit,feature"]} <command>"
		echo -e "Commands: ${software_options["module_cockpit,options"]}"
		echo "Available commands:"
		if [[ -z "$condition" ]]; then
			echo -e "  install\t- Install $title."
		else
			if srv_active cockpit.socket; then
				echo -e "\tstop\t- Stop the $title service."
			else
				echo -e "\tstart\t- Start the $title service."
			fi
			if srv_enabled cockpit.socket; then
				echo -e "\tdisable\t- Disable $title from starting on boot."
			else
				echo -e "\tenable\t- Enable $title to start on boot."
			fi
			echo -e "\tstatus\t- Show the status of the $title service."
			echo -e "\tremove\t- Remove $title."
		fi
		echo
		;;
		"${commands[1]}")
		pkg_update
		pkg_install cockpit cockpit-ws cockpit-system cockpit-storaged
		echo "Cockpit installed successfully."
		;;
		"${commands[2]}")
		srv_disable cockpit cockpit.socket
		pkg_remove cockpit
		echo "Cockpit removed successfully."
		;;
		"${commands[3]}")
		srv_start cockpit.socket
		echo "Cockpit service started."
		;;
		"${commands[4]}")
		srv_stop cockpit.socket
		echo "Cockpit service stopped."
		;;
		"${commands[5]}")
		srv_enable cockpit.socket
		echo "Cockpit service enabled."
		;;
		"${commands[6]}")
		srv_disable cockpit.socket
		echo "Cockpit service disabled."
		;;
		"${commands[7]}")
		srv_status cockpit.socket
		;;
		"${commands[-1]}")
		## check cockpit status
		if srv_active cockpit.socket; then
			echo "Cockpit service is active."
			return 0
		elif ! srv_enabled cockpit.socket; then
			echo "Cockpit service is disabled."
			return 0
		else
			return 1
		fi
		;;
		*)
		echo "Invalid command. Try: '${software_options["module_cockpit,options"]}'"
		;;
	esac
}

