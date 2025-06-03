framework_options+=(
	["merge_arrays_into_framework_options,author"]="@tearran"
	["merge_arrays_into_framework_options,maintainer"]="@igorpecovnik"
	["merge_arrays_into_framework_options,feature"]="merge_arrays_into_framework_options"
	["merge_arrays_into_framework_options,example"]="<options_name>"
	["merge_arrays_into_framework_options,desc"]="Merges compatible associative arrays into framework_options for unified access."
	["merge_arrays_into_framework_options,doc_link"]=""
	["merge_arrays_into_framework_options,group"]="Interface"
	["merge_arrays_into_framework_options,arch"]=""
)


merge_arrays_into_framework_options() {
	for array_name in "$@"; do
		eval "for key in \"\${!$array_name[@]}\"; do
			framework_options[\"\$key\"]=\"\${$array_name[\"\$key\"]}\"
		done"
	done
}

framework_options+=(
	["options_list,author"]="@tearran"
	["options_list,maintainer"]="@igorpecovnik"
	["options_list,feature"]="options_list"
	["options_list,example"]="<options_array_name>"
	["options_list,desc"]="Displays a usage/help message listing all features in the specified options array, including their names, descriptions, and usage."
	["options_list,status"]="stable"
	["options_list,doc_link"]="https://github.com/armbian/configng#options_list"
	["options_list,group"]="Interface"
	["options_list,arch"]="all"
)

function options_list() {
	local array_name="$1"
	local usage="$2"
	local -n options_array="$array_name"  # Bash 4.3+ nameref
	local mod_message="Usage: ${0} [$usage] [options]\n\n"
	i=1

	for function_name in "${!options_array[@]}"; do
	# Parse out the function name if your keys are like "foo,desc"
	[[ "$function_name" =~ ^([^,]+),feature$ ]] || continue
	fn_name="${BASH_REMATCH[1]}"
	type="feature" # or get from your array if stored
	if [[ "$type" == "feature" ]]; then
		example="${options_array["$fn_name,example"]}"
		mod_message+="$i. ${options_array["$fn_name,desc"]}\n\t${options_array["$fn_name,feature"]} $example\n\n"
		((i++))
	fi
	done
	echo -e "$mod_message"
}
# options_list framework_options
