module_options+=(
	["module_octoprint,id"]="PRI0520"
	["module_octoprint,maintainer"]="@igorpecovnik"
	["module_octoprint,feature"]="module_octoprint"
	["module_octoprint,desc"]="Install octoprint container"
	["module_octoprint,example"]="install remove purge status help"
	["module_octoprint,status"]="Active"
	["module_octoprint,about"]=""
	["module_octoprint,doc_link"]="https://transmissionbt.com/"
	["module_octoprint,author"]="@armbian"
	["module_octoprint,parent"]="software"
	["module_octoprint,group"]="Printing"
	["module_octoprint,port"]="7981"
	["module_octoprint,arch"]="x86-64 arm64"
)


#
# Install openHAB from repo using apt
#
function module_openhab() {

	local title="openhab"
	local condition=$(which "$title" 2>/dev/null)

	local commands
	IFS=' ' read -r -a commands <<< "${module_options["module_openhab,example"]}"

	case "$1" in
		"${commands[0]}")
			wget -qO - https://repos.azul.com/azul-repo.key | gpg --dearmor > "/usr/share/keyrings/azul.gpg"
			wget -qO - https://openhab.jfrog.io/artifactory/api/gpg/key/public | gpg --dearmor > "/usr/share/keyrings/openhab.gpg"
			echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" > "/etc/apt/sources.list.d/zulu.list"
			echo "deb [signed-by=/usr/share/keyrings/openhab.gpg] https://openhab.jfrog.io/artifactory/openhab-linuxpkg stable main" > "/etc/apt/sources.list.d/openhab.list"
			pkg_update
			pkg_install zulu17-jdk
			pkg_install openhab openhab-addons
			systemctl daemon-reload 2> /dev/null
			service enable openhab.service 2> /dev/null
			service start openhab.service 2> /dev/null
			;;
		"${commands[1]}")
			pkg_remove zulu17-jdk openhab openhab-addons
			rm -f /usr/share/keyrings/openhab.gpg /usr/share/keyrings/azul.gpg
			rm -f /etc/apt/sources.list.d/zulu.list /etc/apt/sources.list.d/openhab.list
			;;
		"${commands[2]}")
			${module_options["module_openhab,feature"]} ${commands[1]}
		;;
		"${commands[3]}")
			if pkg_installed openhab; then
				return 0
			else
				return 1
			fi
		;;
		"${commands[4]}")
			echo -e "\nUsage: ${module_options["module_openhab,feature"]} <command>"
			echo -e "Commands:  ${module_options["module_openhab,example"]}"
			echo "Available commands:"
			echo -e "\tinstall\t- Install $title."
			echo -e "\tstatus\t- Installation status $title."
			echo -e "\tremove\t- Remove $title."
			echo -e "\tpurge\t- Purge $title."
			echo
		;;
		*)
			${module_options["module_haos,feature"]} ${commands[4]}
		;;
	esac
}
