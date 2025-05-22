framework_options+=(
	["merge_arrays_into_module_options,author"]="@tearran"
	["merge_arrays_into_module_options,maintainer"]="@igorpecovnik"
	["merge_arrays_into_module_options,feature"]="merge_arrays_into_module_options"
	["merge_arrays_into_module_options,example"]="module_options module_name"
	["merge_arrays_into_module_options,desc"]="Merges compatible associative arrays into module_options for unified access."
	["merge_arrays_into_module_options,status"]=""
	["merge_arrays_into_module_options,doc_link"]=""
	["merge_arrays_into_module_options,group"]="data"
	["merge_arrays_into_module_options,arch"]=""
)


merge_arrays_into_module_options() {
    for array_name in "$@"; do
        eval "for key in \"\${!$array_name[@]}\"; do
            module_options[\"\$key\"]=\"\${$array_name[\"\$key\"]}\"
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
	["options_list,group"]="data"
	["options_list,arch"]="all"
)

function options_list() {
    local array_name="$1"
    local usage="$2"
    local -n options_array="$array_name"  # Bash 4.3+ nameref
    local mod_message="Usage: ${0} [$usage] [options]\n\n"
    for key in "${!options_array[@]}"; do
        IFS=',' read -r function_name type <<< "$key"
        if [[ "$type" == "feature" ]]; then
            example="${options_array["$function_name,example"]}"
            mod_message+="  ${options_array["$function_name,desc"]}\n\t${options_array["$function_name,feature"]} $example\n\n"
        fi
    done
    echo -e "$mod_message"
}
# Usage:
# options_list framework_options framework_name
