#!/usr/local/bin/dumb-init /bin/bash

### Put consul check in place
if [ ! -f /etc/consul.d/syslog.json ];then
    if [ -d /etc/consul.d ];then
        cp /opt/qnib/rsyslog/consul.d/syslog.json /etc/consul.d/
        /opt/qnib/consul/bin/consul reload
    else
        msg="WARN: No consul.d directory found... skipping Consul config"
        logger ${msg}
        echo ${msg}
    fi
fi

/opt/qnib/rsyslog/bin/configure-targets.sh
/opt/qnib/rsyslog/bin/configure-sockets.sh

/usr/sbin/rsyslogd -n
