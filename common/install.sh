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
ui_print "- NOTE -"
ui_print " SELinux operates on the principle of default denial:"
ui_print " Anything not explicitly allowed is denied."
ui_print " SELinux can operate in two global modes:"
ui_print " - Permissive mode, in which permission denials are logged but not enforced."
ui_print " - Enforcing mode, in which permissions denials are both logged and enforced."
ui_print ""
sleep 0.5
ui_print "- Security-Enhanced Linux (SELinux) -"
if [ "$(su -c getenforce)" == "Permissive" ]; then
    sed -i '/setenforce/s/.*/setenforce 1/' $MODPATH/post-fs-data.sh
    sed -i "s/echo/echo 1/g" $MODPATH/post-fs-data.sh
    sed -i "s/Magisk Module providing basic SELinux Managment functionality./Magisk Module providing basic SELinux Managment functionality. Security-Enhanced Linux Mode: Enforcing/g" $MODPATH/module.prop
    echo ""
    echo "- SELinux Enforcing Mode"
    echo ""
elif [ "$(su -c getenforce)" == "Enforcing" ]; then
    sed -i '/setenforce/s/.*/setenforce 0/' $MODPATH/post-fs-data.sh
    sed -i "s/echo/echo 0/g" $MODPATH/post-fs-data.sh
    sed -i "s/Magisk Module providing basic SELinux Managment functionality./Magisk Module providing basic SELinux Managment functionality. Security-Enhanced Linux Mode: Permissive/g" $MODPATH/module.prop
    echo ""
    echo "- SELinux Permissive Mode"
    echo ""
fi
mv -f $MODPATH/common/akirasuper $MODPATH/system/bin/akirasuper