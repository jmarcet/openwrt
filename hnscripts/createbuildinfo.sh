#!/bin/sh
#
# createbuildinfo  -  Create info on current config and source code changes

getGitInfo() {
#params: directory patchfile infofile
 echo "\n######################################################\n" >> $3
 (cd $1
  git diff HEAD > $2
  git remote -v show | grep fetch >> $3
  git branch --list >> $3
  git show --format="%cd %h %s" --abbrev=7 --date=short | head -n 1 | cut -b1-60 >> $3
  git status --porcelain >> $3
 )
}

BinDir=$PWD/bin/targets/ipq806x/generic
Device=R7800
Prefix=openwrt-ipq806x-netgear_r7800
Branch=master

VersTime=$Branch-`scripts/getver.sh`-`date +%Y%m%d-%H%M`
TFile=$BinDir/$Device-$VersTime

echo process $Branch...

# cleanup old binaries & patches
rm -f $BinDir/$Device-*

# remove unnecessary files
rm -f $BinDir/*root.img $BinDir/*vmlinux.elf

# create status info and patches
echo "$VersTime" > $TFile-status.txt
getGitInfo . $TFile-main.patch $TFile-status.txt
getGitInfo feeds/luci $TFile-luci.patch $TFile-status.txt
getGitInfo feeds/packages $TFile-packages.patch $TFile-status.txt
#getGitInfo feeds/routing $TFile-routing.patch $TFile-status.txt
sed -i -e 's/$/\r/' $TFile-status.txt

# collect config info
cp .config $TFile.config
cp .config.init $TFile.config.init
scripts/diffconfig.sh > $TFile.diffconfig 2>/dev/null

# copy buildroot creation script and patch timestamp info
cp hnscripts/newBuildroot.sh $TFile-newBuildroot.sh
sed -i "s/^FILESTAMP=.*/FILESTAMP=$Device-$VersTime/" $TFile-newBuildroot.sh

# cleanup checksum files
grep -sh $Prefix.*-squashfs $BinDir/md5sums $BinDir/sha256sums \
  | sed -e 's/$/\r/' -e 's/\*'$Prefix'/'$Device'/' -e 's/squash/sq/' \
  > $TFile-checksums.txt
rm -f $BinDir/md5sums $BinDir/sha256sums

# rename manifest and firmware files
cd $BinDir
mv *.manifest $Device-$VersTime.manifest
mv $Prefix-squashfs-sysupgrade.bin $Device-$VersTime-sqfs-sysupgrade.bin
mv $Prefix-squashfs-factory.img $Device-$VersTime-sqfs-factory.img

