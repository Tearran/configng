module_options+=(
	["module_armbian_runners,author"]="@igorpecovnik"
	["module_armbian_runners,feature"]="module_armbian_runners"
	["module_armbian_runners,desc"]="Manage self hosted runners"
	["module_armbian_runners,example"]="install remove remove_online purge help"
	["module_armbian_runners,port"]=""
	["module_armbian_runners,status"]="Active"
	["module_armbian_runners,arch"]=""
)

#
# Module Armbian self hosted Github runners
#
function module_armbian_runners () {

	local title="runners"
	local condition=$(which "$title" 2>/dev/null)

	# read parameters from command install
	local parameter
	IFS=' ' read -r -a parameter <<< "${1}"
	for feature in gh_token runner_name start stop label_primary label_secondary organisation owner repository; do
	for selected in ${parameter[@]}; do
		IFS='=' read -r -a split <<< "${selected}"
		[[ ${split[0]} == $feature ]] && eval "$feature=${split[1]}"
		done
	done

	# default values if not defined
	local gh_token="${gh_token}"
	local runner_name="${runner_name:-armbian}"
	local start="${start:-01}"
	local stop="${stop:-01}"
	local label_primary="${label_primary:-alfa}"
	local label_secondary="${label_secondary:-fast,images}"
	local organisation="${organisation:-armbian}"
	local owner="${owner}"
	local repository="${repository}"

	# we can generate per org or per repo
	local registration_url="${organisation}"
	local prefix="orgs"
	if [[ -n "${owner}" && -n "${repository}" ]]; then
		registration_url="${owner}/${repository}"
		prefix=repos
	fi

	local commands
	IFS=' ' read -r -a commands <<< "${module_options["module_armbian_runners,example"]}"

	case "${parameter[0]}" in

		"${commands[0]}")

			if [[ -z $gh_token ]]; then
				echo "Error: Github token is mandatory"
				${module_options["module_armbian_runners,feature"]} ${commands[6]}
				exit 1
			fi

			# Docker preinstall is needed for our build framework
			pkg_installed docker-ce || module_docker install
			pkg_update
			pkg_install jq curl libicu-dev

			# download latest runner package
			local temp_dir=$(mktemp -d)
			trap '{ rm -rf -- "$temp_dir"; }' EXIT
			[[ "$ARCH" == "x86_64" ]] && local arch=x64 || local arch=arm64
			local LATEST=$(curl -sL https://api.github.com/repos/actions/runner/tags | jq -r '.[0].zipball_url' | rev | cut -d"/" -f1 | rev | sed "s/v//g")
			curl --progress-bar --create-dir --output-dir ${temp_dir} -o \
			actions-runner-linux-${ARCH}-${LATEST}.tar.gz -L \
			https://github.com/actions/runner/releases/download/v${LATEST}/actions-runner-linux-${arch}-${LATEST}.tar.gz

			# make runners each under its own user
			for i in $(seq -w $start $stop)
			do
				local token=$(curl -s \
				-X POST \
				-H "Accept: application/vnd.github+json" \
				-H "Authorization: Bearer ${gh_token}"\
				-H "X-GitHub-Api-Version: 2022-11-28" \
				https://api.github.com/${prefix}/${registration_url}/actions/runners/registration-token | jq -r .token)

				${module_options["module_armbian_runners,feature"]} ${commands[1]} ${runner_name}

				adduser --quiet --disabled-password --shell /bin/bash \
				--home /home/actions-runner-${i} --gecos "actions-runner-${i}" actions-runner-${i}

				# add to sudoers
				if ! sudo grep -q "actions-runner-${i}" /etc/sudoers; then
					echo "actions-runner-${i} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
				fi
				usermod -aG docker actions-runner-${i}
				tar xzf ${temp_dir}/actions-runner-linux-${ARCH}-${LATEST}.tar.gz -C /home/actions-runner-${i}
				chown -R actions-runner-${i}:actions-runner-${i} /home/actions-runner-${i}

				# 1st runner has different labels
				local label=$label_secondary
				if [[ "$i" == "${start}" ]]; then
					local label=$label_primary
				fi

				runuser -l actions-runner-${i} -c \
				"./config.sh --url https://github.com/${registration_url} \
				--token ${token} --labels ${label} --name ${runner_name}-${i} --unattended"
				if [[ -f /home/actions-runner-${i}/svc.sh ]]; then
					sh -c "cd /home/actions-runner-${i} ; \
					sudo ./svc.sh install actions-runner-${i} 2>/dev/null; \
					sudo ./svc.sh start actions-runner-${i} >/dev/null"
				fi
			done

		;;
		"${commands[1]}")
			# delete if previous already exists
			if id "actions-runner-${i}" >/dev/null 2>&1; then
				echo "Removing runner ${i} on GitHub"
				${module_options["module_armbian_runners,feature"]} ${commands[2]} "$2-${i}"
				echo "Removing runner ${i} locally"
				runner_home=$(getent passwd "actions-runner-${i}" | cut -d: -f6)
				if [[ -f "${runner_home}/svc.sh" ]]; then
					sh -c "cd ${runner_home} ; sudo ./svc.sh stop actions-runner-${i} >/dev/null; sudo ./svc.sh uninstall actions-runner-${i} >/dev/null"
				fi
				userdel -r -f actions-runner-${i} 2>/dev/null
				groupdel actions-runner-${i} 2>/dev/null
				sed -i "/^actions-runner-${i}.*/d" /etc/sudoers
				rm -rf "${runner_home}"
			fi
		;;
		"${commands[2]}")
			DELETE=$2
			x=1
			while [ $x -le 9 ] # need to do it different as it can be more then 9 pages
			do
			RUNNER=$(
			curl -s -L \
			-H "Accept: application/vnd.github+json" \
			-H "Authorization: Bearer ${gh_token}" \
			-H "X-GitHub-Api-Version: 2022-11-28" \
			https://api.github.com/${prefix}/${registration_url}/actions/runners\?page\=${x} \
			| jq -r '.runners[] | .id, .name' | xargs -n2 -d'\n' | sed -e 's/ /,/g')

			while IFS= read -r DATA; do
				RUNNER_ID=$(echo $DATA | cut -d"," -f1)
				RUNNER_NAME=$(echo $DATA | cut -d"," -f2)
				# deleting a runner
				if [[ $RUNNER_NAME == ${DELETE} ]]; then
					echo "Delete existing: $RUNNER_NAME"
					curl -s -L \
					-X DELETE \
					-H "Accept: application/vnd.github+json" \
					-H "Authorization: Bearer ${gh_token}"\
					-H "X-GitHub-Api-Version: 2022-11-28" \
					https://api.github.com/${prefix}/${registration_url}/actions/runners/${RUNNER_ID}
				fi
			done <<< $RUNNER
			x=$(( $x + 1 ))
			done
		;;
		"${commands[3]}")
			if [[ -z $gh_token ]]; then
				echo "Error: Github token is mandatory"
				${module_options["module_armbian_runners,feature"]} ${commands[6]}
				exit 1
			fi
			for i in $(seq -w $start $stop); do
				${module_options["module_armbian_runners,feature"]} ${commands[1]} ${runner_name}
			done
		;;
		"${commands[6]}")
			echo -e "\nUsage: ${module_options["module_armbian_runners,feature"]} <command> [switches]"
			echo -e "Commands:  install purge"
			echo -e "Available commands:\n"
			echo -e "\tinstall\t\t- Install or reinstall $title."
			echo -e "\tpurge\t\t- Purge $title."
			echo -e "\nAvailable switches:\n"
			echo -e "\tgh_token\t- token with rights to admin runners."
			echo -e "\trunner_name\t- name of the runner (series)."
			echo -e "\tstart\t\t- start of serie (01)."
			echo -e "\tstop\t\t- stop (01)."
			echo -e "\tlabel_primary\t- runner tags for first runner (alfa)."
			echo -e "\tlabel_secondary\t- runner tags for all others (images)."
			echo -e "\torganisation\t- GitHub organisation name (armbian)."
			echo -e "\towner\t\t- GitHub owner."
			echo -e "\trepository\t- GitHub repository (if adding only for repo)."
			echo ""
		;;
		*)
			${module_options["module_armbian_runners,feature"]} ${commands[6]}
		;;
	esac
}