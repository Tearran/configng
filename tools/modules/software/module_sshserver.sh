software_options+=(
	["module_openssh-server,author"]="@armbian"
	["module_openssh-server,maintainer"]="@igorpecovnik"
	["module_openssh-server,feature"]="module_openssh-server"
	["module_openssh-server,options"]="install remove purge status help"
	["module_openssh-server,desc"]="Install openssh-server container"
	["module_openssh-server,doc_link"]="https://docs.linuxserver.io/images/docker-openssh-server/#server-mode"
	["module_openssh-server,group"]="Networking"
	["module_openssh-server,port"]="2222"
	["module_openssh-server,arch"]="x86-64 arm64"
)
#
# Module openssh-server
# Manages the lifecycle of an OpenSSH server container using Docker.
#
# Provides commands to install, remove, purge, check status, or display help for an OpenSSH server running in a Docker container. Handles user prompts for configuration, ensures Docker is installed, manages persistent storage, and installs additional utilities inside the container.
#
# Arguments:
#
# * Command to execute: one of `install`, `remove`, `purge`, `status`, or `help`.
#
# Outputs:
#
# * Prints status messages, usage information, or error messages to STDOUT/STDERR.
#
# Returns:
#
# * 0 on success for status checks; 1 on failure or error conditions.
#
# Example:
#
# ```bash
# module_openssh-server install
# module_openssh-server status
# module_openssh-server remove
# module_openssh-server purge
# module_openssh-server help
# ```
function module_openssh-server () {
	local title="openssh-server"
	local condition=$(which "$title" 2>/dev/null)

	if pkg_installed docker-ce; then
		local container=$(docker container ls -a | mawk '/openssh-server?( |$)/{print $1}')
		local image=$(docker image ls -a | mawk '/openssh-server?( |$)/{print $3}')
	fi

	local commands
	IFS=' ' read -r -a commands <<< "${software_options["module_openssh-server,options"]}"

	OPENSSHSERVER_BASE="${SOFTWARE_FOLDER}/openssh-server"

	case "$1" in
		"${commands[0]}")
			pkg_installed docker-ce || module_docker install
			[[ -d "${OPENSSHSERVER_BASE}" ]] || mkdir -p "${OPENSSHSERVER_BASE}" || { echo "Couldn't create storage directory: ${OPENSSHSERVER_BASE}"; exit 1; }
			USER_NAME=$($DIALOG --title "Enter username" --inputbox "\nHit enter for defaults" 9 50 "upload" 3>&1 1>&2 2>&3)
			PUBLIC_KEY=$($DIALOG --title "Enter public key" --inputbox "" 9 50 "" 3>&1 1>&2 2>&3)
			MOUNT_POINT=$($DIALOG --title "Enter shared folder path" --inputbox "" 9 50 "${OPENSSHSERVER_BASE}/storage" 3>&1 1>&2 2>&3)
			docker run -d \
			--name=openssh-server \
			--net=lsio \
			--hostname=openssh-server `#optional` \
			-e PUID=1000 \
			-e PGID=1000 \
			-e TZ="$(cat /etc/timezone)" \
			-e PUBLIC_KEY="${PUBLIC_KEY}"  \
			-e SUDO_ACCESS=false \
			-e PASSWORD_ACCESS=false  \
			-e USER_PASSWORD=password \
			-e USER_NAME="${USER_NAME}" \
			-p 2222:2222 \
			-v "${OPENSSHSERVER_BASE}/config:/config" \
			-v "${MOUNT_POINT}:/config/storage" \
			--restart unless-stopped \
			lscr.io/linuxserver/openssh-server:latest
			for i in $(seq 1 20); do
				if docker inspect -f '{{ index .Config.Labels "build_version" }}' openssh-server >/dev/null 2>&1 ; then
					break
				else
					sleep 3
				fi
				if [ $i -eq 20 ] ; then
					echo -e "\nTimed out waiting for ${title} to start, consult your container logs for more info (\`docker logs openssh-server\`)"
					exit 1
				fi
			done
			# install rsync
			docker exec -it openssh-server /bin/bash -c "apk update; apk add rsync"
		;;
		"${commands[1]}")
			[[ "${container}" ]] && docker container rm -f "$container" >/dev/null
			[[ "${image}" ]] && docker image rm "$image" >/dev/null
		;;
		"${commands[2]}")
			${software_options["module_openssh-server,feature"]} ${commands[1]}
			[[ -n "${OPENSSHSERVER_BASE}" && "${OPENSSHSERVER_BASE}" != "/" ]] && rm -rf "${OPENSSHSERVER_BASE}"
		;;
		"${commands[3]}")
			if [[ "${container}" && "${image}" ]]; then
				return 0
			else
				return 1
			fi
		;;
		"${commands[4]}")
			echo -e "\nUsage: ${software_options["module_openssh-server,feature"]} <command>"
			echo -e "Commands:  ${software_options["module_openssh-server,options"]}"
			echo "Available commands:"
			echo -e "\tinstall\t- Install $title."
			echo -e "\tstatus\t- Installation status $title."
			echo -e "\tremove\t- Remove $title."
			echo
		;;
		*)
			${software_options["module_openssh-server,feature"]} ${commands[4]}
		;;
	esac
}
