framework_options+=(
	["markdown_manpage,author"]="@Tearran"
	["markdown_manpage,ref_link"]=""
	["markdown_manpage,feature"]="markdown_manpage"
	["markdown_manpage,desc"]="Generate Document files."
	["markdown_manpage,options"]=""
	["markdown_manpage,group"]="Docs"
)
#
# Function to generate the README.md file
# Generates Markdown documentation and a compressed man page for the armbian-config tool.
#
# Globals:
#
# * SCRIPT_DIR: Used to determine documentation and man page output locations.
# * framework_options: Used to generate the list of available features.
#
# Outputs:
#
# * Writes a DOCUMENTATION.md file with tool usage, options, and references.
# * Produces a compressed man page (armbian-config.1.gz) in the appropriate directory.
#
# Returns:
#
# * 1 if man page generation fails; otherwise, returns the exit status of the last command.
#
# Example:
#
# ```bash
# markdown_manpage
# # Generates DOCUMENTATION.md and armbian-config.1.gz in their respective directories.
# ```
function markdown_manpage() {

	# Get the current date
	local current_date=$(date)

	# Setup the documentation and man-page directories
	local doc_dir="$SCRIPT_DIR/../"
	local man_dir="$SCRIPT_DIR/../share/man1"

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
- Display help for specific module or overall usage.

\`\`\`bash
armbian-config [--help | -h | help] | [module_name]
\`\`\`
- List of all available features
\`\`\`bash
$(options_list framework_options)
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


framework_options+=(
	["markdown_framework_options,author"]="@Tearran"
	["markdown_framework_options,ref_link"]=""
	["markdown_framework_options,feature"]="markdown_framework_options"
	["markdown_framework_options,desc"]="Markdown table of all framework_options"
	["markdown_framework_options,options"]=""
	["markdown_framework_options,group"]="Docs"
)
#
# This function is used to generate a markdown table from the framework_options array
# Generates a Markdown table summarizing all registered framework features.
#
# Outputs:
#
# * Prints a Markdown-formatted table with columns for Description, Options, and Credit, listing all entries in the `framework_options` array marked as features.
#
# Example:
#
# ```bash
# markdown_framework_options
# # | Description | Options | Credit |
# # |:----------- | ------- |:------:|
# # | ...         | ...     | ...    |
# ```
function markdown_framework_options() {
	mod_message="| Description | Options | Credit |\n"
	mod_message+="|:----------- | ------- |:------:|\n"
	# Iterate over the options
	for key in "${!framework_options[@]}"; do
		# Split the key into function_name and type
		IFS=',' read -r function_name type <<< "$key"
		# If the type is 'feature', append the option to the help message
		if [[ "$type" == "feature" ]]; then
			ref_link=${framework_options["$function_name,ref_link"]}
			doc_link=${framework_options["$function_name,doc_link"]}
			ref_link_md=$([[ -n "$ref_link" ]] && echo "[Source]($ref_link)" || echo "X")
			doc_link_md=$([[ -n "$doc_link" ]] && echo "[Document]($doc_link)" || echo "X")
			status_md=$([[ -z "$ref_link" ]] && echo "source link Needed" || ([[ (-n "$ref_link" && -n "$doc_link") ]] && echo "Review" || echo "$status"))
			mod_message+="| ${framework_options["$function_name,desc"]} | ${framework_options["$function_name,options"]} | ${framework_options["$function_name,author"]} \n"
		fi
	done

	echo -e "$mod_message"
}

framework_options+=(
	["docs_markdown_manpage,author"]="@Tearran"
	["docs_markdown_manpage,ref_link"]=""
	["docs_markdown_manpage,feature"]="docs_markdown_manpage"
	["docs_markdown_manpage,desc"]="Generate Document files."
	["docs_markdown_manpage,options"]=""
	["docs_markdown_manpage,group"]="Docs"
)
#
# Function to generate the README.md file
# Generates Markdown documentation and a compressed man page for the armbian-config tool, including command-line usage examples and API references.
#
# Globals:
#
# * SCRIPT_DIR: Used to determine documentation and man page output locations.
#
# Outputs:
#
# * Writes a DOCUMENTATION.md file to the documentation directory.
# * Generates a compressed man page (armbian-config.1.gz) in the man page directory.
# * Prints status and error messages to STDOUT.
#
# Returns:
#
# * Returns 1 if man page generation fails; otherwise, returns the exit status of the last command.
#
# Example:
#
# ```bash
# docs_markdown_manpage
# # Generates DOCUMENTATION.md and armbian-config.1.gz in their respective directories.
# ```
function docs_markdown_manpage() {

	# Get the current date
	local current_date=$(date)

	# Setup the documentation and man-page directories
	local doc_dir="$SCRIPT_DIR/../"
	local man_dir="$SCRIPT_DIR/../share/man1"

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

	checkpoint debug "Documentation and man page update completed."
}
