#!/sbin/sh
# TGPKernel Flashing Script
# Originally written by @Tkkg1994

cd /tmp/tgptemp/kernels

getprop ro.boot.bootloader >> BLmodel

if grep -q G955 BLmodel; then
	cat g955x.img > /dev/block/platform/11120000.ufs/by-name/BOOT
fi;
if grep -q G950 BLmodel; then
	cat g950x.img > /dev/block/platform/11120000.ufs/by-name/BOOT
fi;

sync
