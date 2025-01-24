# Function to convert JSON object to .dbt files

function geneate_files_api() {
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
			Messages|Readme)
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

		gen_api_array
		gen_test_conf
		#gen_api_dbt
		get_api_json


	done

        chown -R "${SUDO_USER:-$USER}":"${SUDO_USER:-$USER}" "$tools_dir"
}


gen_api_array(){
		# Determine the file path based on group
	if [ "$group" != "unknown" ]; then
		module_options_file="$tools_dir/modules/${parent}/${feature}_array"
	#else
		#module_options_file="$tools_dir/dev/array/${feature}_array.sh"
	fi

        # Create the parent directory if it doesn't exist
        mkdir -p "$(dirname "$module_options_file")"

	[[ $parent == "software" ]] && cat << EOF | tee -a "$module_options_file" >> "$tools_dir/dev/array/module_options.sh"
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


get_api_json(){

	if [ "$group" != "unknown" ]; then
		json_opjects="$tools_dir/dev/json/${parent}/${feature}.json"
	else
		json_opjects="$tools_dir/dev/json/${parent}/${feature}.json"
	fi

	# Create the parent directory if it doesn't exist
	mkdir -p "$(dirname "$json_opjects")"

	cat << EOF > "$json_opjects"
{
	"id_count": "$id",
	"maintainer": "$maintainer",
	"feature": "$feature",
	"desc": "$desc",
	"example": "$example",
	"status": "$status",
	"condition": "",
	"doc_link": "$doc_link",
	"author": "$author",
	"parent": "$parent",
	"group": "$group",
	"port": "$port",
	"arch": "$arch"
}
EOF

}


gen_api_dbt(){
        if [ "$group" != "unknown" ]; then
        	dbt_file="$tools_dir/dev/dbt/${parent}/${feature}.dbt"
        else
        	dbt_file="$tools_dir/dev/dbt/${parent}/${feature}.dbt"
        fi

	# Create the parent directory if it doesn't exist
	mkdir -p "$(dirname "$dbt_file")"


# Create the .conf file with the defined variables
cat << EOF > "$dbt_file"
[main]
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


