#! /bin/bash


test -z $NODE_EXPORTER && NODE_EXPORTER="true"
test -z $BLACKBOX_EXPORTER && BLACKBOX_EXPORTER="true"
test -z $SNMP_EXPORTER && SNMP_EXPORTER="true"
test -z $TIMEZONE && TIMEZONE="UTC"
test -z $NODE_EXPORTER_OPT || echo "Run Node Exporter wiht option "$NODE_EXPORTER_OPT
test -z $BLACKBOX_EXPORTER_OPT || echo "Run Blackbox Exporter wiht option "$BLACKBOX_EXPORTER_OPT
test -z $SNMP_EXPORTER_OPT || echo "Run SNMP Exporter wiht option "$SNMP_EXPORTER_OPT


if [ ! -f /etc/blackbox_exporter/config.yml ]; then
    echo "[Info] Not found blackbox_exporter/config.yml, Blackbox Exporter will not be started."
    BLACKBOX_EXPORTER="false"
fi
if [ ! -f /etc/snmp_exporter/snmp.yml ]; then
    echo "[Info] Not found snmp_exporter/snmp.yml, SNMP Exporter will not be started."
    SNMP_EXPORTER="false"
fi


ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime


if [ $NODE_EXPORTER == "true" ]; then
    if [ $BLACKBOX_EXPORTER == "true" ]; then
        /bin/blackbox_exporter --config.file=/etc/blackbox_exporter/config.yml \
            $BLACKBOX_EXPORTER_OPT >> /var/log/blackbox_exporter.log 2>&1 &
    fi
    if [ $SNMP_EXPORTER == "true" ]; then
        /bin/snmp_exporter --config.file=/etc/snmp_exporter/snmp.yml \
            $SNMP_EXPORTER_OPT >> /var/log/snmp_exporter.log 2>&1 &
    fi
    /bin/node_exporter $NODE_EXPORTER_OPT
elif [ $BLACKBOX_EXPORTER == "true" ]; then
    if [ $SNMP_EXPORTER == "true" ]; then
        /bin/snmp_exporter --config.file=/etc/snmp_exporter/snmp.yml \
            $SNMP_EXPORTER_OPT >> /var/log/snmp_exporter.log 2>&1 &
    fi
    /bin/blackbox_exporter --config.file=/etc/blackbox_exporter/config.yml \
        $BLACKBOX_EXPORTER_OPT
elif [ $SNMP_EXPORTER == "true" ]; then
    /bin/snmp_exporter --config.file=/etc/snmp_exporter/snmp.yml \
        $SNMP_EXPORTER_OPT
else
    echo "Nothing is enabled. Exit..."
fi

