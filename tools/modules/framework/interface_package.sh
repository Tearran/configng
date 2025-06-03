# package.sh

# internal function
_pkg_have_stdin() { [[ -t 0 ]]; }

framework_options+=(
	["pkg_configure,author"]="@dimitry-ishenko"
	["pkg_configure,desc"]="Configure an unconfigured package"
	["pkg_configure,example"]="pkg_configure"
	["pkg_configure,feature"]="pkg_configure"
	["pkg_configure,group"]="Interface"
)

pkg_configure()
{
	_pkg_have_stdin && debconf-apt-progress -- dpkg --configure "$@" || dpkg --configure "$@"
}

framework_options+=(
	["pkg_full_upgrade,author"]="@dimitry-ishenko"
	["pkg_full_upgrade,desc"]="Upgrade installed packages (potentially removing some)"
	["pkg_full_upgrade,example"]=""
	["pkg_full_upgrade,feature"]="pkg_full_upgrade"
	["pkg_full_upgrade,group"]="Interface"
)

pkg_full_upgrade()
{
	_pkg_have_stdin && debconf-apt-progress -- apt-get -y full-upgrade "$@" || apt-get -y full-upgrade "$@"
}

framework_options+=(
	["pkg_install,author"]="@dimitry-ishenko"
	["pkg_install,desc"]="Install package"
	["pkg_install,example"]="<apt packeage name>"
	["pkg_install,feature"]="pkg_install"
	["pkg_install,group"]="Interface"
)

pkg_install()
{
	_pkg_have_stdin && debconf-apt-progress -- apt-get -y install "$@" || apt-get -y install "$@"
}

framework_options+=(
	["pkg_installed,author"]="@dimitry-ishenko"
	["pkg_installed,desc"]="Check if package is installed"
	["pkg_installed,example"]="<apt packeage name>"
	["pkg_installed,feature"]="pkg_installed"
	["pkg_installed,group"]="Interface"
)

pkg_installed()
{
	local status=$(dpkg -s "$1" 2>/dev/null | sed -n "s/Status: //p")
	! [[ -z "$status" || "$status" = *deinstall* || "$status" = *not-installed* ]]
}

framework_options+=(
	["pkg_remove,author"]="@dimitry-ishenko"
	["pkg_remove,desc"]="Remove package"
	["pkg_remove,example"]="<apt packeage name>"
	["pkg_remove,feature"]="pkg_remove"
	["pkg_remove,group"]="Interface"
)

pkg_remove()
{
	_pkg_have_stdin && debconf-apt-progress -- apt-get -y autopurge "$@" || apt-get -y autopurge "$@"
}

framework_options+=(
	["pkg_update,author"]="@dimitry-ishenko"
	["pkg_update,desc"]="Update package repository"
	["pkg_update,example"]=""
	["pkg_update,feature"]="pkg_update"
	["pkg_update,group"]="Interface"
)

pkg_update()
{
	_pkg_have_stdin && debconf-apt-progress -- apt-get -y update || apt-get -y update
}

framework_options+=(
	["pkg_upgrade,author"]="@dimitry-ishenko"
	["pkg_upgrade,desc"]="Upgrade installed packages"
	["pkg_upgrade,example"]=""
	["pkg_upgrade,feature"]="pkg_upgrade"
	["pkg_upgrade,group"]="Interface"
)

pkg_upgrade()
{
	_pkg_have_stdin && debconf-apt-progress -- apt-get -y upgrade "$@" || apt-get -y upgrade "$@"
}

framework_options+=(
	["is_package_manager_running,author"]="@armbian"
	["is_package_manager_running,ref_link"]=""
	["is_package_manager_running,feature"]="is_package_manager_running"
	["is_package_manager_running,desc"]="Migrated procedures from Armbian config."
	["is_package_manager_running,example"]=""
	["is_package_manager_running,group"]="Interface"
)
#
# check if package manager is doing something
#
function is_package_manager_running() {

	if ps -C apt-get,apt,dpkg > /dev/null; then
		[[ -z $scripted ]] && echo -e "\nPackage manager is running in the background.\n\nCan't install dependencies. Try again later." | show_infobox
		return 0
	else
		return 1
	fi

}

framework_options+=(
	["see_current_apt,author"]="@Tearran"
	["see_current_apt,ref_link"]=""
	["see_current_apt,feature"]="see_current_apt"
	["see_current_apt,desc"]="Check when apt list was last updated and suggest updating or update"
	["see_current_apt,example"]="update"
	["see_current_apt,doc_link"]=""
	["see_current_apt,group"]="Interface"
)
#
# Function to check when the package list was last updated
#
see_current_apt() {
	# Number of seconds in a day
	local update_apt="$1"
	local day=86400
	local ten_minutes=600
	# Get the current date as a Unix timestamp
	local now=$(date +%s)

	# Get the timestamp of the most recently updated file in /var/lib/apt/lists/
	local update=$(stat -c %Y /var/lib/apt/lists/* 2>/dev/null | sort -n | tail -1)

	# Check if the update timestamp was found
	if [[ -z "$update" ]]; then
		echo "No package lists found."
		return 1 # No package lists exist
	fi

	# Calculate the number of seconds since the last update
	local elapsed=$((now - update))

	# Check if any apt-related processes are running
	if ps -C apt-get,apt,dpkg > /dev/null; then
		echo "A package manager is currently running."
		export running_pkg="true"
		return 1 # The processes are running
	else
		export running_pkg="false"
	fi

	# Check if the package list is up-to-date
	if ((elapsed < ten_minutes)); then
		[[ "$update_apt" != "update" ]] && echo "The package lists are up-to-date."
		return 0 # The package lists are up-to-date
	else
		[[ "$update_apt" != "update" ]] && echo "Update the package lists." # Suggest updating
		[[ "$update_apt" == "update" ]] && pkg_update
		return 0 # The package lists are not up-to-date
	fi
}
