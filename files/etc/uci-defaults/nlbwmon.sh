#!/bin/sh

uci set nlbwmon.@nlbwmon[0].database_directory=/root/nlbwmon
uci commit nlbwmon

exit 0
