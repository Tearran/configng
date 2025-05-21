module_options+=(
	["interface_categories,author"]="@tearran"
	["interface_categories,maintainer"]="@igorpecovnik"
	["interface_categories,feature"]="interface_categories"
	["interface_categories,example"]="System Network Localisation Software About"
	["interface_categories,desc"]="The main TUI menu list"
	["interface_categories,status"]=""
	["interface_categories,doc_link"]=""
	["interface_categories,group"]="main"
	["interface_categories,arch"]="x86-64 arm64 armhf"
)


_tui_system() {
	checkpoint debug "Text User Interface (TUI) is ($DIALOG)..."
}

_tui_network() {
	checkpoint debug "Text User Interface (TUI) is ($DIALOG)..."
}

_tui_localisation() {
	checkpoint debug "Text User Interface (TUI) is ($DIALOG)..."
}

_tui_software() {
	checkpoint debug "Text User Interface (TUI) is ($DIALOG)..."
}

_tui_about() {
	checkpoint debug "Text User Interface (TUI) is ($DIALOG)..."
}

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
		_tui_system
		;;

		"${keys[1]}")
		_tui_network
		;;

        "${keys[2]}")
		_tui_localisation
		;;

		"${keys[3]}")
		_tui_software
		;;

		"${keys[4]}")
		_tui_about
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
