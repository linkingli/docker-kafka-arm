#5 232.7
FROM centos:7

MAINTAINER Felix <whutwf@outlook.com>

RUN yum install -y java

ENV KAFKA_VERSION=2.12 \
    KAFKA_SUBVERSION=2.0.0 \
    KAFKA_WORKDIR=/opt \
    TZ=Asia/Shanghai

RUN set -ex \
    && apt-get update && apt-get install -y ca-certificates wget tar --no-install-recommends \
    && apt-get clean \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && cd ${KAFKA_WORKDIR} \
    && wget http://archive.apache.org/dist/kafka/${KAFKA_SUBVERSION}/kafka_${KAFKA_VERSION}-${KAFKA_SUBVERSION}.tgz \
    && tar -xzf ${KAFKA_WORKDIR}/kafka_${KAFKA_VERSION}-${KAFKA_SUBVERSION}.tgz -C ${KAFKA_WORKDIR}/ \
    && rm -rf ${KAFKA_WORKDIR}/kafka_${KAFKA_VERSION}-${KAFKA_SUBVERSION}.tgz

WORKDIR ${KAFKA_WORKDIR}/kafka_${KAFKA_VERSION}-${KAFKA_SUBVERSION}


COPY config/server.properties ${KAFKA_WORKDIR}/kafka_${KAFKA_VERSION}-${KAFKA_SUBVERSION}/config/
COPY config/zookeeper.properties ${KAFKA_WORKDIR}/kafka_${KAFKA_VERSION}-${KAFKA_SUBVERSION}/config/
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 9092 2181

ENTRYPOINT ["/entrypoint.sh"]
