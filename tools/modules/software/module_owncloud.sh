software_options+=(
	["module_owncloud,maintainer"]="@igorpecovnik"
	["module_owncloud,feature"]="module_owncloud"
	["module_owncloud,desc"]="Install owncloud container"
	["module_owncloud,options"]="install remove purge status help"
	["module_owncloud,about"]=""
	["module_owncloud,doc_link"]="https://doc.owncloud.com/"
	["module_owncloud,author"]="@armbian"
	["module_owncloud,parent"]="software"
	["module_owncloud,group"]="Management"
	["module_owncloud,port"]="7787"
	["module_owncloud,arch"]="x86-64 arm64"
)
#
# Module owncloud
# Manages the OwnCloud container module, supporting installation, removal, purging, status checks, and help.
#
# Globals:
#
# * software_options: Associative array containing module metadata and supported commands.
# * SOFTWARE_FOLDER: Base directory for software data storage.
# * LOCALIPADD: Local IP address used for trusted domains in OwnCloud.
#
# Arguments:
#
# * $1: Command to execute. Supported commands are: install, remove, purge, status, help.
#
# Outputs:
#
# * Prints status messages, errors, or usage information to STDOUT.
#
# Returns:
#
# * 0 on successful status check or command execution.
# * 1 on failure to create storage directory, container start timeout, or unsuccessful status check.
#
# Example:
#
#   module_owncloud install   # Installs and starts the OwnCloud container.
#   module_owncloud remove    # Removes the OwnCloud container and image.
#   module_owncloud purge     # Removes the container, image, and data directory.
#   module_owncloud status    # Checks if OwnCloud is installed and running.
#   module_owncloud help      # Displays usage information.
function module_owncloud () {
	local title="owncloud"
	local condition=$(which "$title" 2>/dev/null)

	if pkg_installed docker-ce; then
		local container=$(docker container ls -a | mawk '/owncloud?( |$)/{print $1}')
		local image=$(docker image ls -a | mawk '/owncloud/{print $3}')
	fi

	local commands
	IFS=' ' read -r -a commands <<< "${software_options["module_owncloud,options"]}"

	OWNCLOUD_BASE="${SOFTWARE_FOLDER}/owncloud"

	case "$1" in
		"${commands[0]}")
			pkg_installed docker-ce || module_docker install
			[[ -d "$OWNCLOUD_BASE" ]] || mkdir -p "$OWNCLOUD_BASE" || { echo "Couldn't create storage directory: $OWNCLOUD_BASE"; exit 1; }
			docker run -d \
			--name=owncloud \
			--net=lsio \
			-e PUID=1000 \
			-e PGID=1000 \
			-e TZ="$(cat /etc/timezone)" \
			-e "OWNCLOUD_TRUSTED_DOMAINS=${LOCALIPADD}" \
			-p 7787:8080 \
			-v "${OWNCLOUD_BASE}/config:/config" \
			-v "${OWNCLOUD_BASE}/data:/mnt/data" \
			--restart unless-stopped \
			owncloud/server
			for i in $(seq 1 20); do
				if docker inspect -f '{{ index .Config.Labels "build_version" }}' owncloud >/dev/null 2>&1 ; then
					break
				else
					sleep 3
				fi
				if [ $i -eq 20 ] ; then
					echo -e "\nTimed out waiting for ${title} to start, consult your container logs for more info (\`docker logs owncloud\`)"
					exit 1
				fi
			done
		;;
		"${commands[1]}")
			if [[ "${container}" ]]; then
				docker container rm -f "$container" >/dev/null
			fi
			if [[ "${image}" ]]; then
				docker image rm "$image" >/dev/null
			fi
		;;
		"${commands[2]}")
			${software_options["module_owncloud,feature"]} ${commands[1]}
			if [[ -n "${OWNCLOUD_BASE}" && "${OWNCLOUD_BASE}" != "/" ]]; then
				rm -rf "${OWNCLOUD_BASE}"
			fi
		;;
		"${commands[3]}")
			if [[ "${container}" && "${image}" ]]; then
				return 0
			else
				return 1
			fi
		;;
		"${commands[4]}")
			echo -e "\nUsage: ${software_options["module_owncloud,feature"]} <command>"
			echo -e "Commands:  ${software_options["module_owncloud,options"]}"
			echo "Available commands:"
			echo -e "\tinstall\t- Install $title."
			echo -e "\tremove\t- Remove $title."
			echo -e "\tpurge\t- Purge $title data folder."
			echo -e "\tstatus\t- Installation status $title."
			echo
		;;
		*)
			${software_options["module_owncloud,feature"]} ${commands[4]}
		;;
	esac
}
