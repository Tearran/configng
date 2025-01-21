# Function to convert JSON object to .dbt files
set_api_dbt() {
    local i=0

    features=()
    for key in "${!module_options[@]}"; do
        if [[ $key == *",feature" ]]; then
            features+=("${module_options[$key]}")
        fi
    done

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

        # Generate group prefix
        if [ -n "$group" ]; then
            group_prefix=$(echo "${group:0:3}" | tr '[:lower:]' '[:upper:]')
        else
            group_prefix=$(echo "ukn" | tr '[:lower:]' '[:upper:]')
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
            commands="none"
        else
            commands="$example"
        fi

        # Use group_prefix for id
        id=$(printf "%s%03d" "$group_prefix" "$i")

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

dbt_file="$tools_dir/dev/${parent}/${feature}.dbt"

# Create the parent directory if it doesn't exist
mkdir -p "$(dirname "$dbt_file")"

        {
            echo "[$feature]"
            echo "parent=$parent"
            echo "group=$group"
            echo "feature=$feature"
            echo "id_count=$id"
            echo "maintainer=$maintainer"
            echo "author=$author"
            echo "feature=$feature"
            echo "description=$desc"
            echo "example=$example"
            echo "status=$status"
            echo "reference=$doc_link"
            echo "options=$commands"
            echo "port=$port"
            echo "arch=$arch"
        } > "$dbt_file"
    done

}


function see_api_json() {
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

        # Generate group prefix
        if [ -n "$group" ]; then
            group_prefix=$(echo "${group:0:3}" | tr '[:lower:]' '[:upper:]')
	else
	    group_prefix=$(echo "ukn" | tr '[:lower:]' '[:upper:]')
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
            commands="none"
	else
	    commands="$example"
        fi

        # Use group_prefix for id
        id=$(printf "%s%03d" "$group_prefix" "$i")
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

        echo "  {"
        echo "    \"id_count\": \"$id\","
	echo "    \"maintainer\": \"$maintainer\","
        echo "    \"feature\": \"$feature\","
        echo "    \"description\": \"$desc\","
        echo "    \"example\": \"$example\","
        echo "    \"status\": \"$status\","
        echo "    \"condition\": \"\","
        echo "    \"reference\": \"$doc_link\","
        echo "    \"author\": \"$author\","
        echo "    \"parent\": \"$parent\","
        echo "    \"group\": \"$group\","
        echo "    \"options\": \"$example\","
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


function set_api_json() {
    local i=0

    features=()
    for key in "${!module_options[@]}"; do
        if [[ $key == *",feature" ]]; then
            features+=("${module_options[$key]}")
        fi
    done

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

        # Generate group prefix
        if [ -n "$group" ]; then
            group_prefix=$(echo "${group:0:3}" | tr '[:lower:]' '[:upper:]')
	else
	    group_prefix=$(echo "ukn" | tr '[:lower:]' '[:upper:]')
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
            commands="none"
	else
	    commands="$example"
        fi

        # Use group_prefix for id
        id=$(printf "%s%03d" "$group_prefix" "$i")
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

json_opjects="$tools_dir/dev/${parent}/${feature}.json"

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
        echo "    \"reference\": \"$doc_link\","
        echo "    \"author\": \"$author\","
        echo "    \"parent\": \"$parent\","
        echo "    \"group\": \"$group\","
        echo "    \"options\": \"$example\","
        echo "    \"port\": \"$port\","
        echo "    \"arch\": \"$arch\""
            echo "  }"
}  > "$json_opjects"
    done

}



function see_module_options() {
	local i=0

	features=()
	for key in "${!module_options[@]}"; do
		if [[ $key == *",feature" ]]; then
		features+=("${module_options[$key]}")
		fi
	done

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
		commands="none"
		else
		commands="$example"
		fi

		# Use group_prefix for id
		id=$(printf "%s%03d" "$group_prefix" "$i")
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

		module_options_file="$tools_dir/dev/${parent}/${feature}_array.sh"
	{
		echo "module_options+=("
		echo "    \"[$feature,id_count]\"=\"$id\","
		echo "    \"[$feature,maintainer]\"=\"$maintainer\","
		echo "    \"[$feature,feature]\"=\"$feature\","
		echo "    \"[$feature,description]\"=\"$desc\","
		echo "    \"[$feature,example]\"=\"$example\","
		echo "    \"[$feature,status]\"=\"$status\","
		echo "    \"[$feature,condition]\"=\"\","
		echo "    \"[$feature,reference]\"=\"$doc_link\","
		echo "    \"[$feature,author]\"=\"$author\","
		echo "    \"[$feature,parent]\"=\"$parent\","
		echo "    \"[$feature,group]\"=\"$group\","
		echo "    \"[$feature,options]\"=\"$example\","
		echo "    \"[$feature,port]\"=\"$port\","
		echo "    \"[$feature,arch\"=\"$arch\""
		echo ")"
		echo ""
	} > "$module_options_file"

	done

}
# Call the function to see the output

function set_api_files() {
	see_api_json > "$tools_dir/dev/module_option.json"
	set_api_json
	see_module_options
	set_api_dbt
}

function see_api_message() {
    # Initialize the usage message
    mod_message="Usage: \n\n"

    # Append the formatted JSON data to the usage message
    mod_message+=$(set_api_json | jq -r '
        group_by(.group) | sort_by(.[0].group == "Unknown")[] |
        .[0].group as $group |
        "\($group) (\(.[0].parent)):\n" +
        (map(select(.feature != null and .status == "Active" and .options != "")) |
         map("  --api \(.feature) - \(.description)\n" +
             (if .options != null then "\t  \(.options)\n\n" else "" end)
         ) | join(""))
    ')

    # Print the final usage message
    echo -e "$mod_message"
}
