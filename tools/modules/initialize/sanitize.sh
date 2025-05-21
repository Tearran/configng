module_options+=(
	["sanitize,author"]="@Tearran"
	["sanitize,desc"]="Make sure param contains only valid chars"
	["sanitize,example"]="<module_name>"
	["sanitize,feature"]="sanitize"
	["sanitize,status"]="Interface"
)

sanitize() {
	[[ "$1" =~ ^[a-zA-Z0-9_=]+$ ]] && echo "$1" || die "Invalid argument: $1"
}

module_options+=(
	["die,author"]="@dimitry-ishenko"
	["die,desc"]="Exit with error code 1, optionally printing a message to stderr"
	["die,example"]="'The world is about to end'"
	["die,feature"]="die"
	["die,status"]="Interface"
)

die() {
	(( $# )) && echo "$@" >&2
	exit 1
}
