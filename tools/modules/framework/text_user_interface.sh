module_options+=(
	["interface_categories,author"]="@tearran"
	["interface_categories,maintainer"]="@igorpecovnik"
	["interface_categories,feature"]="interface_categories"
	["interface_categories,example"]="System Network Localisation Software About"
	["interface_categories,desc"]=""
	["interface_categories,status"]=""
	["interface_categories,doc_link"]=""
	["interface_categories,group"]="main"
	["interface_categories,port"]="9090"
	["interface_categories,arch"]="x86-64 arm64 armhf"
)

function  interface_categories() {
    # Ordered list of keys
    local keys
	IFS=' ' read -r -a keys <<< "${module_options["interface_categories,example"]}"

    local -A description=(
        ["System"]="System wide and admin settings (\$(uname -m))"
        ["Network"]="Fixed and wireless network settings (\$DEFAULT_ADAPTER)"
        ["Localisation"]="Localisation (\$LANG)"
        ["Software"]="Run/Install 3rd party applications (\$(see_current_apt))"
        ["About"]="About this tool"
    )

	case "$1" in
		"${keys[0]}")
		echo "${keys[0]}"
		;;

		"${keys[1]}")
		echo "{keys[1]}"
		;;

        "${keys[2]}")
		echo "{keys[2]}"
		;;

		"${keys[3]}")
		echo "{keys[3]}"
		;;

		"${keys[4]}")
		about_armbian_configng | interface_message 
		;;

		"menu")
        echo -e "\nUsage: ${module_options["interface_categories,feature"]} <command>"
        echo -e "Options:  ${module_options["interface_categories,example"]}"
        echo "Available keys:"
        for key in "${keys[@]}"; do
            eval "desc=\"${description[$key]}\""
            echo -e "\t$key\t- $desc"
        done
        echo
		;;
		*)
		${module_options["interface_categories,feature"]} ${keys[2]}
		;;
	esac
}
