
module_options+=(
	["_api_list,author"]="@Tearran"
	["_api_list,ref_link"]=""
	["_api_list,feature"]="_api_list"
	["_api_list,desc"]="Show the usage of the functions."
	["_api_list,example"]=""
	["_api_list,status"]=""
	["_api_list,doc_link"]=""
)
#
# Function to parse the key-pairs  (WIP)
#
function _api_list() {
	mod_message="Usage: ${0} --api [module] [options]\n\n"
	# Iterate over the options
	for key in "${!module_options[@]}"; do
		# Split the key into function_name and type
		IFS=',' read -r function_name type <<< "$key"

		if [[ "$type" == "feature" ]]; then
			mod_message+="--api ${module_options["$function_name,feature"]} - ${module_options["$function_name,desc"]}\n"

			example="${module_options["$function_name,example"]}"
			if [[ -z "$example" || "$example" == "none" || "$example" == "${module_options["$function_name,feature"]}" ]]; then
				mod_message+="\t[options] - None\n\n"
			else
				mod_message+="\t[options] - $example\n\n"
			fi
		fi

	done

	echo -e "$mod_message"
}