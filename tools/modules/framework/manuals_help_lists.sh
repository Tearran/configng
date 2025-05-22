framework_options+=(
	["generate_json_options,author"]="@Tearran"
	["generate_json_options,ref_link"]=""
	["generate_json_options,feature"]="generate_json"
	["generate_json_options,desc"]="Generate JSON-like object file."
	["generate_json_options,example"]=""
	["generate_json_options,status"]=""
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

