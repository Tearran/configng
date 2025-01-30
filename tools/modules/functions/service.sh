
function service()
{
	# ignore these commands, if running inside container
	[[ "$1" =~ ^(reload|restart|start|status|stop)$ ]] && systemd-detect-virt -qc && return 0
	systemctl daemon-reload
	systemctl "$@"
}
