# Function to convert JSON object to .dbt files

function gen_module_api() {
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
		# Get array info
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

		if [[ -n group ]]; then
			g=$((g + 10)) ;
			group_prefix=$(echo "${group:0:3}" | tr '[:lower:]' '[:upper:]') # Extract first 3 letters and convert to uppercase
			id=$(printf "%s%04d" "$group_prefix" "$g") # Combine prefix with padded number
		else
			id="$feature"
		fi

		if [ -z "$doc_link" ]; then
		doc_link="Missing link"
		fi
		if [ -z "$port" ]; then
		port="unset"
		fi
		if [ -z "$arch" ]; then
		arch="unset"
		fi
		if [ "$example" == "$feature" ]; then
		example=""
		fi

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
		gen_api_dbt
		get_api_json


	done

        chown -R "${SUDO_USER:-$USER}":"${SUDO_USER:-$USER}" "$script_dir"
}

gen_api_array(){
	   # Determine the file path based on group
        if [ "$group" != "unknown" ]; then
            module_options_file="$tools_dir/modules/${parent}/${feature}_array.sh"
        else
            module_options_file="$tools_dir/dev/array/${parent}/${feature}_array.sh"
        fi

        # Create the parent directory if it doesn't exist
        mkdir -p "$(dirname "$module_options_file")"

	{
		echo "module_options+=("
		echo "    [\"$feature,id\"]=\"$id\""
		echo "    [\"$feature,maintainer\"]=\"$maintainer\""
		echo "    [\"$feature,feature\"]=\"$feature\""
		echo "    [\"$feature,description\"]=\"$desc\""
		echo "    [\"$feature,example\"]=\"$example\""
		echo "    [\"$feature,status\"]=\"$status\""
		echo "    [\"$feature,condition\"]=\"\""
		echo "    [\"$feature,doc_link\"]=\"$doc_link\""
		echo "    [\"$feature,author\"]=\"$author\""
		echo "    [\"$feature,parent\"]=\"$parent\""
		echo "    [\"$feature,group\"]=\"$group\""
		echo "    [\"$feature,port\"]=\"$port\""
		echo "    [\"$feature,arch\"]=\"$arch\""
		echo ")"
		echo ""
	} > "$module_options_file"
}


get_api_json(){

        if [ "$group" != "unknown" ]; then
            json_opjects="$tools_dir/dev/json/${parent}/${feature}.json"
        else
            json_opjects="$tools_dir/dev/json/${parent}/${feature}.json"
        fi

	# Create the parent directory if it doesn't exist
	mkdir -p "$(dirname "$json_opjects")"

{
        echo "  {"
        echo "    \"id_count\": \"$id\","
	echo "    \"maintainer\": \"$maintainer\","
        echo "    \"feature\": \"$feature\","
        echo "    \"description\": \"$desc\","
        echo "    \"example\": \"$example\","
        echo "    \"status\": \"$status\","
        echo "    \"condition\": \"\","
        echo "    \"doc_link\": \"$doc_link\","
        echo "    \"author\": \"$author\","
        echo "    \"parent\": \"$parent\","
        echo "    \"group\": \"$group\","
        echo "    \"port\": \"$port\","
        echo "    \"arch\": \"$arch\""
            echo "  }"
}  > "$json_opjects"

}




gen_api_dbt(){
        if [ "$group" != "unknown" ]; then
        	dbt_file="$tools_dir/dev/dbt/${parent}/${feature}.dbt"
        else
        	dbt_file="$tools_dir/dev/dbt/${parent}/${feature}.dbt"
        fi

	# Create the parent directory if it doesn't exist
	mkdir -p "$(dirname "$dbt_file")"

cat << EOF > "$dbt_file"
[$feature]
parent="$parent"
group="$group"
feature="$feature"

id="$id"
maintainer="$maintainer"
author="$author"
feature="$feature"
description="$desc"
example="$example"
status="$status"
doc_link="$doc_link"
port="$port"
arch="$arch"
EOF



}

gen_test_conf(){
        if [ "$group" != "unknown" ] && [ -n "$id" ]; then
        	conf_file="$tools_dir/dev/test/${id}.conf"
        else
        	conf_file="$tools_dir/dev/test/${group}/${feature}.conf"
        fi

	# Create the parent directory if it doesn't exist
	mkdir -p "$(dirname "$conf_file")"

cat << EOF > "$conf_file"

ENABLED=true
RELEASE="$arch"

function testcase(){
	./bin/armbian-config --api $feature install
        [ -n "\$(./bin/armbian-config --api \"$feature\" status)" ]
	./bin/armbian-config --api $feature remove
	[ -z "\$(./bin/armbian-config --api \"$feature\" status)" ]
}

EOF


}


