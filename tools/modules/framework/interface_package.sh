# package.sh

# Checks if the script's standard input is a terminal.
#
# Returns:
#
# * 0 (success) if standard input is a terminal, 1 (failure) otherwise.
_pkg_have_stdin() { [[ -t 0 ]]; }

framework_options+=(
	["pkg_configure,author"]="@dimitry-ishenko"
	["pkg_configure,desc"]="Configure an unconfigured package"
	["pkg_configure,options"]="pkg_configure"
	["pkg_configure,feature"]="pkg_configure"
	["pkg_configure,group"]="Interface"
)

# Configures unpacked but unconfigured packages using dpkg.
#
# Arguments:
#
# * Any arguments to pass to `dpkg --configure` (typically package names or `-a` for all).
#
# Outputs:
#
# * Progress information to STDOUT if running in a terminal.
#
# Example:
#
# ```bash
# pkg_configure -a
# pkg_configure mypackage
# ```
pkg_configure()
{
	_pkg_have_stdin && debconf-apt-progress -- dpkg --configure "$@" || dpkg --configure "$@"
}

framework_options+=(
	["pkg_full_upgrade,author"]="@dimitry-ishenko"
	["pkg_full_upgrade,desc"]="Upgrade installed packages (potentially removing some)"
	["pkg_full_upgrade,options"]=""
	["pkg_full_upgrade,feature"]="pkg_full_upgrade"
	["pkg_full_upgrade,group"]="Interface"
)

# Performs a full system upgrade, installing the newest versions of all packages and removing obsolete ones if necessary.
#
# Arguments:
#
# * Additional options or package names to pass to `apt-get full-upgrade`.
#
# Returns:
#
# * The exit status of the `apt-get full-upgrade` command.
#
# Example:
#
# ```bash
# pkg_full_upgrade
# pkg_full_upgrade --with-new-pkgs
# ```
pkg_full_upgrade()
{
	_pkg_have_stdin && debconf-apt-progress -- apt-get -y full-upgrade "$@" || apt-get -y full-upgrade "$@"
}

framework_options+=(
	["pkg_install,author"]="@dimitry-ishenko"
	["pkg_install,desc"]="Install package"
	["pkg_install,options"]="<apt packeage name>"
	["pkg_install,feature"]="pkg_install"
	["pkg_install,group"]="Interface"
)

# Installs one or more packages using apt-get, displaying progress if run interactively.
#
# Arguments:
#
# * Names of packages to install.
#
# Outputs:
#
# * Installs the specified packages, printing progress to the terminal if standard input is a terminal.
#
# Example:
#
# ```bash
# pkg_install curl git
# ```
pkg_install()
{
	_pkg_have_stdin && debconf-apt-progress -- apt-get -y install "$@" || apt-get -y install "$@"
}

framework_options+=(
	["pkg_installed,author"]="@dimitry-ishenko"
	["pkg_installed,desc"]="Check if package is installed"
	["pkg_installed,options"]="<apt package name>"
	["pkg_installed,feature"]="pkg_installed"
	["pkg_installed,group"]="Interface"
)

# Checks if a specified package is currently installed on the system.
#
# Arguments:
#
# * Package name to check.
#
# Returns:
#
# * 0 (success) if the package is installed and not marked as deinstalled or not-installed.
# * 1 (failure) otherwise.
#
# Example:
#
# ```bash
# pkg_installed bash && echo "Bash is installed"
# ```
pkg_installed()
{
	local status=$(dpkg -s "$1" 2>/dev/null | sed -n "s/Status: //p")
	! [[ -z "$status" || "$status" = *deinstall* || "$status" = *not-installed* ]]
}

framework_options+=(
	["pkg_remove,author"]="@dimitry-ishenko"
	["pkg_remove,desc"]="Remove package"
	["pkg_remove,options"]="<apt package name>"
	["pkg_remove,feature"]="pkg_remove"
	["pkg_remove,group"]="Interface"
)

# Removes specified packages and their dependencies, purging configuration files.
#
# Arguments:
#
# * Names of packages to remove.
#
# Example:
#
# ```bash
# pkg_remove nginx
# pkg_remove package1 package2
# ```
pkg_remove()
{
	_pkg_have_stdin && debconf-apt-progress -- apt-get -y remove --auto-remove --purge "$@" \
	|| apt-get -y remove --auto-remove --purge "$@"
}

framework_options+=(
	["pkg_update,author"]="@dimitry-ishenko"
	["pkg_update,desc"]="Update package repository"
	["pkg_update,options"]=""
	["pkg_update,feature"]="pkg_update"
	["pkg_update,group"]="Interface"
)

# Updates the package repository information using apt-get.
#
# If standard input is a terminal, displays progress using debconf-apt-progress.
#
# Outputs:
#
# * Progress and results of the repository update to STDOUT and STDERR.
#
# Example:
#
# ```bash
# pkg_update
# ```
pkg_update()
{
	_pkg_have_stdin && debconf-apt-progress -- apt-get -y update || apt-get -y update
}

framework_options+=(
	["pkg_upgrade,author"]="@dimitry-ishenko"
	["pkg_upgrade,desc"]="Upgrade installed packages"
	["pkg_upgrade,options"]=""
	["pkg_upgrade,feature"]="pkg_upgrade"
	["pkg_upgrade,group"]="Interface"
)

# Upgrades all installed packages to the latest available versions.
#
# If standard input is a terminal, displays progress using debconf-apt-progress.
#
# Arguments:
#
# * Additional options or package names to pass to apt-get upgrade.
#
# Example:
#
# ```bash
# pkg_upgrade
# pkg_upgrade --with-new-pkgs
# ```
pkg_upgrade()
{
	_pkg_have_stdin && debconf-apt-progress -- apt-get -y upgrade "$@" || apt-get -y upgrade "$@"
}

framework_options+=(
	["is_package_manager_running,author"]="@armbian"
	["is_package_manager_running,ref_link"]=""
	["is_package_manager_running,feature"]="is_package_manager_running"
	["is_package_manager_running,desc"]="Migrated procedures from Armbian config."
	["is_package_manager_running,options"]=""
	["is_package_manager_running,group"]="Interface"
)
#
# check if package manager is doing something
# Checks if a package manager process (apt-get, apt, or dpkg) is currently running.
#
# If a package manager is active and not in scripted mode, displays an informational message.
#
# Returns:
#
# * 0 if a package manager process is running.
# * 1 if no package manager process is running.
#
# Example:
#
# ```bash
# if is_package_manager_running; then
#     echo "Please wait for the package manager to finish."
# fi
# ```
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
	["see_current_apt,options"]="update"
	["see_current_apt,doc_link"]=""
	["see_current_apt,group"]="Interface"
)
#
# Function to check when the package list was last updated
# Checks the freshness of the apt package lists and optionally updates them.
#
# Arguments:
#
# * update_apt: If set to "update", the function will update the package lists if they are outdated; otherwise, it only checks their freshness.
#
# Outputs:
#
# * Prints messages indicating whether the package lists are up-to-date, missing, or if a package manager is currently running.
#
# Returns:
#
# * 0 if the package lists are present and either up-to-date or have been updated.
# * 1 if no package lists are found or if a package manager process is running.
#
# Globals:
#
# * Sets the environment variable `running_pkg` to "true" if a package manager is running, "false" otherwise.
#
# Example:
#
# ```bash
# see_current_apt           # Checks if the package lists are fresh
# see_current_apt update    # Checks and updates the package lists if needed
# ```
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
