FROM alpine:3.10


ARG NODE_EXPORTER_VERSION="1.0.1"
ARG BLACKBOX_EXPORTER_VERSION="0.18.0"
ARG SNMP_EXPORTER_VERSION="0.19.0"


RUN apk add wget

RUN wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-386.tar.gz && \
    tar zxvf node_exporter-${NODE_EXPORTER_VERSION}.linux-386.tar.gz
RUN wget https://github.com/prometheus/blackbox_exporter/releases/download/v${BLACKBOX_EXPORTER_VERSION}/blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-386.tar.gz && \
    tar zxvf blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-386.tar.gz
RUN wget https://github.com/prometheus/snmp_exporter/releases/download/v${SNMP_EXPORTER_VERSION}/snmp_exporter-${SNMP_EXPORTER_VERSION}.linux-386.tar.gz && \
    tar zxvf snmp_exporter-${SNMP_EXPORTER_VERSION}.linux-386.tar.gz


RUN cp node_exporter-${NODE_EXPORTER_VERSION}.linux-386/node_exporter /bin/node_exporter

RUN cp blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-386/blackbox_exporter  /bin/blackbox_exporter

RUN cp snmp_exporter-${SNMP_EXPORTER_VERSION}.linux-386/snmp_exporter  /bin/snmp_exporter


RUN rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-386* blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-386* snmp_exporter-${SNMP_EXPORTER_VERSION}.linux-386* && \
    apk del wget


ADD asset/entrypoint.sh .
ENTRYPOINT ["sh", "entrypoint.sh"]
