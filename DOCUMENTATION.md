| Description | Example | Credit |
|:----------- | ------- |:------:|
| Check for (Whiptail, DIALOG, READ) tools and set the user interface. |  | Tearran 
| Toggle SSH lastlog | toggle_ssh_lastlog | @Tearran 
| Manage checkpoints | debug help mark reset total | @dimitry-ishenko 
| Generate this markdown table of all module_options | see_function_table_md | @Tearran 
| Netplan wrapper | simple advanced type stations select store restore dhcp static help | @igorpecovnik 
| Exit with error code 1, optionally printing a message to stderr | run_critical_function || die 'The world is about to end' | @dimitry-ishenko 
| Reload service | srv_reload ssh.service | @dimitry-ishenko 
| Webmin setup and service setting. | help install remove start stop enable disable status check | @Tearran 
| Display a menu from pipe | show_menu <<< armbianmonitor -h  ;  | @Tearran 
| Start service | srv_start ssh.service | @dimitry-ishenko 
| Build the main menu from a object | generate_top_menu 'json_data' | @Tearran 
| Install headers container | install remove status help | @armbian 
| Migrated procedures from Armbian config. | is_package_manager_running | @armbian 
| Migrated procedures from Armbian config. | check_desktop | @armbian 
|  |  | @igorpecovnik 
| Needed by generate_menu | execute_command 'id' | @Tearran 
| Display a Yes/No dialog box and process continue/exit | get_user_continue 'Do you wish to continue?' process_input | @Tearran 
| Module for Armbian firmware manipulating. | select install show hold unhold repository headers help | @igorpecovnik 
| Deploy Armbian KVM instances | install remove save drop restore list help | @igorpecovnik 
| Unmask service | srv_unmask ssh.service | @dimitry-ishenko 
| Migrated procedures from Armbian config. | connect_bt_interface | @armbian 
| Display a message box | show_message <<< 'hello world'  | @Tearran 
| menu User Interface box | <function_name> | Tearran 
| Manage self hosted runners | install remove remove_online purge status help | @igorpecovnik 
| Install and configure automatic updates | install remove configure status defaults help | @igorpecovnik 
| Generate Document files. |  | @Tearran 
| Enable/disable device tree overlays |  | @viraniac 
| XFCE desktop packages | install remove disable enable status auto manual login help | @igorpecovnik 
| Show or generate QR code for Google OTP | qr_code generate | @igorpecovnik 
| Remove package | pkg_remove nmap | @dimitry-ishenko 
| Samba setup and service setting. | help install remove start stop enable disable configure default status | @Tearran 
| Check when apt list was last updated and suggest updating or update | see_current_apt or see_current_apt update | @Tearran 
| Show the usage of the functions. | _api_list | @Tearran 
| Install plexmediaserver from repo using apt | install remove status | @schwar3kat 
| Upgrade installed packages (potentially removing some) | pkg_full_upgrade | @dimitry-ishenko 
| Install zfs filesystem support | install remove status kernel_max zfs_version zfs_installed_version help | @igorpecovnik 
| Check if package is installed | pkg_installed mc | @dimitry-ishenko 
| Install openssh-server container | install remove purge status help | @armbian 
| Upgrade installed packages | pkg_upgrade | @dimitry-ishenko 
| initialize system variables |  | @igorpecovnik 
| Check if a domain is reachable via IPv4 and IPv6 | check_ip_version google.com | @Tearran 
| Install package | pkg_install neovim | @dimitry-ishenko 
| Set Armbian root filesystem to read only | install remove status help | @igorpecovnik 
| Cockpit setup and service setting. | help install remove start stop enable disable status check | @tearran 
| Generate a submenu from a parent_id | generate_menu 'parent_id' | @Tearran 
| info User Interface box | <<< 'hello world' ;  | @Tearran 
| Generate a markdown list json objects using jq. | see_jq_menu_list | @Tearran 
| Enable service | srv_enable ssh.service | @dimitry-ishenko 
| Generate jobs from JSON file. | generate_jobs_from_json | @Tearran 
| yes/no User Interface box | '<string>' process_input | @Tearran 
| Display a warning with a gauge for 10 seconds then continue |  | @igorpecovnik 
| Toggle IPv6 on or off | toggle_ipv6 | @Tearran 
| Adjust welcome screen (motd) | adjust_motd clear, header, sysinfo, tips, commands | @igorpecovnik 
| Reload systemd configuration | srv_daemon_reload | @dimitry-ishenko 
| Generate JSON-like object file. | generate_json | @Tearran 
| Reusable helper function to process user-selected packages for installation or removal. | process_package_selection <title> <prompt> <checklist_options_array> | @Tearran 
| Uses Avalible (Whiptail, DIALOG, READ) for the menu interface | <function_name> | Tearran 
| Netplan wrapper | network_config | @igorpecovnik 
|  |  | @tearran 
| Select optimised Odroid board configuration | select | @GeoffClements 
| Install owncloud container | install remove purge status help | @armbian 
| Change the background color of the User Interface box | set_colors 0-7 | @Tearran 
| Show general information about this tool | about_armbian_configng | @igorpecovnik 
| Serve the edit and debug server. |  | @Tearran 
| Check if service is active | srv_active ssh.service | @dimitry-ishenko 
| Install nfs client | install remove servers mounts help | @igorpecovnik 
| pipeline strings to an infobox  | show_infobox <<< 'hello world' ;  | @Tearran 
| Stop hostapd, clean config | default_wireless_network_config | @igorpecovnik 
| Generate desktop packages list |  | @igorpecovnik 
| Parse json to get list of desired menu or submenu items | parse_menu_items 'menu_options_array' | @viraniac 
| Check if service is enabled | srv_enabled ssh.service | @dimitry-ishenko 
| Check for (Whiptail, DIALOG, READ) tools and set the user interface. |  | @tearran 
| Set system shell to BASH | manage_zsh enable|disable | @igorpecovnik 
| Mask service | srv_mask ssh.service | @dimitry-ishenko 
| checklist User Interface box | interface_checklist <title> <prompt> <options_array> | @Tearran 
| Show service status information | srv_status ssh.service | @dimitry-ishenko 
| Stop service | srv_stop ssh.service | @dimitry-ishenko 
| Configure an unconfigured package | pkg_configure | @dimitry-ishenko 
| Disable service | srv_disable ssh.service | @dimitry-ishenko 
| Revert network config back to Armbian defaults | default_network_config | @igorpecovnik 
| Check if the current OS is supported based on /etc/armbian-distribution-status | help | @Tearran 
| Install nfsd server | install remove manage add status clients servers help | @igorpecovnik 
| Install and configure Armbian rsyncd. | install remove status help | @igorpecovnik 
| Generate a Help message for cli commands. | _cmd_list [category] | @Tearran 
| Generate 'Armbian CPU logo' SVG for document file. |  | @Tearran 
| Check the internet connection with fallback DNS | see_ping | @Tearran 
| OK message User Interface box | <<< 'hello world'  | @Tearran 
| Make sure param contains only valid chars | sanitize 'foo_bar_42' | @Tearran 
| Markdown table of all module_options |  | @Tearran 
| Upgrade to next stable or rolling release | release_upgrade stable verify | @igorpecovnik 
| Update the /etc/skel files in users directories | update_skel | @igorpecovnik 
| change_system_hostname | change_system_hostname | @igorpecovnik 
| Restart service | srv_restart ssh.service | @dimitry-ishenko 
| Update package repository | pkg_update | @dimitry-ishenko 
| Secure version of get_user_continue | get_user_continue_secure 'Do you wish to continue?' process_input | @Tearran 

