#!/bin/sh

for service in adblock apcupsd aria2 nginx obfsproxy openvpn privoxy udpxy tvheadend; do

    if [ -e /etc/init.d/$service ]; then

        /etc/init.d/$service disable
        /etc/init.d/$service stop

    fi

done

exit 0
