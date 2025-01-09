#!/bin/bash

# This file is part of Armbian configuration utility.

module_options+=(
	["generate_readme,author"]="@Tearran"
	["generate_readme,ref_link"]=""
	["generate_readme,feature"]="generate_readme"
	["generate_readme,desc"]="Generate Document files."
	["generate_readme,example"]="generate_readme"
	["generate_readme,status"]="review"
	["generate_readme,group"]="Messages"
)
#
# Function to generate the README.md file
#
function generate_readme() {

	# Get the current date
	local current_date=$(date)
	# setup doc folders
	#mkdir -p "$script_dir/../share/doc/armbian-config"

	echo -e "Sorting data\nUpdating documentation" # current_date ;

	cat << EOF > "$script_dir/../DOCUMENTATION.md"

# Armbian Configuration Utility

<img src="https://raw.githubusercontent.com/armbian/configng/main/share/icons/hicolor/scalable/configng-tux.svg">

Utility for configuring your board, adjusting services, and installing applications. It comes with Armbian by default.

To start the Armbian configuration utility, use the following command:
~~~
sudo armbian-config
~~~

$(see_full_list)

## Install
Armbian installation
~~~
sudo apt install armbian-config
~~~

3rd party Debian based distributions
~~~
{
	sudo wget https://apt.armbian.com/armbian.key -O key
	sudo gpg --dearmor < key | sudo tee /usr/share/keyrings/armbian.gpg > /dev/null
	sudo chmod go+r /usr/share/keyrings/armbian.gpg
	sudo echo "deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/armbian.gpg] http://apt.armbian.com \$(lsb_release -cs) main  \$(lsb_release -cs)-utils  \$(lsb_release -cs)-desktop" | sudo tee /etc/apt/sources.list.d/armbian.list
	sudo apt update
	sudo apt install armbian-config
}
~~~

***

## CLI options
Command line options.

Use:
~~~
armbian-config --help
~~~

Outputs:
~~~
$(see_cmd_list)
~~~

## Legacy options
Backward Compatible options.

Use:
~~~
armbian-config main=Help
~~~

Outputs:
~~~
$(see_cli_legacy)
~~~

***

## Development

Development is divided into three sections:

Click for more info:

<details>
<summary><b>Jobs / JSON Object</b></summary>

A list of the jobs defined in the Jobs file.
~~~
$(see_jq_menu_list)
~~~
</details>


<details>
<summary><b>Jobs API / Helper Functions</b></summary>

These helper functions facilitate various operations related to job management, such as creation, updating, deletion, and listing of jobs, acting as a practical API for developers.

$(see_function_table_md)


</details>


<details>
<summary><b>Runtime / Board Statuses</b></summary>

(WIP)

This section outlines the runtime environment to check configurations and statuses for dynamically managing jobs based on JSON data.

(WIP)

</details>


## Testing and contributing

<details>
<summary><b>Get Development</b></summary>

Install the dependencies:
~~~
sudo apt install git jq whiptail
~~~

Get Development and contribute:
~~~
{
git clone https://github.com/armbian/configng
cd configng
./armbian-config --help
}
~~~

Install and test Development deb:
~~~
{
	sudo apt install whiptail
	latest_release=\$(curl -s https://api.github.com/repos/armbian/configng/releases/latest)
	deb_url=\$(echo "\$latest_release" | jq -r '.assets[] | select(.name | endswith(".deb")) | .browser_download_url')
	curl -LO "\$deb_url"
	deb_file=\$(echo "\$deb_url" | awk -F"/" '{print \$NF}')
	sudo dpkg -i "\$deb_file"
	sudo dpkg --configure -a
	sudo apt --fix-broken install
}
~~~

</details>

EOF

}

module_options+=(
	["serve_doc,author"]="@Tearran"
	["serve_doc,ref_link"]=""
	["serve_doc,feature"]="serve_doc"
	["serve_doc,desc"]="Serve the edit and debug server."
	["serve_doc,example"]="serve_doc"
	["serve_doc,status"]="active"
	["serve_doc,doc_link"]=""
)
#
# Function to serve the edit and debug server
#
function serve_doc() {
	if [[ "$(id -u)" == "0" ]]; then
		echo "Red alert! not for sudo user"
		exit 1
	fi
	if [[ -z $CODESPACES ]]; then
		# Start the Python server in the background
		python3 -m http.server > /tmp/config.log 2>&1 &
		local server_pid=$!
		local input=("
	Starting server...
		Server PID: $server_pid

	Press [Enter] to exit"
		)

		$DIALOG --title "Message Box" --msgbox "$input" 0 0

		# Stop the server
		kill "$server_pid"
	else
		echo "Info:GitHub Codespace"
		exit 0
	fi
}

module_options+=(
	["see_use,author"]="@Tearran"
	["see_use,ref_link"]=""
	["see_use,feature"]="see_use"
	["see_use,desc"]="Show the usage of the functions."
	["see_use,example"]="see_use"
	["see_use,status"]="review"
	["see_use,doc_link"]=""
	["see_use,group"]="Messages"
)
#
# Function to parse the key-pairs  (WIP)
#
function see_use() {
	mod_message="Usage: \n\n"
	# Iterate over the options
	for key in "${!module_options[@]}"; do
		# Split the key into function_name and type
		IFS=',' read -r function_name type <<< "$key"
		# If the type is 'long', append the option to the help message
		if [[ "$type" == "feature" ]]; then
			mod_message+="${module_options["$function_name,feature"]} - ${module_options["$function_name,desc"]}\n"
			mod_message+="  ${module_options["$function_name,example"]}\n\n"
		fi
	done

	echo -e "$mod_message"
}

module_options+=(
	["generate_jobs_from_json,author"]="@Tearran"
	["generate_jobs_from_json,ref_link"]=""
	["generate_jobs_from_json,feature"]="generate_jobs_from_json"
	["generate_jobs_from_json,desc"]="Generate jobs from JSON file."
	["generate_jobs_from_json,example"]="generate_jobs_from_json"
	["generate_jobs_from_json,status"]="review"
	["generate_jobs_from_json,doc_link"]=""
	["generate_jobs_from_json,group"]="Messages"
)
#
# This function is used to generate jobs links Table from JSON file.
#
function see_jobs_from_json_md() {

	echo -e "\n"

	# Use jq to parse the JSON
	menu_items=$(jq -r '.menu | length' "$json_file")

	for ((i = 0; i < $menu_items; i++)); do
		cat=$(jq -r ".menu[$i].id" "$json_file")
		description=$(jq -r ".menu[$i].description" "$json_file")
		#echo -e "## $cat\n"
		#echo -e "$description\n"
		echo -e "| "$cat" | ID  | Description | Documents | Status |"
		echo -e "|:------ | :-- | :---------- | --------: | ------:|"

		sub_items=$(jq -r ".menu[$i].sub | length" "$json_file")

		for ((j = 0; j < $sub_items; j++)); do
			id=$(jq -r ".menu[$i].sub[$j].id" "$json_file")
			id_link=$(jq -r ".menu[$i].sub[$j].id" "$json_file" | tr '[:upper:]' '[:lower:]')
			description=$(jq -r ".menu[$i].sub[$j].description" "$json_file")
			command=$(jq -r ".menu[$i].sub[$j].command" "$json_file")
			status=$(jq -r ".menu[$i].sub[$j].status" "$json_file")
			doc_link=$(jq -r ".menu[$i].sub[$j].doc_link" "$json_file")

			# Check if src_reference and doc_link are null
			[ -z "$doc_link" ] && doc_link="#$id_link" || doc_link="[Document]($doc_link)"

			echo -e "| | $id | $description | $doc_link | $status |"

		done
		echo -e "\n"
	done

}



function see_full_list() {
	# Use jq to parse the JSON into markdown
		menu_items=$(echo "$json_data" | jq -r '.menu | length')

	for ((i = 0; i < menu_items; i++)); do
		cat=$(jq -r ".menu[$i].id" "$json_file")
		description=$(jq -r ".menu[$i].description" "$json_file")

		echo -e "- ## **$cat** \n"

		sub_items=$(jq -r ".menu[$i].sub | length" "$json_file")

		for ((j = 0; j < sub_items; j++)); do
			id=$(jq -r ".menu[$i].sub[$j].id" "$json_file")
			sub_description=$(jq -r ".menu[$i].sub[$j].description" "$json_file")

			echo -e "  - ### $sub_description"

			# Handle nested sub-items
			nested_sub_items=$(jq -r ".menu[$i].sub[$j].sub | length" "$json_file")

			# Check if nested sub-items are present
			if [ "$nested_sub_items" -gt 0 ]; then
				for ((k = 0; k < nested_sub_items; k++)); do
					nested_id=$(jq -r ".menu[$i].sub[$j].sub[$k].id" "$json_file")
					nested_description=$(jq -r ".menu[$i].sub[$j].sub[$k].description" "$json_file")

					echo -e "    - ### $nested_description"
				done
			fi

			echo -e "\n"
		done
		echo -e "\n"
	done
}

module_options+=(
	["see_function_table_md,author"]="@Tearran"
	["see_function_table_md,feature"]="see_function_table_md"
	["see_function_table_md,desc"]="Generate this markdown table of all module_options"
	["see_function_table_md,example"]="see_function_table_md"
	["see_function_table_md,status"]="review"
	["see_function_table_md,doc_link"]=""
	["see_function_table_md,group"]="Messages"

)
#
# This function is used to generate a markdown table from the module_options array
#
function see_function_table_md() {
	mod_message="| Description | Example | Credit |\n"
	mod_message+="|:----------- | ------- |:------:|\n"
	# Iterate over the options
	for key in "${!module_options[@]}"; do
		# Split the key into function_name and type
		IFS=',' read -r function_name type <<< "$key"
		# If the type is 'feature', append the option to the help message
		if [[ "$type" == "feature" ]]; then
			status=${module_options["$function_name,status"]}
			ref_link=${module_options["$function_name,ref_link"]}
			doc_link=${module_options["$function_name,doc_link"]}
			ref_link_md=$([[ -n "$ref_link" ]] && echo "[Source]($ref_link)" || echo "X")
			doc_link_md=$([[ -n "$doc_link" ]] && echo "[Document]($doc_link)" || echo "X")
			status_md=$([[ -z "$ref_link" ]] && echo "source link Needed" || ([[ (-n "$ref_link" && -n "$doc_link") ]] && echo "Review" || echo "$status"))
			mod_message+="| ${module_options["$function_name,desc"]} | ${module_options["$function_name,example"]} | ${module_options["$function_name,author"]} \n"
		fi
	done

	echo -e "$mod_message"
}

module_options+=(
	["see_jq_menu_list,author"]="@Tearran"
	["see_jq_menu_list,group"]="Messages"
	["see_jq_menu_list,feature"]="see_jq_menu_list"
	["see_jq_menu_list,desc"]="Generate a markdown list json objects using jq."
	["see_jq_menu_list,example"]="see_jq_menu_list"
	["see_jq_menu_list,status"]="review"
	["see_jq_menu_list,doc_link"]=""
)
#
# This function is used to generate a markdown list from the json object using jq.
#
function see_jq_menu_list() {
	jq -r '
	.menu[] |
	.sub[] |
	"### " + .id + "\n\n" +
	(.description // "No description available") + "\n\nJobs:\n\n~~~\n" +
	((.command // ["No commands available"]) | join("\n")) +
	"\n~~~\n"
' $json_file
}

module_options+=(
	["see_cmd_list,author"]="@Tearran"
	["see_cmd_list,group"]="Messages"
	["see_cmd_list,feature"]="see_cmd_list"
	["see_cmd_list,desc"]="Generate a Help message for cli commands."
	["see_cmd_list,example"]="see_cmd_list [category]"
	["see_cmd_list,status"]="review"
	["see_cmd_list,doc_link"]=""
)
#
# See command options
#
see_cmd_list() {
	local help_menu="$1"

	if [[ -n "$help_menu" && "$help_menu" != "cmd" ]]; then
		echo "$json_data" | jq -r --arg menu "$help_menu" '
		def recurse_menu(menu; level):
		menu | .id as $id | .description as $desc |
		if has("sub") then
			if level == 0 then
				"\n  \($id) - \($desc)\n" + (.sub | map(recurse_menu(. ; level + 1)) | join("\n"))
			elif level == 1 then
				"    \($id) - \($desc)\n" + (.sub | map(recurse_menu(. ; level + 1)) | join("\n"))
			else
				"      \($id) - \($desc)\n" + (.sub | map(recurse_menu(. ; level + 1)) | join("\n"))
			end
		else
			if level == 0 then
				"  --cmd \($id) - \($desc)"
			elif level == 1 then
				"    --cmd \($id) - \($desc)"
			else
				"\t--cmd \($id) - \($desc)"
			end
		end;

		# Find the correct menu if $menu is passed, otherwise show all
		if $menu == "" then
			.menu | map(recurse_menu(. ; 0)) | join("\n")
		else
			.menu | map(select(.id == $menu) | recurse_menu(. ; 0)) | join("\n")
		end
		'
	elif [[ -z "$1" || "$1" == "cmd" ]]; then
		echo "$json_data" | jq -r --arg menu "$help_menu" '
		def recurse_menu(menu; level):
		menu | .id as $id | .description as $desc |
		if has("sub") then
			if level == 0 then
				"\n  \($id) - \($desc)\n" + (.sub | map(recurse_menu(. ; level + 1)) | join("\n"))
			elif level == 1 then
				"    \($id) - \($desc)\n" + (.sub | map(recurse_menu(. ; level + 1)) | join("\n"))
			else
				"      \($id) - \($desc)\n" + (.sub | map(recurse_menu(. ; level + 1)) | join("\n"))
			end
		else
			if level == 0 then
				"  --cmd \($id) - \($desc)"
			elif level == 1 then
				"    --cmd \($id) - \($desc)"
			else
				"\t--cmd \($id) - \($desc)"
			end
		end;
		.menu | map(recurse_menu(. ; 0)) | join("\n")
		'

	else
		echo "nope"
	fi
}


module_options+=(
	["see_cli_legacy,author"]="@Tearran"
	["see_cli_legacy,feature"]="see_cli_legacy"
	["see_cli_legacy,desc"]="Generate a Help message legacy cli commands."
	["see_cli_legacy,example"]="see_cli_legacy"
	["see_cli_legacy,status"]="review"
	["see_cli_legacy,doc_link"]=""
	["see_cli_legacy,group"]="Messages"
)
function see_cli_legacy() {
	local script_name=$(basename "$0")
	cat << EOF
Legacy Options (Backward Compatible)
Please use 'armbian-config --help' for more information.

Usage:  $script_name main=[arguments] selection=[options]

EOF

cat << EOF
	$script_name main=System selection=Headers          -  Install headers:
	$script_name main=System selection=Headers_remove   -  Remove headers:
EOF

	# TODO Migrate following features

	# $script_name main=System   selection=Firmware         -  Update, upgrade and reboot:
	# $script_name main=System   selection=Nightly          -  Switch to nightly builds:
	# $script_name main=System   selection=Stable           -  Switch to stable builds:
	# $script_name main=System   selection=Default          -  Install default desktop:
	# $script_name main=System   selection=ZSH              -  Change to ZSH:
	# $script_name main=System   selection=BASH             -  Change to BASH:
	# $script_name main=System   selection=Stable           -  Change to stable repository [branch=dev]:
	# $script_name main=System   selection=Nightly          -  Change to nightly repository [branch=dev]:
	# $script_name main=Software selection=Source_install   -  Install kernel source:
	# $script_name main=Software selection=Source_remove    -  Remove kernel source:
	# $script_name main=Software selection=Avahi            -  Install Avahi mDNS/DNS-SD daemon:

}

