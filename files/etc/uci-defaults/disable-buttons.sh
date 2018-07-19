#!/bin/sh

[ -e /etc/rc.button/rfkill ] && rm -f /etc/rc.button/rfkill
[ -e /etc/rc.button/wps    ] && rm -f /etc/rc.button/wps

exit 0
