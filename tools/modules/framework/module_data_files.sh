
framework_options+=(
	["module_data_files,maintainer"]="@Tearran"
	["module_data_files,feature"]="module_data_files"
	["module_data_files,desc"]="Example module unattended interface."
	["module_data_files,example"]="help array json dbt test all"
	["module_data_files,doc_link"]="Missing"
	["module_data_files,author"]="@Tearran"
	["module_data_files,group"]="Interface"
)
#
# Function to handle the module commands for 'module_data_files'
function module_data_files() {

	# Convert the example string to an array
	local commands
	IFS=' ' read -r -a commands <<< "${framework_options["module_data_files,example"]}"

	# Handle the command passed to the function
	case "$1" in
		"${commands[0]}")
		echo -e "\nUsage: ${framework_options["module_data_files,feature"]} <command>"
		echo -e "Commands:  ${framework_options["module_data_files,example"]}"
		echo "Available commands:"
		echo -e "\tarray\t- Generate framework_options files from production framework_options array."
		echo -e "\tjson\t- Generate JSON object from framework_options"
		echo -e "\tdbt\t- Generate DBT from framework_options"
		echo -e "\ttest\t- Generate unit-test CONF from framework_options."
		echo -e "\tall\t- Generate All above."
		echo
		;;
		"${commands[1]}")
		generate_data_files "_gen_data_array"
		;;
		"${commands[2]}")
		generate_data_files "_gen_data_json"
		;;
		"${commands[3]}")
		generate_data_files "_gen_data_dbt"
		;;
		"${commands[4]}")
		generate_data_files "_gen_unit_test_files"
		;;
		"all")
		generate_data_files "_gen_data_array"
		generate_data_files "_gen_data_json"
		generate_data_files "_gen_data_dbt"
		generate_data_files "_gen_unit_test_files"
		;;
		*)
		echo "${framework_options["module_data_files,example"]}"
		;;
	esac
}


framework_options+=(
	["generate_data_files,maintainer"]="@Tearran"
	["generate_data_files,feature"]="generate_data_files"
	["generate_data_files,example"]=""
	["generate_data_files,desc"]="Helper to sort module_option array"
	["generate_data_files,author"]="@Tearran"
	["generate_data_files,group"]="Docs"
	["generate_data_files,port"]=""
	["generate_data_files,arch"]=""
)
# Use production array to verify a parent/group and subgroup/subsubgroup keys are valid
# may be used to verify other keys if needed
function generate_data_files() {
	local generator=$1
	local i=0
	local g=0

	features=()
	for key in "${!framework_options[@]}"; do
		if [[ $key == *",feature" ]]; then
			features+=("${framework_options[$key]}")
		fi
	done

	for feature in "${features[@]}"; do

		i=$((i + 1))

		# Get keys pairs
		about_key="${feature},about"
		desc_key="${feature},desc"
		example_key="${feature},example"
		author_key="${feature},author"
		ref_key="${feature},ref_link"
		status_key="${feature},status"
		doc_key="${feature},doc_link"
		group_key="${feature},group"
		commands_key="${feature},commands"
		port_key="${feature},port"
		arch_key="${feature},arch"
		maintainer_key="${feature},maintainer"
		header_key="${feature},header"
		footer_key="${feature},footer"
		# Get array info
		about="${framework_options[$about_key]}"
		author="${framework_options[$author_key]}"
		ref_link="${framework_options[$ref_key]}"
		status="${framework_options[$status_key]}"
		doc_link="${framework_options[$doc_key]}"
		desc="${framework_options[$desc_key]}"
		example="${framework_options[$example_key]}"
		group="${framework_options[$group_key]}"
		commands="${framework_options[$commands_key]}"
		port="${framework_options[$port_key]}"
		arch="${framework_options[$arch_key]}"
		maintainer="${framework_options[$maintainer_key]}"
		header="${framework_options[$header_key]}"
		footer="${framework_options[$footer_key]}"
		if [[ -n "$group" ]]; then
			g=$((g + 10)) ;
			group_prefix=$(echo "${group:0:3}" | tr '[:lower:]' '[:upper:]') # Extract first 3 letters and convert to uppercase
			id=$(printf "%s%04d" "$group_prefix" "$g") # Combine prefix with padded number
		else
			id="$feature"
		fi

		# Set default values for missing fields
		doc_link="${doc_link:-Missing}"
		port="${port:-Unset}"
		arch="${arch:-Missing}"
		example="${example:-}"
		author="${author:-Unknown}"
		maintainer="${maintainer:-Needed}"
		footer="${footer:-None}"
		header="${header:-None}"
		# Use group_prefix for id
		# Check if group belongs to the software category
		case "$group" in
			WebHosting|HomeAutomation|DNS|Downloaders|Database|Upkeep|DevTools|Containers|Media|Monitoring|Management|Printing|Networking)
			parent="software"
			;;
			Kernel|Storage|Access|User|Updates)
			parent="system"
			;;
			Network|Wifi)
			parent="network"
			;;
			Localisation|Locals)
			parent="localisation"
			;;
			Message|Readme|Docs|Interface|Helper)
			parent="framework"
			;;
			Initialize|Runtime)
			parent="initialize"
			;;
			*)
			parent="fix"
			group="unknown"
			;;
		esac

		# Call the specified generator function
		if [[ $(type -t "$generator") == "function" ]]; then
			"$generator"
		else
			echo "Error: Invalid generator function '$generator'."
			return 1
		fi

	done

	chown -R "${SUDO_USER:-$USER}":"${SUDO_USER:-$USER}" "$tools_dir"
}


# adds missing keys to module_option array
_gen_data_array(){

	framework_options_file="$tools_dir/dev/array/${parent}/${feature}_array.sh"

	# Create the parent directory if it doesn't exist
	mkdir -p "$(dirname "$framework_options_file")"

cat << EOF > "$framework_options_file"
framework_options+=(
	["$feature,id"]="$id"
	["$feature,maintainer"]="$maintainer"
	["$feature,feature"]="$feature"
	["$feature,desc"]="$desc"
	["$feature,example"]="$example"
	["$feature,status"]="$status"
	["$feature,about"]=""
	["$feature,doc_link"]="$doc_link"
	["$feature,author"]="$author"
	["$feature,parent"]="$parent"
	["$feature,group"]="$group"
	["$feature,port"]="$port"
	["$feature,arch"]="$arch"
)

EOF

}

#
# output json objects for each module_option
#
_gen_data_json(){

	if [ "$group" != "unknown" ]; then
		[ "$parent" != "docs" ] && json_objects="$tools_dir/dev/json/${parent}/${group}/${feature}.json"
	else
		json_objects="$tools_dir/dev/json/fix-${parent}/${feature}.json"
	fi

	# Create the parent directory if it doesn't exist
	mkdir -p "$(dirname "$json_objects")"

	# Generate the JSON content and format it with jq before writing to the file
	jq --indent 4 -n --arg id "$id" \
		--arg desc "$desc" \
		--arg feature "$feature" \
		--arg author "$author" \
		--arg condition "$feature status | grep install" \
		'{
			"id": $id,
			"description": $desc,
			"command": ["see_menu \($feature)"],
			"status": "",
			"author": $author,
			"condition": $condition
		}' > "$json_objects"
}

framework_options+=(
	["_gen_data_dbt,maintainer"]="@Tearran"
	["_gen_data_dbt,feature"]="_gen_data_dbt"
	["_gen_data_dbt,example"]=""
	["_gen_data_dbt,desc"]="Helper for module_api"
	["_gen_data_dbt,status"]="Active"
	["_gen_data_dbt,condition"]=""
	["_gen_data_dbt,doc_link"]=""
	["_gen_data_dbt,author"]="@Tearran"
	["_gen_data_dbt,parent"]="docs"
	["_gen_data_dbt,group"]="Docs"
	["_gen_data_dbt,port"]=""
	["_gen_data_dbt,arch"]=""
)
#
# can output a Configuration file
#
_gen_data_dbt(){
	if [ "$group" != "unknown" ]; then
		dbt_file="$tools_dir/modules/${parent}/${feature}_database.dbt"
	else
		dbt_file="$tools_dir/dev/dbt/${parent}/${feature}_database.dbt"
	fi

	# Create the parent directory if it doesn't exist
	mkdir -p "$(dirname "$dbt_file")"

	# Create the .conf file with the defined variables
	{
		echo "[${feature}]"
		echo "id         = ${id}"
		echo "maintainer = ${maintainer}"
		echo "feature    = ${feature}"
		echo "desc       = ${desc}"
		echo "example    = ${example}"
		echo "status     = ${status}"
		echo "about      = ${about}"
		echo "doc_link   = ${doc_link}"
		echo "author     = ${author}"
		echo "parent     = ${parent}"
		echo "group      = ${group}"
		echo "port       = ${port}"
		echo "arch       = ${arch}"
	} > "$dbt_file"

}

#
# Testing consept to convert config file to module_option array
#
_convert_dbt_array(){
	# Ensure input file is provided
	if [[ $# -ne 1 ]]; then
		echo "Usage: $0 <input_file>"
		exit 1
	fi

	input_file="$1"
	output_file="${input_file%.dbt}_array.sh"  # Generate output based on input file name

	# Extract the module name from the first line (assumes it's in [brackets])
	module_name=$(awk -F'[][]' '/^\[/{print $2; exit}' "$input_file")

	# Ensure module_name is set
	if [[ -z "$module_name" ]]; then
		echo "Error: No module name found in $input_file"
		exit 1
	fi

	# Start writing the output file
	echo "framework_options+=(" > "$output_file"

	# Process key-value pairs
	awk -v module="$module_name" -F ' *= *' '
	NF == 2 {
		key=$1; value=$2;
		gsub(/"/, "\\\"", value); # Escape double quotes
		print "\t[\"" module "," key "\"]=\"" value "\"";
	}
	' "$input_file" >> "$output_file"

	# End the array
	echo ")" >> "$output_file"

}
#
# same testing as above
#
function _dbt_to_array() {
	local ini_file=$1
	declare -gA ini_options

	while IFS='=' read -r key value; do
		key="${key%%[[:space:]]*}"   # Trim spaces around the key
		value="${value##*[[:space:]]}" # Trim spaces around the value

		if [[ -n "$key" && "${key:0:1}" != "#" && "${key:0:1}" != ";" ]]; then
			ini_options["$key"]="$value"
		fi
	done < "$ini_file"
}

framework_options+=(
	["_gen_unit_test_files,maintainer"]="@Tearran"
	["_gen_unit_test_files,feature"]="_gen_unit_test_files"
	["_gen_unit_test_files,example"]=""
	["_gen_unit_test_files,desc"]="Helper for module_api"
	["_gen_unit_test_files,status"]="Active"
	["_gen_unit_test_files,condition"]=""
	["_gen_unit_test_files,doc_link"]=""
	["_gen_unit_test_files,author"]="@Tearran"
	["_gen_unit_test_files,parent"]="docs"
	["_gen_unit_test_files,group"]="Docs"
	["_gen_unit_test_files,port"]=""
	["_gen_unit_test_files,arch"]=""
)

	# Unrefined unit-test config file for  ./test/*.conf
function _gen_unit_test_files(){
	if [ "$group" != "unknown" ] && [ -n "$id" ]; then
		conf_file="$tools_dir/dev/tests/${id}.conf"
	else
		echo "Skipping unit test generation for feature '$feature' due to missing id or unknown group."
		return 0
	fi

	# Create the parent directory if it doesn't exist
	mkdir -p "$(dirname "$conf_file")"

	local commands
	IFS=' ' read -r -a commands <<< "${framework_options["$feature,example"]}"

	if [[ $parent == "software" ]]; then
		if printf '%s\n' "${commands[@]}" | grep -qx "help" && printf '%s\n' "${commands[@]}" | grep -qx "status"; then
		#if [[ " ${commands[@]} " =~ " help " && " ${commands[@]} " =~ " status " ]]; then
		{
		echo "ENABLED=true"
		echo "RELEASE=\"$arch\""
		echo "MENUID=\"$id\""
		echo ""
		echo "function testcase(){"

		for i in "${!commands[@]}"; do

			if [[ "${commands[$i]}" == "install" || "${commands[$i]}" == "setup"  ]]; then
				echo "		armbian-config --api $feature ${commands[$i]}"
				echo "		[[ -n \"\$condition\" ]]"
			elif [[ "${commands[$i]}" == "uninstall" || "${commands[$i]}" == "remove"  ]]; then
				echo "		armbian-config --api $feature ${commands[$i]}"
				echo "		[[ -z \"\$condition\" ]]"
			else
				continue
			fi
		done

		echo "}"

		} > "$conf_file"
		fi
	fi
}


