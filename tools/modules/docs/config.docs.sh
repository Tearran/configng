# This file is part of Armbian configuration utility.

module_options+=(
	["docs_markdown_manpage,author"]="@Tearran"
	["docs_markdown_manpage,ref_link"]=""
	["docs_markdown_manpage,feature"]="docs_markdown_manpage"
	["docs_markdown_manpage,desc"]="Generate Document files."
	["docs_markdown_manpage,example"]=""
	["docs_markdown_manpage,status"]="review"
)
#
# Function to generate the README.md file
#
function docs_markdown_manpage() {

	# Get the current date
	local current_date=$(date)

	# Setup the documentation and man-page directories
	local doc_dir="$script_dir/../"
	local man_dir="$script_dir/../share/man1"

	# Ensure the directories exist
	mkdir -p "$doc_dir"
	mkdir -p "$man_dir"

	echo -e "Sorting data\nUpdating documentation" # Log the process

	# Generate the Markdown documentation
	cat << EOF_DOC > "$doc_dir/DOCUMENTATION.md"
---
title: "armbian-config(1)"
author: "Armbian Team"
date: "$current_date"
---

<img alt="Armbian Config Logo" src="https://raw.githubusercontent.com/armbian/configng/main/share/icons/hicolor/scalable/configng-tux.svg">

# NAME
**Armbian Config** - The Next Generation

# SYNOPSIS
\`armbian-config[option] [arguments] [@]\`

# DESCRIPTION
\`armbian-config\` provides configuration and installation routines for customizing and automating tasks within the Armbian Linux environment. These utilities help streamline setup processes for various use cases, such as managing software, network settings, localization, and system optimizations.

# COMMAND-LINE OPTIONS
\`armbian-config\` can also be used directly from the command line with the following options:

## General Options
- Display help for specific categories or overall usage.

\`\`\`bash
armbian-config --help [cmd|System|Software|Network|Localisation]
\`\`\`

- Navigate directly to a specific menu location or ID.

\`\`\`bash
armbian-config --cmd help
\`\`\`

- Programmatically interact with an application module or its helper functions.
(applications parsing interface)
\`\`\`bash
armbian-config --api help
\`\`\`


# Directly open run menu item
\`\`\`bash
$(_cmd_list)
\`\`\`

# Directly access modules and helpers

\`\`\`bash
$(_api_list)
\`\`\`


---

# SEE ALSO
For more information, visit:
- [Armbian Documentation](https://docs.armbian.com/User-Guide_Armbian-Config/)
- [GitHub Repository](https://github.com/armbian/configng)

---

# COPYRIGHT
© 2025 Armbian Team. Distributed under the GPL 3.0 license.
EOF_DOC
	# Convert the Markdown documentation to a man page
	if pandoc -s -t man "$doc_dir/DOCUMENTATION.md" -o "$man_dir/armbian-config.1" && gzip -f "$man_dir/armbian-config.1"; then
		echo "Man page successfully generated at: $man_dir/armbian-config.1"
	else
		echo "An error occurred while generating the man page."
		return 1
	fi

	echo "Documentation and man page update completed."
}

module_options+=(
	["serve_doc,author"]="@Tearran"
	["serve_doc,ref_link"]=""
	["serve_doc,feature"]="serve_doc"
	["serve_doc,desc"]="Serve the edit and debug server."
	["serve_doc,example"]=""
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
	["generate_json_options,author"]="@Tearran"
	["generate_json_options,ref_link"]=""
	["generate_json_options,feature"]="generate_json"
	["generate_json_options,desc"]="Generate JSON-like object file."
	["generate_json_options,example"]="generate_json"
	["generate_json_options,status"]="review"
	["generate_json_options,doc_link"]=""
)
#
# Function to generate a JSON-like object file
#
function generate_json_options() {
	echo -e "{\n\"configng-helpers\" : ["
	features=()
	for key in "${!module_options[@]}"; do
		if [[ $key == *",feature" ]]; then
			features+=("${module_options[$key]}")
		fi
	done

	for index in "${!features[@]}"; do
		feature=${features[$index]}
		desc_key="${feature},desc"
		example_key="${feature},example"
		author_key="${feature},author"
		ref_key="${feature},ref_link"
		status_key="${feature},status"
		doc_key="${feature},doc_link"
		author="${module_options[$author_key]}"
		ref_link="${module_options[$ref_key]}"
		status="${module_options[$status_key]}"
		doc_link="${module_options[$doc_key]}"
		desc="${module_options[$desc_key]}"
		example="${module_options[$example_key]}"
		echo "  {"
		echo "    \"id\": \"$feature\","
		echo "    \"Author\": \"$author\","
		echo "    \"src_reference\": \"$ref_link\","
		echo "    \"description\": \"$desc\","
		echo "    \"command\": [ \"$example\" ]",
		echo "    \"status\": \"$status\","
		echo "    \"doc_link\": \"$doc_link\""
		if [ $index -ne $((${#features[@]} - 1)) ]; then
			echo "  },"
		else
			echo "  }"
		fi
	done
	echo "]"
	echo "}"
}

module_options+=(
	["generate_jobs_from_json,author"]="@Tearran"
	["generate_jobs_from_json,ref_link"]=""
	["generate_jobs_from_json,feature"]="generate_jobs_from_json"
	["generate_jobs_from_json,desc"]="Generate jobs from JSON file."
	["generate_jobs_from_json,example"]="generate_jobs_from_json"
	["generate_jobs_from_json,status"]="review"
	["generate_jobs_from_json,doc_link"]=""
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
	["see_jq_menu_list,author"]="@Tearran"
	["see_jq_menu_list,ref_link"]=""
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
	["_cmd_list,author"]="@Tearran"
	["_cmd_list,ref_link"]=""
	["_cmd_list,feature"]="_cmd_list"
	["_cmd_list,desc"]="Generate a Help message for cli commands."
	["_cmd_list,example"]="_cmd_list [category]"
	["_cmd_list,status"]="review"
	["_cmd_list,doc_link"]=""
)
#
# See command options
#
_cmd_list() {
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

