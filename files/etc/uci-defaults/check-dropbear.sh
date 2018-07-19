#!/bin/sh

if ls -ald /etc/dropbear | grep -v -q '^drwxr-xr-x'; then
	chmod 755 /etc/dropbear
	chmod 644 /etc/dropbear/authorized_keys
	chmod 600 /etc/dropbear/dropbear_rsa_host_key
fi
