framework_options+=(
	["generate_json,author"]="@Tearran"
	["generate_json,ref_link"]=""
	["generate_json,feature"]="generate_json"
	["generate_json,desc"]="Generate JSON-like object file."
	["generate_json,options"]=""
	["generate_json,group"]="Docs"

)

#
# Function to generate a JSON-like object file
#
function generate_json() {
	echo -e "{\n\"configng-helpers\" : ["
	features=()
	for key in "${!framework_options[@]}"; do
		if [[ $key == *",feature" ]]; then
			features+=("${framework_options[$key]}")
		fi
	done

	for index in "${!features[@]}"; do
		feature=${features[$index]}
		desc_key="${feature},desc"
		example_key="${feature},options"
		author_key="${feature},author"
		ref_key="${feature},ref_link"
		status_key="${feature},status"
		doc_key="${feature},doc_link"
		author="${framework_options[$author_key]}"
		ref_link="${framework_options[$ref_key]}"
		status="${framework_options[$status_key]}"
		doc_link="${framework_options[$doc_key]}"
		desc="${framework_options[$desc_key]}"
		example="${framework_options[$example_key]}"
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

