FROM qnib/alpn-base

ENV FORWARD_TO_ELASTICSEARCH=false \
    FORWARD_TO_KAFKA=false \
    FORWARD_TO_HEKA=false \
    FORWARD_TO_LOGSTASH=false \
    FORWARD_TO_FILE=false \
    RSYSLOG_VER=8.16.0

ADD patch/rsyslog.h /tmp/
RUN apk add --update autoconf automake curl-dev g++ gnutls-dev json-c-dev libee-dev libestr-dev libgcrypt-dev liblogging-dev libnet-dev libtool make net-snmp-dev perl py-docutils tar util-linux-dev wget zlib-dev \
 && mkdir -p /opt/ \
 && wget -qO - http://www.rsyslog.com/files/download/rsyslog/rsyslog-${RSYSLOG_VER}.tar.gz |tar xfz - -C /opt/ \
 && cd /opt/rsyslog-${RSYSLOG_VER} \
 && cat /tmp/rsyslog.h >> runtime/rsyslog.h \
 && ./configure --prefix=/usr/ --enable-elasticsearch --enable-imfile --enable-imptcp --enable-impstats --enable-mmjsonparse \
 && make \
 && make install \
 && rm -rf /var/cache/apk/* /opt/rsyslog-${RSYSLOG_VER} /tmp/rsyslog.h
ADD opt/qnib/rsyslog/bin/configure-targets.sh \
    opt/qnib/rsyslog/bin/start.sh \
    /opt/qnib/rsyslog/bin/
ADD etc/consul-templates/rsyslog_targets.conf.ctmpl /etc/consul-templates/
ADD etc/rsyslog.conf /etc/
ADD opt/qnib/rsyslog/consul.d/syslog.json /opt/qnib/rsyslog/consul.d/
ADD etc/rsyslog.d/file.conf.disabled \
    etc/rsyslog.d/heka.conf.disabled \
    etc/rsyslog.d/kafka.conf.disabled \
    etc/rsyslog.d/elasticsearch.conf.disabled \
    etc/rsyslog.d/logstash.conf.disabled \
    etc/rsyslog.d/imuxsock.conf \
    /etc/rsyslog.d/
CMD ["/opt/qnib/rsyslog/bin/start.sh"]
