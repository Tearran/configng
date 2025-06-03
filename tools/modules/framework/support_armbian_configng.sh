framework_options+=(
["support_armbian_configng,author"]="@igorpecovnik"
["support_armbian_configng,feature"]="support_armbian_configng"
["support_armbian_configng,desc"]="Show general information about this tool"
["support_armbian_configng,options"]="support_armbian_configng"
["support_armbian_configng,group"]="Message"
)
#
# @description Show general information about this tool
# Prints general information and support links for Armbian Config: The Next Generation.
#
# Outputs:
#
# * A brief introduction to Armbian Config: The Next Generation.
# * URLs for proposing new features, reporting bugs, and supporting developers.
#
# Example:
#
# ```bash
# support_armbian_configng
# ```
# This will print informational text and relevant URLs to standard output.
function support_armbian_configng() {

	echo "Armbian Config: The Next Generation"
	echo ""
	echo "How to make this tool even better?"
	echo ""
	echo "- propose new features or software titles"
	echo "  https://github.com/armbian/configng/issues/new?template=feature-reqests.yml"
	echo ""
	echo "- report bugs"
	echo "  https://github.com/armbian/configng/issues/new?template=bug-reports.yml"
	echo ""
	echo "- support developers with a small donation"
	echo "  https://github.com/sponsors/armbian"
	echo ""

}
