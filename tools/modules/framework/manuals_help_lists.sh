
module_options+=(
	["_module_list,author"]="@Tearran"
	["_module_list,ref_link"]=""
	["_module_list,feature"]="_module_list"
	["_module_list,desc"]="Show the usage of the functions."
	["_module_list,example"]=""
	["_module_list,status"]=""
	["_module_list,doc_link"]=""
)
#
# Function to parse the key-pairs  (WIP)
#
function _module_list() {
	mod_message="Usage: ${0} [module_name] [options]\n\n"
	# Iterate over the options
	for key in "${!module_options[@]}"; do
		# Split the key into function_name and type
		IFS=',' read -r function_name type <<< "$key"

		if [[ "$type" == "feature" ]]; then
			example="${module_options["$function_name,example"]}"
			mod_message+="  ${module_options["$function_name,desc"]}\n\t${module_options["$function_name,feature"]} $example\n\n"
		fi

	done

	echo -e "$mod_message"
}


module_options+=(
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