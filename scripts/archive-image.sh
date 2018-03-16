#!/usr/bin/env bash

DESTDIR=/storage/downloads/openwrt

set -v

(
_target=$( grep '^CONFIG_TARGET_[a-z0-9]\+=y' .config | sed -e 's:^CONFIG_TARGET_\([a-z0-9]\+\)=y:\1:' )
_bindir=$( ls -d bin/targets/$_target/* )

_destdir=$DESTDIR/${_bindir/bin\/targets\/}
_img=$( ls -t $_bindir/*-factory.img | head -1 )
_date=$( date -r $_img +%Y%m%d_%H%M%S )
_subdir=$_date-`echo $_img | cut -d'-' -f3-4`

_t=$_destdir/$_subdir

if [ ! -d "$_t" ]; then
    mkdir -p $_t
    for i in $( ls -t $_bindir/ | head -6 ); do
        cp -a -v $_bindir/$i $_t/
    done
else
    echo $_t already exists
fi
)

set +v

exit 0
