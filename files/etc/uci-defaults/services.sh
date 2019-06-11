#!/bin/sh

for service in acme apcupsd adblock aria2 asterisk banip collectd e2guardian fwknopd https_dns_proxy igmpproxy ipsec mjpg-streamer \
    netserver nodogsplash openvpn pagekitec pingcheck relayd smcroute tor trafficshapper tvheadend udptunnel xl2tpd; do

    if [ -e /etc/init.d/$service ]; then

        /etc/init.d/$service disable
        /etc/init.d/$service stop

    fi

    [ -e /etc/init.d/socat ] && {
        /etc/init.d/socat disable
        rm -f /etc/init.d/socat
    }

done

exit 0
