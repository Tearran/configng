framework_options+=(
	["merge_arrays_into_module_options,author"]="@tearran"
	["merge_arrays_into_module_options,maintainer"]="@igorpecovnik"
	["merge_arrays_into_module_options,feature"]="merge_arrays_into_module_options"
	["merge_arrays_into_module_options,options"]="<options_name>"
	["merge_arrays_into_module_options,desc"]="Merges compatible associative arrays into framework_options for unified access."
	["merge_arrays_into_module_options,doc_link"]=""
	["merge_arrays_into_module_options,group"]="Interface"
	["merge_arrays_into_module_options,arch"]=""
)

# Merges key-value pairs from one or more associative arrays into the global module_options array using eval.
#
# Arguments:
#
# * Names of associative arrays to merge into module_options.
#
# Globals:
#
# * module_options: The global associative array that receives merged key-value pairs.
#
# Example:
#
# ```bash
# declare -A arr1=(["foo"]=1 ["bar"]=2)
# declare -A arr2=(["baz"]=3)
# merge_arrays_into_module_options_old arr1 arr2
# # module_options now contains foo=1, bar=2, baz=3
# ```
merge_arrays_into_module_options_old() {
	for array_name in "$@"; do
		eval "for key in \"\${!$array_name[@]}\"; do
			module_options[\"\$key\"]=\"\${$array_name[\"\$key\"]}\"
		done"
	done
}

# Merges key-value pairs from one or more associative arrays into the global module_options array.
#
# Arguments:
#
# * Names of associative arrays to merge into module_options.
#
# Globals:
#
# * module_options: Receives merged key-value pairs from the specified arrays.
#
# Example:
#
# ```bash
# declare -A arr1=(["foo"]=1 ["bar"]=2)
# declare -A arr2=(["baz"]=3)
# declare -A module_options=()
# merge_arrays_into_module_options arr1 arr2
# # module_options now contains: foo=1, bar=2, baz=3
# ```
function merge_arrays_into_module_options() {
	for array_name in "$@"; do
		local -n src="$array_name"
		for key in "${!src[@]}"; do
			module_options["$key"]="${src[$key]}"
		done
	done
}

framework_options+=(
	["options_list,author"]="@tearran"
	["options_list,maintainer"]="@igorpecovnik"
	["options_list,feature"]="options_list"
	["options_list,options"]="<options_array_name>"
	["options_list,desc"]="Displays a usage/help message listing all features in the specified options array, including their names, descriptions, and usage."
	["options_list,doc_link"]="https://github.com/armbian/configng#options_list"
	["options_list,group"]="Interface"
	["options_list,arch"]="all"
)

# Prints a formatted usage and options list for features defined in an associative array.
#
# Arguments:
#
# * Name of an associative array containing feature metadata.
# * Usage string to display in the usage line.
#
# Outputs:
#
# * Prints a usage/help message to standard output, listing each feature's description and example usage.
#
# Example:
#
# ```bash
# options_list my_options_array "command [args]"
# ```
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
		example="${options_array["$fn_name,options"]}"
		mod_message+="$i. ${options_array["$fn_name,desc"]}\n\t${options_array["$fn_name,feature"]} $example\n\n"
		((i++))
	fi
	done
	echo -e "$mod_message"
}
# options_list framework_options
