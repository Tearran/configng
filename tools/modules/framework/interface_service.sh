# service.sh
module_helpers+=(
	["_srv_system_running,desc"]="Internale service interface helper"
	["_srv_system_running,feature"]="_srv_system_running"
	["_srv_system_running,options"]=""
	["_srv_system_running,group"]="Helper"
)
# Checks if the systemd system is in a "running" or "degraded" state.
#
# Returns:
#
# * 0 (success) if the system is running or degraded, 1 (failure) otherwise.
#
# Example:
#
# ```bash
# if _srv_system_running; then
#   echo "Systemd is operational."
# fi
# ```
_srv_system_running() { [[ $(systemctl is-system-running) =~ ^(running|degraded)$ ]]; }

framework_options+=(
	["srv_active,author"]="@dimitry-ishenko"
	["srv_active,desc"]="Check if service is active"
	["srv_active,options"]="<service_name.service>"
	["srv_active,feature"]="srv_active"
	["srv_active,group"]="Interface"
)

# Checks if the specified systemd service is active, but only if the system is running outside a container.
#
# Arguments:
#
# * Service name to check.
#
# Returns:
#
# * 0 if the service is active and the system is running; non-zero otherwise. Returns true without checking if inside a container.
#
# Example:
#
# ```bash
# srv_active nginx.service
# ```
srv_active()
{
	# fail inside container
	_srv_system_running && systemctl is-active --quiet "$@"
}


framework_options+=(
	["srv_daemon_reload,author"]="@dimitry-ishenko"
	["srv_daemon_reload,desc"]="Reload systemd configuration"
	["srv_daemon_reload,options"]=""
	["srv_daemon_reload,feature"]="srv_daemon_reload"
	["srv_daemon_reload,group"]="Interface"
)

# Reloads the systemd manager configuration if the system is running.
#
# This function calls `systemctl daemon-reload` to reload systemd unit files, but only if the system is not running inside a container. If executed inside a container, the function does nothing and returns success.
#
# Outputs:
#
# * Any output from `systemctl daemon-reload` if executed.
#
# Returns:
#
# * 0 if the system is running and the reload succeeds, or if inside a container.
#
# Example:
#
# ```bash
# srv_daemon_reload
# ```
srv_daemon_reload()
{
	# ignore inside container
	_srv_system_running && systemctl daemon-reload || true
}

framework_options+=(
	["srv_disable,author"]="@dimitry-ishenko"
	["srv_disable,desc"]="Disable service"
	["srv_disable,options"]="<name.service>"
	["srv_disable,feature"]="srv_disable"
	["srv_disable,group"]="Interface"
)

# Disables one or more systemd services.
#
# Arguments:
#
# * One or more service unit names (e.g., `nginx.service`)
#
# Returns:
#
# * The exit status of `systemctl disable`
#
# Example:
#
# ```bash
# srv_disable nginx.service
# ```
srv_disable() { systemctl disable "$@"; }

framework_options+=(
	["srv_enable,author"]="@dimitry-ishenko"
	["srv_enable,desc"]="Enable service"
	["srv_enable,options"]="<service_name.service>"
	["srv_enable,feature"]="srv_enable"
	["srv_enable,group"]="Interface"
)

# Enables one or more systemd services.
#
# Arguments:
#
# * Names of one or more systemd service units to enable (e.g., `nginx.service`).
#
# Returns:
#
# * The exit status of `systemctl enable`.
#
# Example:
#
# ```bash
# srv_enable nginx.service
# srv_enable foo.service bar.service
# ```
srv_enable() { systemctl enable "$@"; }

framework_options+=(
	["srv_enabled,author"]="@dimitry-ishenko"
	["srv_enabled,desc"]="Check if service is enabled"
	["srv_enabled,options"]="<service_name.service>"
	["srv_enabled,feature"]="srv_enabled"
	["srv_enabled,group"]="Interface"
)

# ```
srv_enabled() { systemctl is-enabled "$@"; }

framework_options+=(
	["srv_mask,author"]="@dimitry-ishenko"
	["srv_mask,desc"]="Mask service"
	["srv_mask,options"]="<service_name.service>"
	["srv_mask,feature"]="srv_mask"
	["srv_mask,group"]="Interface"
)

# Masks a systemd service unit, preventing it from being started manually or automatically.
#
# Arguments:
#
# * service_name.service: The name of the systemd service unit to mask.
#
# Returns:
#
# * The exit status of the `systemctl mask` command.
#
# Example:
#
# ```bash
# srv_mask nginx.service
# ```
srv_mask() { systemctl mask "$@"; }

framework_options+=(
	["srv_reload,author"]="@dimitry-ishenko"
	["srv_reload,desc"]="Reload service"
	["srv_reload,options"]="<service_name.service>"
	["srv_reload,feature"]="srv_reload"
	["srv_reload,group"]="Interface"
)

# Reloads a systemd service if the system is running.
#
# Arguments:
#
# * Name of the systemd service to reload (e.g., nginx.service)
#
# Returns:
#
# * Exit status of `systemctl reload` if the system is running; otherwise, always returns success.
#
# Example:
#
# ```bash
# srv_reload nginx.service
# ```
srv_reload()
{
	# ignore inside container
	_srv_system_running && systemctl reload "$@" || true
}

framework_options+=(
	["srv_restart,author"]="@dimitry-ishenko"
	["srv_restart,desc"]="Restart service"
	["srv_restart,options"]="<service_name.service>"
	["srv_restart,feature"]="srv_restart"
	["srv_restart,group"]="Interface"
)

# Restarts one or more systemd services if the system is running.
#
# Arguments:
#
# * Names of one or more systemd services to restart.
#
# Returns:
#
# * The exit status of `systemctl restart` if the system is running; otherwise, always returns success.
#
# Example:
#
# ```bash
# srv_restart nginx.service
# srv_restart sshd.service apache2.service
# ```
srv_restart()
{
	# ignore inside container
	_srv_system_running && systemctl restart "$@" || true
}

framework_options+=(
	["srv_start,author"]="@dimitry-ishenko"
	["srv_start,desc"]="Start service"
	["srv_start,options"]="<service_name.service>"
	["srv_start,feature"]="srv_start"
	["srv_start,group"]="Interface"
)

# Starts a systemd service if the system is running outside a container.
#
# Arguments:
#
# * service_name.service: The name of the systemd service to start.
#
# Returns:
#
# * The exit status of `systemctl start` if executed, or success (0) if ignored inside a container.
#
# Example:
#
# ```bash
# srv_start nginx.service
# ```
srv_start()
{
	# ignore inside container
	_srv_system_running && systemctl start "$@" || true
}

framework_options+=(
	["srv_status,author"]="@dimitry-ishenko"
	["srv_status,desc"]="Show service status information"
	["srv_status,options"]="<service_name.service>"
	["srv_status,feature"]="srv_status"
	["srv_status,group"]="Interface"
)

# Displays the status of one or more systemd services.
#
# Arguments:
#
# * One or more service names (e.g., sshd.service)
#
# Outputs:
#
# * Prints the status information of the specified services to STDOUT.
#
# Example:
#
# ```bash
# srv_status sshd.service
# ```
srv_status() { systemctl status "$@"; }

framework_options+=(
	["srv_stop,author"]="@dimitry-ishenko"
	["srv_stop,desc"]="Stop service"
	["srv_stop,options"]="<service_name.service>"
	["srv_stop,feature"]="srv_stop"
	["srv_stop,group"]="Interface"
)

# Stops one or more systemd services if the system is running outside a container.
#
# Arguments:
#
# * Names of one or more systemd services to stop.
#
# Returns:
#
# * Exit status of `systemctl stop` if executed; otherwise, always returns success if not running on a systemd host.
#
# Example:
#
# ```bash
# srv_stop nginx.service
# srv_stop sshd.service apache2.service
# ```
srv_stop()
{
	# ignore inside container
	_srv_system_running && systemctl stop "$@" || true
}

framework_options+=(
	["srv_unmask,author"]="@dimitry-ishenko"
	["srv_unmask,desc"]="Unmask service"
	["srv_unmask,options"]="<service_name.service>"
	["srv_unmask,feature"]="srv_unmask"
	["srv_unmask,group"]="Interface"
)

# Unmasks a systemd service, allowing it to be started or enabled again.
#
# Arguments:
#
# * Name of the systemd service unit to unmask (e.g., `nginx.service`)
#
# Returns:
#
# * Exit status of the `systemctl unmask` command.
#
# Example:
#
# ```bash
# srv_unmask nginx.service
# ```
srv_unmask() { systemctl unmask "$@"; }
