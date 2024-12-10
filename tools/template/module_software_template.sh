
declare -A module_options

module_options+=(
	["module_template,feature"]="module_template"   # The name of the function, master KEY for the module parsing
	["module_template,helpers"]="" # Helper dependancy
	["module_template,author"]="@Tearran"    # The module contributors git id
	["module_template,ref_link"]="@armbian"  # The maintainer's git id or link for additional information
	["module_template,desc"]="Example unattended interface module." # A short description of what the module does
	["module_template,example"]="check install remove help"   # A list of $1 options the module accepts
	["module_template,commands"]="check install remove help"   # A list of $1 options the module accepts
	["module_template,status"]="Development" # Options (Disabled, Development, Software, System, Network, Loca...)
	["module_template,group"]="Template" # Long list see menu for sub groups
	["module_template,port"]=""      # Ports used
	["module_template,arch"]=""      # Options for Architecture information (?)
)

function module_template() {
	local title="test"
	local condition=$(which "$title" 2>/dev/null)

	# Convert the example string to an array
	local commands
	#IFS=' ' read -r -a commands <<< "${module_options["module_template,example"]}"
	IFS=' ' read -r -a commands <<< "${module_options["module_template,commands"]}"

	case "$1" in
		"${commands[0]}")
			# list conditionaly, avalible commands and descriptions
			if [[ -z "$condition" ]]; then
				echo -e "\tinstall\t- Install $title."
			elif [[ -n "$condition" ]]; then
				echo -e "\tremove\t- Remove $title."
			else
				echo "Unknown error"
				# Handle unknown conditions
			fi
		;;
		"${commands[1]}")
			echo "Installing $title..."
			# Installation logic here
			[ -f /usr/bin/test.back ] && mv /usr/bin/test.back /usr/bin/test
		;;
		"${commands[2]}")
			echo "Removing $title..."
			[ -f /usr/bin/test ] && mv /usr/bin/test /usr/bin/test.back
		;;
		"${commands[-1]}")
			echo -e "\nUsage: ${module_options["module_template,feature"]} <command>"
			echo -e "Commands:  ${module_options["module_template,example"]}"
			echo "Available commands:"
			echo -e "\tinstall\t- Install $title."
			echo -e "\tremove\t- Remove $title."
			echo
		;;
		*)
			${module_options["module_template,feature"]} ${commands[0]}
			${module_options["module_template,feature"]} ${commands[-1]}
		;;
	esac
	}

# uncomment to test the module
module_template "$1"




