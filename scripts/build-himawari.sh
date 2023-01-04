#!/bin/bash

set -ev

SRC="$HOME/src/openwrt/openwrt-master-x64"
TARGET="/mnt/himawari"

[ "$(pwd)" == "$SRC" ] || cd "$SRC"

[ -n "$BRANCH" ]    || BRANCH="master"
[ -n "$NR_PROC" ]   || NR_PROC="$(nrproc)"
[ -n "$SRC_FILES" ] || SRC_FILES="$(pwd)/files-asustek-computer-inc-sabertooth-z77"
[ -n "$CONFIG" ]    || CONFIG="$SRC_FILES/root/config"

if [ ! -e /etc/.openwrt_buidroot ]; then
    echo "You need to enter a proper chroot"
    exit 1
fi

if [ $UID -eq 0 ]; then
    echo "Must be run as non root"
    exit 1
fi

# Import seed config
[ -v SKIP_CONFIG_UPDATE ] || (cat "$CONFIG" >| .config && make defconfig)

# Compare baked in config with live target
grep -q " ${TARGET} fuse.sshfs " /proc/mounts || mount "${TARGET}"
cd "$SRC_FILES/etc"
#diff -pru . "$TARGET/etc"
cd "$SRC"

if [ ! -v SKIP_UPDATE ]; then
    # Update openwrt repo
    # AHEAD=$(git status | awk '/ahead of .upstream./ {print $8}')
    git fetch --all && git log "HEAD${AHEAD:+-$AHEAD}..upstream/$BRANCH" && git rebase "upstream/$BRANCH"

    # Update openwrt feeds
    for feed in luci packages routing telephony; do
        echo "Updating $feed feed..."
        cd "$SRC/feeds/$feed"
        # AHEAD=$(git status | awk '/ahead of .upstream./ {print $8}')
        git fetch --all && git log "HEAD${AHEAD:+-$AHEAD}..upstream/$BRANCH" && git rebase "upstream/$BRANCH"
    done
    cd "$SRC"
    ./scripts/feeds update -af && ./scripts/feeds install -af
fi

# Rebase & export updated config
make oldconfig
./scripts/diffconfig.sh >| current12
[ -v SKIP_CONFIG_UPDATE ] || vimdiff current12 "$CONFIG"

rm -f bin/targets/x86/64/* &>/dev/null || true
rm -fr build/target*/root* &>/dev/null || true

# Launch the build
#make download -j"$NR_PROC" V=sc || make download V=sc
make world -j"$NR_PROC" V=sc

# List built firmwares
ls -Altr bin/targets/x86/64
