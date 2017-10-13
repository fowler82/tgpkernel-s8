# -------------------------------
# TGPKERNEL AROMA INSTALLER v2.14
# anykernel2 portion
#
# Anykernel2 created by #osm0sis
# S8Port/NFE mods by @kylothow
# Kernel paths from @Morogoku
# Everything else done by @djb77
#
# DO NOT USE ANY PORTION OF THIS
# CODE WITHOUT MY PERMISSION!!
# -------------------------------

## AnyKernel setup
# Begin Properties
properties() {
kernel.string=
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=dreamlte
device.name2=dream2lte
device.name3=
device.name4=
device.name5=
} # end properties

# Shell Variables
block=/dev/block/platform/11120000.ufs/by-name/BOOT;
is_slot_device=0;
bb="$BB"

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;

## AnyKernel install
ui_print "- Extracing Boot Image";
dump_boot;

# Ramdisk changes - Modded / New Files
ui_print "- Adding TGPKernel Mods";
replace_file sbin/initd.sh 755 s8/sbin/initd.sh;
replace_file sbin/kernelinit.sh 755 s8/sbin/kernelinit.sh;
replace_file sbin/resetprop 755 s8/sbin/resetprop;
replace_file sbin/wakelock.sh 755 s8/sbin/wakelock.sh;
replace_file init 755 s8/init;
replace_file fstab.samsungexynos8895 644 s8/fstab.samsungexynos8895;
replace_file init.samsungexynos8895.rc 755 s8/init.samsungexynos8895.rc;
replace_file init.services.rc 755 s8/init.services.rc;

# Ramdisk changes - default.prop
replace_string default.prop "ro.debuggable=0" "ro.debuggable=1" "ro.debuggable=0";
replace_string default.prop "persist.sys.usb.config=mtp,adb" "persist.sys.usb.config=mtp" "persist.sys.usb.config=mtp,adb";
insert_line default.prop "persist.service.adb.enable=1" after "persist.sys.usb.config=mtp,adb" "persist.service.adb.enable=1";
insert_line default.prop "ro.securestorage.support=false" after "debug.atrace.tags.enableflags=0" "ro.securestorage.support=false";
insert_line default.prop "ro.config.tima=0" after "ro.securestorage.support=false" "ro.config.tima=0";

# Ramdisk changes - fstab.goldfish
replace_string fstab.goldfish "/dev/block/mtdblock0                                    /system             ext4      ro,noatime,barrier=1                                 wait" "/dev/block/mtdblock0                                    /system             ext4      ro,barrier=1                                         wait" "/dev/block/mtdblock0                                    /system             ext4      ro,noatime,barrier=1                                 wait";

# Ramdisk changes - fstab.ranchu
replace_string fstab.ranchu "/dev/block/vda                                          /system             ext4      ro,noatime                                           wait" "/dev/block/vda                                          /system             ext4      ro                                                   wait" "/dev/block/vda                                          /system             ext4      ro,noatime                                           wait";

# Ramdisk changes - init.rc
insert_line init.rc "import /init.services.rc" after "import /init.fac.rc" "import /init.services.rc";

# Ramdisk changes - Spectrum
if egrep -q "install=1" "/tmp/aroma/spectrum.prop"; then
	ui_print "- Adding Spectrum";
	replace_file init.spectrum.rc 644 spectrum/init.spectrum.rc;
	replace_file init.spectrum.sh 644 spectrum/init.spectrum.sh;
	insert_line init.rc "import /init.spectrum.rc" after "import /init.services.rc" "import /init.spectrum.rc";
fi;
if egrep -q "selected.1=1" "/tmp/aroma/spectrumprofile.prop"; then
	ui_print "- Setting Balanced Spectrum Profile";
	insert_line sbin/kernelinit.sh "\$BB sbin/resetprop persist.spectrum.profile 0" after "# Spectrum Profile" "\$BB sbin/resetprop persist.spectrum.profile 0";
fi;
if egrep -q "selected.1=2" "/tmp/aroma/spectrumprofile.prop"; then
	ui_print "- Setting Performance Spectrum Profile";
	insert_line sbin/kernelinit.sh "\$BB sbin/resetprop persist.spectrum.profile 1" after "# Spectrum Profile" "\$BB sbin/resetprop persist.spectrum.profile 1";
fi;
if egrep -q "selected.1=3" "/tmp/aroma/spectrumprofile.prop"; then
	ui_print "- Setting Battery Spectrum Profile";
	insert_line sbin/kernelinit.sh "\$BB sbin/resetprop persist.spectrum.profile 2" after "# Spectrum Profile" "\$BB sbin/resetprop persist.spectrum.profile 2";
fi;
if egrep -q "selected.1=4" "/tmp/aroma/spectrumprofile.prop"; then
	ui_print "- Setting Gaming Spectrum Profile";
	insert_line sbin/kernelinit.sh "\$BB sbin/resetprop persist.spectrum.profile 3" after "# Spectrum Profile" "\$BB sbin/resetprop persist.spectrum.profile 3";
fi;

# Ramdisk changes - SELinux (Fake) Enforcing Mode
if egrep -q "install=1" "/tmp/aroma/selinux.prop"; then
	ui_print "- Enabling SELinux Enforcing Mode";
	replace_string sbin/kernelinit.sh "\$BB echo \"1\" > /sys/fs/selinux/enforce" "\$BB echo \"0\" > /sys/fs/selinux/enforce" "\$BB echo \"1\" > /sys/fs/selinux/enforce";
fi;

# End ramdisk changes
ui_print "- Writing Boot Image";
write_boot;

## End install

