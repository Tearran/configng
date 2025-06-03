module_options+=(
	["module_armbian_rsyncd,author"]="@igorpecovnik"
	["module_armbian_rsyncd,maintainer"]="@igorpecovnik"
	["module_armbian_rsyncd,feature"]="module_armbian_rsyncd"
	["module_armbian_rsyncd,options"]="install remove status help"
	["module_armbian_rsyncd,desc"]="Install and configure Armbian rsyncd."
	["module_armbian_rsyncd,doc_link"]=""
	["module_armbian_rsyncd,group"]="User"
	["module_armbian_rsyncd,port"]="873"
	["module_armbian_rsyncd,arch"]=""
)

# Manages the Armbian rsync daemon (rsyncd) module, providing install, remove, status, and help commands.
	#
	# Arguments:
	#
	# * Command to execute: one of `install`, `remove`, `status`, or `help`.
	#
	# Description:
	#
	# - `install`: Prompts for a storage path and directories to export, generates an rsyncd configuration, installs and starts the rsync service.
	# - `remove`: Stops the rsync service and deletes its configuration file.
	# - `status`: Checks if the rsyncd service is active or enabled.
	# - `help`: Displays usage information and available commands.
	#
	# Returns:
	#
	# * 0 if the `status` command finds the service active.
	# * 1 if the `status` command finds the service inactive or disabled.
	#
	# Example:
	#
	# ```bash
	# module_armbian_rsyncd install
	# module_armbian_rsyncd remove
	# module_armbian_rsyncd status
	# module_armbian_rsyncd help
	# ```
	function module_armbian_rsyncd() {
	local title="rsyncd"
	local condition=$(which "$title" 2>/dev/null)

	# Convert the example string to an array
	local commands
	IFS=' ' read -r -a commands <<< "${module_options["module_armbian_rsyncd,options"]}"

	case "$1" in
		"${commands[0]}")
			if export_path=$(dialog --title \
				"Where is Armbian file storage located?" \
				--inputbox "" 6 60 "/armbian/openssh-server/storage/" 3>&1 1>&2 2>&3); then

				# lets make temporally file
				rsyncd_config=$(mktemp)
				if target_sync=$($DIALOG --title "Select an Option" --checklist \
					"Choose your favorite programming language" 15 60 6 \
					"apt" "Armbian stable packages" ON \
					"dl" "Stable images" ON \
					"beta" "Armbian unstable packages" OFF \
					"archive" "Old images" OFF \
					"oldarhive" "Very old Archive" OFF \
					"cache" "Nighly and community images cache" OFF 3>&1 1>&2 2>&3); then

					for choice in $(echo ${target_sync} | tr -d '"'); do
						cat <<- EOF >> $rsyncd_config
						[$choice]
						path = $export_path/$choice
						max connections = 8
						uid = nobody
						gid = users
						list = yes
						read only = yes
						write only = no
						use chroot = yes
						lock file = /run/lock/rsyncd-$choice
						EOF
					done
					mv $rsyncd_config /etc/rsyncd.conf
					pkg_update
					pkg_install rsync >/dev/null 2>&1
					srv_enable rsync >/dev/null 2>&1
					srv_start rsync >/dev/null 2>&1
				fi
			fi
		;;
		"${commands[1]}")
			srv_stop rsync >/dev/null 2>&1
			rm -f /etc/rsyncd.conf
		;;
		"${commands[2]}")
			if srv_active rsyncd; then
				return 0
			elif ! srv_enabled rsync; then
				return 1
			else
				return 1
			fi
		;;
		"${commands[3]}")
			echo -e "\nUsage: ${module_options["module_armbian_rsyncd,feature"]} <command>"
			echo -e "Commands:  ${module_options["module_armbian_rsyncd,options"]}"
			echo "Available commands:"
			echo -e "\tinstall\t- Install $title."
			echo -e "\tremove\t- Remove $title."
			echo -e "\tstatus\t- Status of $title."
			echo
		;;
		*)
			${module_options["module_armbian_rsyncd,feature"]} ${commands[3]}
		;;
	esac
	}
