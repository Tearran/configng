module_options+=(
	["change_system_hostname,feature"]="change_system_hostname"
	["change_system_hostname,desc"]="Change hostname"
	["change_system_hostname,options"]=""
	["change_system_hostname,about"]=""
	["change_system_hostname,doc_link"]="Missing"
	["change_system_hostname,author"]="@igorpecovnik"
	["change_system_hostname,group"]="User"
	["change_system_hostname,port"]="Unset"
	["change_system_hostname,arch"]="Missing"
)


#
# @description Change system hostname
#
function change_system_hostname() {
	local new_hostname=$($DIALOG --title "Enter new hostnane" --inputbox "" 7 50 3>&1 1>&2 2>&3)
	[ $? -eq 0 ] && [ -n "${new_hostname}" ] && hostnamectl set-hostname "${new_hostname}"
}

