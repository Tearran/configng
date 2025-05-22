---
title: "armbian-config(1)"
author: "Armbian Team"
date: "Thu May 22 10:25:34 PM UTC 2025"
---

<img alt="Armbian Config Logo" src="https://raw.githubusercontent.com/armbian/configng/main/share/icons/hicolor/scalable/configng-tux.svg">

# NAME
**Armbian Config** - The Next Generation

# SYNOPSIS
`armbian-config[option] [arguments] [@]`

# DESCRIPTION
`armbian-config` provides configuration and installation routines for customizing and automating tasks within the Armbian Linux environment. These utilities help streamline setup processes for various use cases, such as managing software, network settings, localization, and system optimizations.

# COMMAND-LINE OPTIONS
`armbian-config` can also be used directly from the command line with the following options:

## General Options
- Display help for specific module or overall usage.

```bash
armbian-config [--help | -h | help] | [module_name]
```
List of all avalible features
```bash
Usage: ./bin/armbian-config [] [options]

1. Toggle SSH lastlog
	toggle_ssh_lastlog toggle_ssh_lastlog

2. Manage checkpoints
	checkpoint debug help mark reset total

3. Netplan wrapper
	module_simple_network simple advanced type stations select store restore dhcp static help

4. Exit with error code 1, optionally printing a message to stderr
	die 'The world is about to end'

5. Reload service
	srv_reload <service_name.service>

6. Webmin setup and service setting.
	module_webmin help install remove start stop enable disable status check

7. Start service
	srv_start <service_name.service>

8. Merges compatible associative arrays into module_options for unified access.
	merge_arrays_into_module_options <options_name>

9. Install headers container
	module_headers install remove status help

10. Migrated procedures from Armbian config.
	is_package_manager_running 

11. Migrated procedures from Armbian config.
	check_desktop 

12. Storing netplan config to tmp
	store_netplan_config 

13. Dynamic ProFTPD package management with install/remove toggle.
	_checklist_proftpd 

14. Module for Armbian firmware manipulating.
	module_armbian_firmware select install show hold unhold repository headers help

15. Deploy Armbian KVM instances
	module_armbian_kvmtest install remove save drop restore list help

16. Unmask service
	srv_unmask <service_name.service>

17. Migrated procedures from Armbian config.
	connect_bt_interface 

18. menu User Interface box
	interface_menu <function_name>

19. Browser installation and management (Firefox-ESR and Chromium and more).
	_checklist_browsers 

20. Manage self hosted runners
	module_armbian_runners install remove remove_online purge status help

21. Install and configure automatic updates
	module_armbian_upgrades install remove configure status defaults help

22. Generate Document files.
	docs_markdown_manpage 

23. Enable/disable device tree overlays
	manage_dtoverlays 

24. XFCE desktop packages
	module_desktop install remove disable enable status auto manual login help

25. Show or generate QR code for Google OTP
	qr_code generate

26. Remove package
	pkg_remove <apt packeage name>

27. Samba setup and service setting.
	module_samba help install remove start stop enable disable configure default status

28. Check when apt list was last updated and suggest updating or update
	see_current_apt update

29. Install plexmediaserver from repo using apt
	Install plexmediaserver install remove status

30. Upgrade installed packages (potentially removing some)
	pkg_full_upgrade 

31. Generate Document files.
	markdown_manpage 

32. Install zfs filesystem support
	module_zfs install remove status kernel_max zfs_version zfs_installed_version help

33. Check if package is installed
	pkg_installed <apt packeage name>

34. Install openssh-server container
	module_openssh-server install remove purge status help

35. Upgrade installed packages
	pkg_upgrade 

36. initialize system variables
	initialize_variables 

37. Check if a domain is reachable via IPv4 and IPv6
	check_ip_version <Domain name>

38. Install package
	pkg_install <apt packeage name>

39. Apt wizard TUI deb packages similar to softy
	module_softy help Editors Browsers Proftpd Imaging

40. Set Armbian root filesystem to read only
	module_overlayfs install remove status help

41. Cockpit setup and service setting.
	module_cockpit help install remove start stop enable disable status check

42. info User Interface box
	interface_infobox <<< 'hello world' ; 

43. Enable service
	srv_enable <service_name.service>

44. yes/no User Interface box
	interface_yes_no '<string>' process_input

45. Display a warning with a gauge for 10 seconds then continue
	info_wait_autocontinue 

46. Imaging Editor installation and management (gimp inkscape).
	_checklist_imaging inkscape gimp

47. Adjust welcome screen (motd)
	about_armbian_configng adjust_motd clear, header, sysinfo, tips, commands

48. Toggle IPv6 on or off
	toggle_ipv6 

49. Reload systemd configuration
	 srv_daemon_reload

50. Generate JSON-like object file.
	generate_json 

51. Reusable helper function to process user-selected packages for installation or removal.
	process_package_selection <title> <prompt> <checklist_options_array>

52. Netplan wrapper
	network_config 

53. The main TUI menu list
	interface_categories System Network Localisation Software About

54. Select optimised Odroid board configuration
	Odroid board select

55. Install owncloud container
	module_owncloud install remove purge status help

56. Change the background color of the User Interface box
	set_colors 0 1 2 3 4 5 6 7

57. Displays a usage/help message listing all features in the specified options array, including their names, descriptions, and usage.
	options_list <options_array_name>

58. Show general information about this tool
	about_armbian_configng about_armbian_configng

59. Check if service is active
	srv_active <service_name.service>

60. Install nfs client
	module_nfs install remove servers mounts help

61. Stop hostapd, clean config
	default_wireless_network_config 

62. Generate desktop packages list
	module_desktop 

63. Check if service is enabled
	srv_enabled <service_name.service>

64. Check for (Whiptail, DIALOG) tools and set the user interface.
	initialize_interface 

65. Set system shell to BASH
	manage_zsh manage_zsh enable|disable

66. Mask service
	srv_mask <service_name.service>

67. checklist User Interface box
	interface_checklist <title> <prompt> <options_array>

68. Show service status information
	srv_status <service_name.service>

69. Stop service
	srv_stop <service_name.service>

70. Configure an unconfigured package
	pkg_configure pkg_configure

71. Editor installation and management (codium notepadqq and more).
	_checklist_editors nano code codium notepadqq

72. Disable service
	srv_disable srv_disable ssh.service

73. Revert network config back to Armbian defaults
	default_network_config 

74. Check if the current OS is supported based on /etc/armbian-distribution-status
	check_os_status help

75. Install nfsd server
	module_nfsd install remove manage add status clients servers help

76. Install and configure Armbian rsyncd.
	module_armbian_rsyncd install remove status help

77. Check the internet connection with fallback DNS
	see_ping 

78. OK message User Interface box
	interface_message <<< 'hello world' 

79. Make sure param contains only valid chars
	sanitize <module_name>

80. Markdown table of all module_options
	markdown_module_options 

81. Upgrade to next stable or rolling release
	release_upgrade stable verify

82. Update the /etc/skel files in users directories
	update_skel update_skel

83. Change hostname
	change_system_hostname 

84. Restart service
	srv_restart <service_name.service>

85. Update package repository
	pkg_update 
```


---

# SEE ALSO
For more information, visit:
- [Armbian Documentation](https://docs.armbian.com/User-Guide_Armbian-Config/)
- [GitHub Repository](https://github.com/armbian/configng)

---

# COPYRIGHT
© 2025 Armbian Team. Distributed under the GPL 3.0 license.
