#!/bin/bash

for rsock in $(echo $RSYSLOG_SOCKETS |tr ',' ' ');do
    mkdir -p /shareddev/${rsock}/
    sed -e "s/SOCKNAME/${rsock}/g" /opt/qnib/rsyslog/etc/imuxsock.conf > /etc/rsyslog.d/imuxsock_${rsock}.conf
done
