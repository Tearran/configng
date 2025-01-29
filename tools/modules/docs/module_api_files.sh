

module_helper+=(
	["geneate_files_api,maintainer"]="@Tearran"
	["geneate_files_api,feature"]="geneate_files_api"
	["geneate_files_api,example"]=""
	["geneate_files_api,desc"]="Helper for module_api"
	["geneate_files_api,status"]="Active"
	["geneate_files_api,condition"]=""
	["geneate_files_api,doc_link"]=""
	["geneate_files_api,author"]="@Tearran"
	["geneate_files_api,parent"]="docs"
	["geneate_files_api,group"]="docs"
	["geneate_files_api,port"]=""
	["geneate_files_api,arch"]=""
)

function geneate_files_api() {
	local generator=$1
	local i=0

	features=()
	for key in "${!module_options[@]}"; do
		if [[ $key == *",feature" ]]; then
		features+=("${module_options[$key]}")
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
		about="${module_options[$about_key]}"
		author="${module_options[$author_key]}"
		ref_link="${module_options[$ref_key]}"
		status="${module_options[$status_key]}"
		doc_link="${module_options[$doc_key]}"
		desc="${module_options[$desc_key]}"
		example="${module_options[$example_key]}"
		group="${module_options[$group_key]}"
		commands="${module_options[$commands_key]}"
		port="${module_options[$port_key]}"
		arch="${module_options[$arch_key]}"
		maintainer="${module_options[$maintainer_key]}"
		header="${module_options[$header_key]}"
		footer="${module_options[$footer_key]}"
		if [[ -n group ]]; then
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
			WebHosting|HomeAutomation|DNS|Downloaders|Database|DevTools|Containers|Media|Monitoring|Management|Updates|Printing|Netconfig)
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
			Messages|Readme|Docs)
			parent="docs"
			;;
			Core|TUI|Interface|Helper)
			parent="functions"
			;;
			*)
			parent="unknown"
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


module_helper+=(
	["gen_api_array,maintainer"]="@Tearran"
	["gen_api_array,feature"]="gen_api_array"
	["gen_api_array,example"]=""
	["gen_api_array,desc"]="Helper for module_api"
	["gen_api_array,status"]="Active"
	["gen_api_array,condition"]=""
	["gen_api_array,doc_link"]=""
	["gen_api_array,author"]="@Tearran"
	["gen_api_array,parent"]="docs"
	["gen_api_array,group"]="Docs"
	["gen_api_array,port"]=""
	["gen_api_array,arch"]=""
)
#
gen_api_array(){
		# Determine the file path based on group
	if [ "$group" != "unknown" ]; then
		module_options_file="$tools_dir/modules/${parent}/${feature}_array.sh"
	else
		module_options_file="$tools_dir/dev/array/${feature}_array.sh"
	fi


        # Create the parent directory if it doesn't exist
        mkdir -p "$(dirname "$module_options_file")"


	cat << EOF > "$module_options_file"
module_options+=(
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


module_helper+=(
	["gen_api_json,maintainer"]="@Tearran"
	["gen_api_json,feature"]="gen_api_json"
	["gen_api_json,example"]=""
	["gen_api_json,desc"]="Helper for module_api"
	["gen_api_json,status"]="Active"
	["gen_api_json,condition"]=""
	["gen_api_json,doc_link"]=""
	["gen_api_json,author"]="@Tearran"
	["gen_api_json,parent"]="docs"
	["gen_api_json,group"]="Docs"
	["gen_api_json,port"]=""
	["gen_api_json,arch"]=""
)

gen_api_json(){

	if [ "$group" != "unknown" ]; then
		json_opjects="$tools_dir/dev/json/${parent}/${feature}.json"
	else
		json_opjects="$tools_dir/dev/json/${parent}/${feature}.json"
	fi

	# Create the parent directory if it doesn't exist
	mkdir -p "$(dirname "$json_opjects")"

	cat << EOF > "$json_opjects"
{
	"id": "$id",
	"description": "$desc",
	"command": [
	"see_menu $feature"
	],
	"status": "",
	"author": "$author",
	"condition": "$feature status | grep install"
}
EOF

}

module_helper+=(
	["gen_api_dbt,maintainer"]="@Tearran"
	["gen_api_dbt,feature"]="gen_api_dbt"
	["gen_api_dbt,example"]=""
	["gen_api_dbt,desc"]="Helper for module_api"
	["gen_api_dbt,status"]="Active"
	["gen_api_dbt,condition"]=""
	["gen_api_dbt,doc_link"]=""
	["gen_api_dbt,author"]="@Tearran"
	["gen_api_dbt,parent"]="docs"
	["gen_api_dbt,group"]="Docs"
	["gen_api_dbt,port"]=""
	["gen_api_dbt,arch"]=""
)
#
gen_api_dbt(){
        if [ "$group" != "unknown" ]; then
        	dbt_file="$tools_dir/modules/${parent}/${feature}_database.dbt"
        else
        	dbt_file="$tools_dir/dev/dbt/${parent}/${feature}_database.dbt"
        fi

	# Create the parent directory if it doesn't exist
	mkdir -p "$(dirname "$dbt_file")"


# Create the .conf file with the defined variables
cat << EOF > "$dbt_file"
[menu]
id="$id"
feature="$feature"
parent="$parent"
group="$group"
maintainer="$maintainer"

[checks]
status="$status"
port="$port"
arch="$arch"


[messages]
example="$example"
description="$desc"

[markdown]
title="$id - $feature"
author="$author"
header="""
$header
"""
image=""
footer="""
$footer
"""
doc_link="$doc_link"

EOF


}


module_helper+=(
	["gen_test_conf,maintainer"]="@Tearran"
	["gen_test_conf,feature"]="gen_test_conf"
	["gen_test_conf,example"]=""
	["gen_test_conf,desc"]="Helper for module_api"
	["gen_test_conf,status"]="Active"
	["gen_test_conf,condition"]=""
	["gen_test_conf,doc_link"]=""
	["gen_test_conf,author"]="@Tearran"
	["gen_test_conf,parent"]="docs"
	["gen_test_conf,group"]="Docs"
	["gen_test_conf,port"]=""
	["gen_test_conf,arch"]=""
)
#
gen_test_conf(){
        if [ "$group" != "unknown" ] && [ -n "$id" ]; then
        	conf_file="$tools_dir/dev/test/${id}.conf"
        fi

	# Create the parent directory if it doesn't exist
	mkdir -p "$(dirname "$conf_file")"

	local commands
	IFS=' ' read -r -a commands <<< "${module_options["$feature,example"]}"

	if [[ $parent == "software" ]]; then
		if [[ " ${commands[@]} " =~ " help " && " ${commands[@]} " =~ " status " ]]; then
			{
			echo "ENABLED=true"
			echo "RELEASE=\"$arch\""
			echo ""
			echo "function testcase(){"

			for i in "${!commands[@]}"; do

				echo "	armbian-config --api $feature ${commands[$i]}"
				echo "	[ -z \$(armbian-config --api $feature help | grep ${commands[$i]}) ]"
				echo ""

			done

			echo "}"

        		} > "$conf_file"
		fi

	fi

}


module_options+=(
	["module_api_files,maintainer"]="@Tearran"
	["module_api_files,feature"]="module_api_files"
	["module_api_files,example"]="help array json dbt test all"
	["module_api_files,desc"]="Example module unattended interface."
	["module_api_files,status"]="Active"
	["module_api_files,condition"]=""
	["module_api_files,doc_link"]=""
	["module_api_files,author"]="@Tearran"
	["module_api_files,parent"]="docs"
	["module_api_files,group"]="Docs"
	["module_api_files,port"]=""
	["module_api_files,arch"]=""
)

	# Function to handle the module commands for 'module_api_files'
	function module_api_files() {

	# Convert the example string to an array
	local commands
	IFS=' ' read -r -a commands <<< "${module_options["module_api_files,example"]}"

	# Handle the command passed to the function
	case "$1" in
		"${commands[0]}")
		echo -e "\nUsage: ${module_options["module_api_files,feature"]} <command>"
		echo -e "Commands:  ${module_options["module_api_files,example"]}"
		echo "Available commands:"
		echo -e "\tarray\t- Generate Data array API."
		echo -e "\tjson\t- Generate JSON from API."
		echo -e "\tdbt\t- Generate DBT from API."
		echo -e "\ttest\t- Generate test CONF from API."
		echo -e "\tall\t- Generate tAll above."
		echo
		;;
		"${commands[1]}")
		geneate_files_api "gen_api_array"
		;;
		"${commands[2]}")
		geneate_files_api "gen_api_json"
		;;
		"${commands[3]}")
		geneate_files_api "gen_api_dbt"
		;;
		"${commands[4]}")
		geneate_files_api "gen_test_conf"
		;;
		"all")
		geneate_files_api "gen_api_array"
		geneate_files_api "gen_api_json"
		geneate_files_api "gen_api_dbt"
		geneate_files_api "gen_test_conf"
		;;
		*)
		echo "${module_options["module_api_files,example"]}"
		;;
	esac
	}

# Uncomment to test the module
# module_api_files "$1"
