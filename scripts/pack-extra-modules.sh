#!/bin/bash

[ -n "$TARGET_DIR" ] || \
    TARGET_DIR=build_dir/target-arm_cortex-a15+neon-vfpv4_musl_eabi
[ -n "$MODULES" ] || \
    MODULES="dvb_usb_v2 dvb-usb-rtl28xxu e4000 rtl2832 rtl2832_sdr"

_target=$( grep '^CONFIG_TARGET_[a-z0-9]\+=y' .config | sed -e 's:^CONFIG_TARGET_\([a-z0-9]\+\)=y:\1:' )

_root_dir=root-$_target

_linux_builddir=$( ls -d $TARGET_DIR/linux-$_target/linux-* )
_linux_subdir=$( basename $_linux_builddir )
_linux_ver=${_linux_subdir/linux-}

_dest_dir=$TARGET_DIR/$_root_dir/lib/modules/$_linux_ver

echo
echo linux_builddir=$_linux_builddir
echo linux_subdir=$_linux_subdir
echo linux_ver=$_linux_ver
echo _dest_dir=$_dest_dir
echo

_findstring="find $_linux_builddir/"
for module in $MODULES; do
    _findstring+=" -o -name '$module.ko'"
done
_findstring=$( echo $_findstring | sed -e 's:/ -o -name:/ -name:' )

_files=$( eval $_findstring )
echo $_files
echo

cp -a $_files $_dest_dir/

exit 0
