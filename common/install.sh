mkdir -p $MODPATH/system/bin
ui_print ""
ui_print "    ╭━━┳╮╭╮╱╱╱╱╭━━╮ "
ui_print "    ┃╭╮┃┣╋╋┳┳━╮┃━━╋┳┳━┳━┳┳╮ "
ui_print "    ┃┣┫┃━┫┃╭┫╋╰╋━━┃┃┃╋┃┻┫╭╯ "
ui_print "    ╰╯╰┻┻┻┻╯╰━━┻━━┻━┫╭┻━┻╯ "
ui_print "    ╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╰╯ "
ui_print ""
sleep 0.5
ui_print "- SElinux Status : $(su -c getenforce) "
ui_print ""
sleep 0.5
ui_print " (Volume + Next) × (Volume - Install) "
ui_print ""
sleep 0.5
ui_print "- NOTE -"
ui_print " SELinux operates on the principle of default denial:"
ui_print " Anything not explicitly allowed is denied."
ui_print " SELinux can operate in two global modes:"
ui_print " - Permissive mode, in which permission denials are logged but not enforced."
ui_print " - Enforcing mode, in which permissions denials are both logged and enforced."
ui_print ""
sleep 0.5
ui_print "- Security-Enhanced Linux (SELinux) -"
ui_print ""
sleep 0.2
ui_print " 1. Enforcing "
sleep 0.2
ui_print " 2. Permissive "
sleep 0.2
ui_print " 3. Cancel "
ui_print ""
sleep 0.2
ui_print " Select: "
SM=1
while true; do
	ui_print "  $SM"
	if $VKSEL; then
		SM=$((SM + 1))
	else 
		break
	fi
	if [ $SM -gt 3 ]; then
		SM=1
	fi
done
ui_print " Selected: $SM "
#
case $SM in
 1 ) TEXT3="Enforcing"; sed -i '/setenforce/s/.*/setenforce 1/' $MODPATH/post-fs-data.sh; sed -i '/echo > /sys/fs/selinux/enforce/s/.*/echo 1 > /sys/fs/selinux/enforce/' $MODPATH/post-fs-data.sh; sed -i '/Magisk Module providing basic SELinux Managment functionality./s/.*/Magisk Module providing basic SELinux Managment functionality. Security-Enhanced Linux Mode: Enforcing' $MODPATH/module.prop;;
 2 ) TEXT3="Permissive"; sed -i '/setenforce/s/.*/setenforce 0/' $MODPATH/post-fs-data.sh; sed -i '/echo > /sys/fs/selinux/enforce/s/.*/echo 0 > /sys/fs/selinux/enforce/' $MODPATH/post-fs-data.sh; sed -i '/Magisk Module providing basic SELinux Managment functionality./s/.*/Magisk Module providing basic SELinux Managment functionality. Security-Enhanced Linux Mode: Permissive' $MODPATH/module.prop;;
 3 ) abort
esac
ui_print ""
ui_print "- Mode: $TEXT3 "
ui_print ""
mv -f $MODPATH/common/akirasuper $MODPATH/system/bin/akirasuper