software_options+=(
	["module_plexmediaserver,id"]="MED0300"
	["module_plexmediaserver,maintainer"]="@igorpecovnik"
	["module_plexmediaserver,feature"]="module_plexmediaserver"
	["module_plexmediaserver,desc"]="Install plexmediaserver from repo using apt"
	["module_plexmediaserver,options"]="help install remove status"
	["module_plexmediaserver,about"]=""
	["module_plexmediaserver,doc_link"]="https://www.plex.tv/"
	["module_plexmediaserver,author"]="@schwar3kat"
	["module_plexmediaserver,parent"]="software"
	["module_plexmediaserver,group"]="Media"
	["module_plexmediaserver,port"]="32400"
	["module_plexmediaserver,arch"]="x86-64 arm64"
)
#
# Install plexmediaserver using apt
#
module_plexmediaserver() {
	local title="plexmediaserver"
	local condition=$(which "$title" 2>/dev/null)

	local commands
	IFS=' ' read -r -a commands <<< "${software_options["module_plexmediaserver,options"]}"

	case "$1" in
		"${commands[0]}")
			echo -e "\nUsage: ${software_options["module_plexmediaserver,feature"]} <command>"
			echo -e "Commands:  ${software_options["module_plexmediaserver,options"]}"
			echo "Available commands:"
			echo -e "\tinstall\t- Install $title."
			echo -e "\tstatus\t- Installation status $title."
			echo -e "\tremove\t- Remove $title."
			echo
		;;
		"${commands[1]}")
			if [ ! -f /etc/apt/sources.list.d/plexmediaserver.list ]; then
				echo "deb [arch=$(dpkg --print-architecture) \
				signed-by=/usr/share/keyrings/plexmediaserver.gpg] https://downloads.plex.tv/repo/deb public main" \
				| sudo tee /etc/apt/sources.list.d/plexmediaserver.list > /dev/null 2>&1
			else
				sed -i "/downloads.plex.tv/s/^#//g" /etc/apt/sources.list.d/plexmediaserver.list > /dev/null 2>&1
			fi
			# Note: for compatibility with existing source file in some builds format must be gpg not asc
			# and location must be /usr/share/keyrings
			wget -qO- https://downloads.plex.tv/plex-keys/PlexSign.key | gpg --dearmor \
			| sudo tee /usr/share/keyrings/plexmediaserver.gpg > /dev/null 2>&1
			pkg_update
			pkg_install plexmediaserver
		;;
		"${commands[2]}")
			sed -i '/plexmediaserver.gpg/s/^/#/g' /etc/apt/sources.list.d/plexmediaserver.list
			pkg_remove plexmediaserver
		;;
		"${commands[3]}")
			if pkg_installed plexmediaserver; then
				return 0
			else
				return 1
			fi
		;;
		*)
			${software_options["module_plexmediaserver,feature"]} ${commands[3]}
		;;
	esac
}
