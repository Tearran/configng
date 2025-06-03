# service.sh

# internal function
_srv_system_running() { [[ $(systemctl is-system-running) =~ ^(running|degraded)$ ]]; }

declare -A framework_options
framework_options+=(
	["srv_active,author"]="@dimitry-ishenko"
	["srv_active,desc"]="Check if service is active"
	["srv_active,example"]="<service_name.service>"
	["srv_active,feature"]="srv_active"
	["srv_active,group"]="Interface"
)

srv_active()
{
	# fail inside container
	_srv_system_running && systemctl is-active --quiet "$@"
}

declare -A framework_options
framework_options+=(
	["srv_daemon_reload,author"]="@dimitry-ishenko"
	["srv_daemon_reload,desc"]="Reload systemd configuration"
	["srv_daemon_reload,example"]="srv_daemon_reload"
	["srv_daemon_reload,feature"]=""
	["srv_daemon_reload,group"]="Interface"
)

srv_daemon_reload()
{
	# ignore inside container
	_srv_system_running && systemctl daemon-reload || true
}

framework_options+=(
	["srv_disable,author"]="@dimitry-ishenko"
	["srv_disable,desc"]="Disable service"
	["srv_disable,example"]="srv_disable ssh.service"
	["srv_disable,feature"]="srv_disable"
	["srv_disable,group"]="Interface"
)

srv_disable() { systemctl disable "$@"; }

framework_options+=(
	["srv_enable,author"]="@dimitry-ishenko"
	["srv_enable,desc"]="Enable service"
	["srv_enable,example"]="<service_name.service>"
	["srv_enable,feature"]="srv_enable"
	["srv_enable,group"]="Interface"
)

srv_enable() { systemctl enable "$@"; }

framework_options+=(
	["srv_enabled,author"]="@dimitry-ishenko"
	["srv_enabled,desc"]="Check if service is enabled"
	["srv_enabled,example"]="<service_name.service>"
	["srv_enabled,feature"]="srv_enabled"
	["srv_enabled,group"]="Interface"
)

srv_enabled() { systemctl is-enabled "$@"; }

framework_options+=(
	["srv_mask,author"]="@dimitry-ishenko"
	["srv_mask,desc"]="Mask service"
	["srv_mask,example"]="<service_name.service>"
	["srv_mask,feature"]="srv_mask"
	["srv_mask,group"]="Interface"
)

srv_mask() { systemctl mask "$@"; }

framework_options+=(
	["srv_reload,author"]="@dimitry-ishenko"
	["srv_reload,desc"]="Reload service"
	["srv_reload,example"]="<service_name.service>"
	["srv_reload,feature"]="srv_reload"
	["srv_reload,group"]="Interface"
)

srv_reload()
{
	# ignore inside container
	_srv_system_running && systemctl reload "$@" || true
}

framework_options+=(
	["srv_restart,author"]="@dimitry-ishenko"
	["srv_restart,desc"]="Restart service"
	["srv_restart,example"]="<service_name.service>"
	["srv_restart,feature"]="srv_restart"
	["srv_restart,group"]="Interface"
)

srv_restart()
{
	# ignore inside container
	_srv_system_running && systemctl restart "$@" || true
}

framework_options+=(
	["srv_start,author"]="@dimitry-ishenko"
	["srv_start,desc"]="Start service"
	["srv_start,example"]="<service_name.service>"
	["srv_start,feature"]="srv_start"
	["srv_start,group"]="Interface"
)

srv_start()
{
	# ignore inside container
	_srv_system_running && systemctl start "$@" || true
}

framework_options+=(
	["srv_status,author"]="@dimitry-ishenko"
	["srv_status,desc"]="Show service status information"
	["srv_status,example"]="<service_name.service>"
	["srv_status,feature"]="srv_status"
	["srv_status,group"]="Interface"
)

srv_status() { systemctl status "$@"; }

framework_options+=(
	["srv_stop,author"]="@dimitry-ishenko"
	["srv_stop,desc"]="Stop service"
	["srv_stop,example"]="<service_name.service>"
	["srv_stop,feature"]="srv_stop"
	["srv_stop,group"]="Interface"
)

srv_stop()
{
	# ignore inside container
	_srv_system_running && systemctl stop "$@" || true
}

framework_options+=(
	["srv_unmask,author"]="@dimitry-ishenko"
	["srv_unmask,desc"]="Unmask service"
	["srv_unmask,example"]="<service_name.service>"
	["srv_unmask,feature"]="srv_unmask"
	["srv_unmask,group"]="Interface"
)

srv_unmask() { systemctl unmask "$@"; }
