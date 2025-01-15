
function set_json_data() {
	local i=0

	features=()
	for key in "${!module_options[@]}"; do
		if [[ $key == *",feature" ]]; then
			features+=("${module_options[$key]}")
		fi
	done

{
	echo -e "["

	for feature in "${features[@]}"; do
		feature_prefix=$(echo "${feature:0:3}" | tr '[:lower:]' '[:upper:]') # Extract first 3 letters and convert to uppercase

		i=$((i + 1))
		id=$(printf "%s%03d" "$feature_prefix" "$i") # Combine prefix with padded number

		# Get keys pairs
		desc_key="${feature},desc"
		example_key="${feature},example"
		author_key="${feature},author"
		ref_key="${feature},ref_link"
		status_key="${feature},status"
		doc_key="${feature},doc_link"
		helpers_key="${feature},helpers"
		group_key="${feature},group"
		commands_key="${feature},commands"
		port_key="${feature},port"
		arch_key="${feature},arch"

		# Get array info
		author="${module_options[$author_key]}"
		ref_link="${module_options[$ref_key]}"
		status="${module_options[$status_key]}"
		doc_link="${module_options[$doc_key]}"
		desc="${module_options[$desc_key]}"
		example="${module_options[$example_key]}"
		helpers="${module_options[$helpers_key]}"
		group="${module_options[$group_key]}"
		commands="${module_options[$commands_key]}"
		port="${module_options[$port_key]}"
		arch="${module_options[$arch_key]}"

		echo "  {"
		echo "    \"id\": \"$id\","
		echo "    \"feature\": \"$feature\","
		echo "    \"helpers\": \"$helpers\","
		echo "    \"description\": \"$desc ($feature)\","
		echo "    \"command\": \"$feature\","
		echo "    \"options\": \"$example\","
		echo "    \"status\": \"$status\","
		echo "    \"condition\": \" \","
		echo "    \"reference\": \"$ref_link\","
		echo "    \"author\": \"$author\","
		echo "    \"group\": \"$group\","
		echo "    \"commands\": \"$commands\","
		echo "    \"port\": \"$port\","
		echo "    \"arch\": \"$arch\""

		if [ $i -ne ${#features[@]} ]; then
			echo "  },"
		else
			echo "  }"
		fi
	done
	echo "]"

} | jq --tab --indent 4 '.'


}


function set_software_list() {
	set_json_data | jq '
	# Define an array of allowed software groups
	def softwareGroups: ["WebHosting", "Netconfig", "Downloaders", "Database", "DNS", "DevTools", "HomeAutomation", "Benchy", "Containers", "Media", "Monitoring", "Management"];

	{
	"menu": [
	{
		"id": "Software",
		"description": "Run/Install 3rd party applications",
		"sub": (
		group_by(.group)
		# Skip grouped arrays where the group is null, empty, or not in softwareGroups
		| map(select(.[0].group != null and .[0].group != "" and (.[0].group | IN(softwareGroups[]))))
		| map({
		"id": .[0].group,
		"description": .[0].group,
		"sub": (
			map({
			"id": .id,
			"description": .description,
			"command": [("see_menu " + .feature)],
			"options": ("help " + .options + " status"),
			"status": .status,
			"condition": "",
			"author": .author
			})
		)
		})
		)
	}
	]
	}
	'
	}

function set_system_list() {
	set_json_data | jq '
	# Define an array of allowed software groups
	def systemGroups: ["Kernel", "Storage", "Access", "User", "Updates"];

	{
	"menu": [
	{
		"id": "System",
		"description": "System wide and admin settings",
		"sub": (
		group_by(.group)
		# Skip grouped arrays where the group is null, empty, or not in ssystemGroups
		| map(select(.[0].group != null and .[0].group != "" and (.[0].group | IN(systemGroups[]))))
		| map({
		"id": .[0].group,
		"description": .[0].group,
		"sub": (
			map({
			"id": .id,
			"description": .description,
			"command": [("see_menu " + .feature)],
			"options": ("help " + .options + " status"),
			"status": .status,
			"condition": "",
			"author": .author
			})
		)
		})
		)
	}
	]
	}
	'
}

# Test Function



function gen_jobs_json() {

	# Get the menu groups
	system_json=$(set_system_list )
	#network_json=$(network_list)
	#localisation_json=$(localisation_ist)
	software_json=$(set_software_list)
	#about_json=$(about_list)

	# Get the system menu JSON
	#menu_json=$(<"$json_file")
	menu_json=$(jq -n '{menu: []}')
	# Now, merge them by appending the software section to the "menu" array in set_menu_groups
	merged_json=$(echo "$menu_json" | jq ".menu += set_software_list.menu")

	# Output the merged JSON
	echo "$merged_json" | jq .
}


interface_module_option() {


	generate_menu "System" "$set_system_list"
	#generate_menu "Software" "$set_software_list"
	#generate_top_menu "$json_data"
}

# Function to display the whiptail menu and handle the user's selection
function main_menu() {
    while true; do
        CHOICE=$(whiptail --title "Main Menu" --menu "Choose an option" 15 60 4 \
            "System" "System wide and admin settings" \
            "Software" "Run/Install 3rd party applications" \
            "Exit" "Exit the script" 3>&1 1>&2 2>&3)

        case $CHOICE in
            "System")
                generate_menu "System" "$set_system_list"
	#generate_menu "Software" "$set_software_list"
                ;;
            "Software")
                generate_menu "System" "$set_system_list"
	#generate_menu "Software" "$set_software_list"
                ;;
            "Exit")
                break
                ;;
            *)
                break
                ;;
        esac
    done
}


# Define module options for main_menu
module_options+=(
    ["module_main_menu,author"]="@Tearran"
    ["module_main_menu,maintainer"]="@Tearran"
    ["module_main_menu,feature"]="module_main_menu"
    ["module_main_menu,example"]="help run"
    ["module_main_menu,desc"]="Main menu displaying system and software options."
    ["module_main_menu,status"]="Active"
    ["module_main_menu,doc_link"]="https://example.com/docs/main_menu"
    ["module_main_menu,group"]="Management"
    ["module_main_menu,arch"]="x86-64 arm64 armhf"
)

# Function to display the whiptail menu and handle the user's selection
function module_main_menu() {
    local title="main_menu"
    local commands
    IFS=' ' read -r -a commands <<< "${module_options["module_main_menu,example"]}"

    case "$1" in
        "${commands[0]}")
            ## help/menu options for the module
            echo -e "\nUsage: ${module_options["module_main_menu,feature"]} <command>"
            echo -e "Commands: ${module_options["module_main_menu,example"]}"
            echo "Available commands:"
            echo -e "  run\t- Run the main menu."
            ;;
        "${commands[1]}")
            ## run the main menu
            while true; do
                CHOICE=$(whiptail --title "Main Menu" --menu "Choose an option" 15 60 4 \
                    "System" "System wide and admin settings" \
                    "Software" "Run/Install 3rd party applications" \
                    "Exit" "Exit the script" 3>&1 1>&2 2>&3)

                case $CHOICE in
                    "System")
                        generate_menu "System" "$set_system_list"
                        ;;
                    "Software")
                        generate_menu "Software" "$set_software_list"
                        ;;
                    "Exit")
                        break
                        ;;
                    *)
                        break
                        ;;
                esac
            done
            ;;
        *)
            echo "Invalid command. Try: '${module_options["module_main_menu,example"]}'"
            ;;
    esac
}
