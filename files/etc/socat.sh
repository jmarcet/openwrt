#!/bin/sh

_uart_devices=$( ls /dev/ttyUSB* | sed -e 's:/dev/::g' )
[ -z "${_uart_devices}" ] && exit

for DEVICE_NAME in ${_uart_devices}; do
    _port=${DEVICE_NAME/ttyUSB}

    pgrep -f "socat.+${DEVICE_NAME}" &>/dev/null && continue
    logger -t socat uart device $DEVICE_NAME detected on boot - launching socat
    socat -ly openssl-listen:200${_port},bind=192.168.137.1,pf=ip4,cert=/etc/ssl/server-nighthawk.pem,cafile=/etc/ssl/client.crt,fork,crlf file:/dev/${DEVICE_NAME},b115200,setlk,raw,echo=0,crnl &
    socat -ly openssl-listen:200${_port},bind=nighthawk,pf=ip6,cert=/etc/ssl/server-nighthawk.pem,cafile=/etc/ssl/client.crt,fork,crlf file:/dev/${DEVICE_NAME},b115200,setlk,raw,echo=0,crnl &
done
