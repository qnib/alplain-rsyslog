#!/bin/bash

for rsock in $(echo $RSYSLOG_SOCKETS |tr ',' ' ');do
    mkdir -p /shareddev/${rsock}/
    export SOCKNAME=${rsock}
    consul-template -consul localhost:8500 -once "/etc/consul-templates/rsyslog_imuxsock.conf.ctmpl:/etc/rsyslog.d/imuxsock_${rsock}.conf"
done
