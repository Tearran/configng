

# usage: bash module_template.sh help
# uncoment to test
#declare -A module_options

module_options+=(
	["module_template,maintainer"]="@Tearran"
	["module_template,feature"]="module_template"
	["module_template,example"]="help install remove status"
	["module_template,desc"]="Example module unattended interface."
	["module_template,status"]="Active"
	["module_template,condition"]=""
	["module_template,doc_link"]=""
	["module_template,author"]="@Tearran"
	["module_template,parent"]="Helper"
	["module_template,group"]="Develoment"
	["module_template,port"]=""
	["module_template,arch"]=""
)

function module_template() {
	local title="test"
	local condition=$(which "$title" 2>/dev/null)

	# Convert the example string to an array
	local commands
	IFS=' ' read -r -a commands <<< "${module_options["module_template,example"]}"

	case "$1" in
		"${commands[0]}")
		echo -e "\nUsage: ${module_options["module_template,feature"]} <command>"
		echo -e "Commands:  ${module_options["module_template,example"]}"
		echo "Available commands:"
		echo -e "\tinstall\t- Install $title."
		echo -e "\tremove\t- Remove $title."
		echo
		;;
		"${commands[1]}")
		echo "Installing $title..."
		# Installation logic here
		;;
		"${commands[2]}")
		echo "Removing $title..."
		# Removal logic here
		;;
		"${commands[-1]}")
			# use module_name status | grep option
			[[ ! -f "/bin/test" ]] && echo -e "\t${commands[1]}\t- Install $title."
			[[ -f "/bin/test" ]]  && echo -e "\t${commands[2]}\t- Remove $title."
		;;
		*)
		${module_options["module_template,feature"]} ${commands[-1]}
		;;
	esac
	}

# uncomment to test the module
# module_template "$1"




