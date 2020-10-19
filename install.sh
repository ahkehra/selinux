##########################################################################################
#
# Magisk Module Installer Script
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure and implement callbacks in this file
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Unity Logic - Don't change/move this section
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

# Set to true if you do *NOT* want Magisk to mount
# any files for you. Most modules would NOT want
# to set this flag to true
SKIPMOUNT=false

# Set to true if you need to load system.prop
PROPFILE=false

# Set to true if you need post-fs-data script
POSTFSDATA=true

# Set to true if you need late_start service script
LATESTARTSERVICE=false

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

##########################################################################################
#
# Function Callbacks
#
# The following functions will be called by the installation framework.
# You do not have the ability to modify update-binary, the only way you can customize
# installation is through implementing these functions.
#
# When running your callbacks, the installation framework will make sure the Magisk
# internal busybox path is *PREPENDED* to PATH, so all common commands shall exist.
# Also, it will make sure /data, /system, and /vendor is properly mounted.
#
##########################################################################################
##########################################################################################
#
# The installation framework will export some variables and functions.
# You should use these variables and functions for installation.
#
# ! DO NOT use any Magisk internal paths as those are NOT public API.
# ! DO NOT use other functions in util_functions.sh as they are NOT public API.
# ! Non public APIs are not guranteed to maintain compatibility between releases.
#
# Available variables:
#
# MAGISK_VER (string): the version string of current installed Magisk
# MAGISK_VER_CODE (int): the version code of current installed Magisk
# BOOTMODE (bool): true if the module is currently installing in Magisk Manager
# MODPATH (path): the path where your module files should be installed
# TMPDIR (path): a place where you can temporarily store files
# ZIPFILE (path): your module's installation zip
# ARCH (string): the architecture of the device. Value is either arm, arm64, x86, or x64
# IS64BIT (bool): true if $ARCH is either arm64 or x64
# API (int): the API level (Android version) of the device
#
# Availible functions:
#
# ui_print <msg>
#     print <msg> to console
#     Avoid using 'echo' as it will not display in custom recovery's console
#
# abort <msg>
#     print error message <msg> to console and terminate installation
#     Avoid using 'exit' as it will skip the termination cleanup steps
#
# set_perm <target> <owner> <group> <permission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     this function is a shorthand for the following commands
#       chown owner.group target
#       chmod permission target
#       chcon context target
#
# set_perm_recursive <directory> <owner> <group> <dirpermission> <filepermission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     for all files in <directory>, it will call:
#       set_perm file owner group filepermission context
#     for all directories in <directory> (including itself), it will call:
#       set_perm dir owner group dirpermission context
#
##########################################################################################
##########################################################################################
# If you need boot scripts, DO NOT use general boot scripts (post-fs-data.d/service.d)
# ONLY use module scripts as it respects the module status (remove/disable) and is
# guaranteed to maintain the same behavior in future Magisk releases.
# Enable boot scripts by setting the flags in the config section above.
##########################################################################################

# Set what you want to display when installing your module

print_modname() {
  ui_print " "
  ui_print " SELinux Mode Changer "
  ui_print " Version : vFINAL "
  ui_print " Author : AkiraSuper "
  ui_print " "
}

on_install() {
  ui_print "- Extracting module files"
  unzip -o "$ZIPFILE" 'addon/*' -d $TMPDIR >&2
  postfs=$TMPDIR/post-fs-data.sh
  module=$TMPDIR/module.prop
  . $TMPDIR/addon/Volume-Key-Selector/preinstall.sh
  
ui_print " "
ui_print "- (𝗩𝗼𝗹𝘂𝗺𝗲 + 𝗡𝗲𝘅𝘁) × (𝗩𝗼𝗹𝘂𝗺𝗲 - 𝗜𝗻𝘀𝘁𝗮𝗹𝗹) -"
ui_print " "
ui_print "- 𝗡𝗼𝘁𝗲: 𝙎𝙀𝙇𝙞𝙣𝙪𝙭 𝙤𝙥𝙚𝙧𝙖𝙩𝙚𝙨 𝙤𝙣 𝙩𝙝𝙚 𝙥𝙧𝙞𝙣𝙘𝙞𝙥𝙡𝙚 𝙤𝙛 𝙙𝙚𝙛𝙖𝙪𝙡𝙩 𝙙𝙚𝙣𝙞𝙖𝙡: 𝘼𝙣𝙮𝙩𝙝𝙞𝙣𝙜 𝙣𝙤𝙩 "
ui_print " 𝙚𝙭𝙥𝙡𝙞𝙘𝙞𝙩𝙡𝙮 𝙖𝙡𝙡𝙤𝙬𝙚𝙙 𝙞𝙨 𝙙𝙚𝙣𝙞𝙚𝙙. 𝙎𝙀𝙇𝙞𝙣𝙪𝙭 𝙘𝙖𝙣 𝙤𝙥𝙚𝙧𝙖𝙩𝙚 𝙞𝙣 𝙩𝙬𝙤 𝙜𝙡𝙤𝙗𝙖𝙡 𝙢𝙤𝙙𝙚𝙨: "
ui_print "- 𝙀𝙣𝙛𝙤𝙧𝙘𝙞𝙣𝙜 𝙢𝙤𝙙𝙚, 𝙞𝙣 𝙬𝙝𝙞𝙘𝙝 𝙥𝙚𝙧𝙢𝙞𝙨𝙨𝙞𝙤𝙣𝙨 𝙙𝙚𝙣𝙞𝙖𝙡𝙨 𝙖𝙧𝙚 𝙗𝙤𝙩𝙝 𝙡𝙤𝙜𝙜𝙚𝙙 𝙖𝙣𝙙 𝙚𝙣𝙛𝙤𝙧𝙘𝙚𝙙. "
ui_print "- 𝙋𝙚𝙧𝙢𝙞𝙨𝙨𝙞𝙫𝙚 𝙢𝙤𝙙𝙚, 𝙞𝙣 𝙬𝙝𝙞𝙘𝙝 𝙥𝙚𝙧𝙢𝙞𝙨𝙨𝙞𝙤𝙣 𝙙𝙚𝙣𝙞𝙖𝙡𝙨 𝙖𝙧𝙚 𝙡𝙤𝙜𝙜𝙚𝙙 𝙗𝙪𝙩 𝙣𝙤𝙩 𝙚𝙣𝙛𝙤𝙧𝙘𝙚𝙙. "
ui_print ""
sleep 0.2
ui_print "- 𝗦𝗘𝗟𝗶𝗻𝘂𝘅 𝗠𝗼𝗱𝗲 𝗖𝗵𝗮𝗻𝗴𝗲𝗿 -️"
ui_print ""
sleep 0.2
ui_print " 1. Enforcing "
sleep 0.2
ui_print " 2. Permissive "
sleep 0.2
ui_print " 3. Default "
sleep 0.2
ui_print ""
sleep 0.2
ui_print " 𝗦𝗲𝗹𝗲𝗰𝘁: "
SL=1
while true; do
	ui_print "  $SL"
	if $VKSEL; then
		SL=$((SL + 1))
	else 
		break
	fi
	if [ $SL -gt 3 ]; then
		SL=1
	fi
done
ui_print " 𝗦𝗲𝗹𝗲𝗰𝘁𝗲𝗱: $SL "
#
case $SL in
	1 ) TEXT1="✓Enforcing "; FCTEXTAD1="- Enforcing"; sed -i '/setenforce/s/.*/setenforce 1/' $postfs;;
	2 ) TEXT1="✓Permissive "; FCTEXTAD1="- Permissive"; sed -i '/setenforce/s/.*/setenforce 0/' $postfs;;
	3 ) TEXT1=""; FCTEXTAD1="- SELinux Default"; sed -i '/setenforce/s/.*/#setenforce/' $postfs;;
esac
ui_print "$FCTEXTAD1"
ui_print ""
sleep 0.5
ui_print "- Writing SELinux Mode To Startup Script..."
ui_print "   "
sleep 1
  }

# Only some special files require specific permissions
# This function will be called after on_install is done
# The default permissions should be good enough for most cases

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $MODPATH 0 0 0755 0644

  # Here are some examples:
  # set_perm_recursive  $MODPATH/system/lib       0     0       0755      0644
  # set_perm  $MODPATH/system/bin/app_process32   0     2000    0755      u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0     2000    0755      u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0     0       0644
}

# Custom Variables for Install AND Uninstall - Keep everything within this function - runs before uninstall/install
unity_custom() {
  : # Remove this if adding to this function
}

# You can add more functions to assist your custom script code
