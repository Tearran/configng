framework_options+=(
	["sanitize,author"]="@Tearran"
	["sanitize,desc"]="Make sure param contains only valid chars"
	["sanitize,options"]="<module_name>"
	["sanitize,feature"]="sanitize"
	["sanitize,group"]="Initialize"
)

# Validates that the input contains only alphanumeric characters, underscores, or equal signs.
#
# Arguments:
#
# * Input string to validate.
#
# Outputs:
#
# * Echoes the input string if valid.
# * Calls `die` with an error message and exits if invalid.
#
# Example:
#
# ```bash
# sanitize "foo_bar=123"   # outputs: foo_bar=123
# sanitize "bad!input"     # exits with error: Invalid argument: bad!input
# ```
sanitize() {
	[[ "$1" =~ ^[a-zA-Z0-9_=]+$ ]] && echo "$1" || die "Invalid argument: $1"
}

framework_options+=(
	["die,author"]="@dimitry-ishenko"
	["die,desc"]="Exit with error code 1, optionally printing a message to stderr"
	["die,options"]="'The world is about to end'"
	["die,feature"]="die"
	["die,group"]="Initialize"
)

# Exits the script with status code 1, optionally printing an error message to standard error.
#
# Arguments:
#
# * Error message (optional)
#
# Outputs:
#
# * Prints the provided error message to STDERR if given.
#
# Returns:
#
# * Exits with status code 1.
#
# Example:
#
# ```bash
# die "Invalid input detected"
# ```
die() {
	(( $# )) && echo "$@" >&2
	exit 1
}
