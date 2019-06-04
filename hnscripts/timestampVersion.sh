#!/bin/bash
#
# timestampVersion  -  Collect source version info and insert it into firmware

STATUSFILE=files/etc/Compile_info.txt
Nickname=master

echo OpenWrt $Nickname `scripts/getver.sh` / `date "+%F %H:%M"` > $STATUSFILE
echo "---" >> $STATUSFILE
echo "main      `(git log -1 --format="%cd %h %s" --abbrev=7 --date=short | head -n 1 | cut -b1-60)`" >> $STATUSFILE
echo "luci      `(cd feeds/luci && git log -1 --format="%cd %h %s" --abbrev=7 --date=short | cut -b1-60)`" >> $STATUSFILE
echo "packages  `(cd feeds/packages && git log -1 --format="%cd %h %s" --abbrev=7 --date=short | cut -b1-60)`" >> $STATUSFILE
echo "routing   `(cd feeds/routing && git log -1 --format="%cd %h %s" --abbrev=7 --date=short | cut -b1-60)`" >> $STATUSFILE
git add $STATUSFILE

# Override git/svn timestamp after r48583-48594, set initial clock to now
date +%s > version.date

