FROM arm64v8/openjdk:8

MAINTAINER Felix <whutwf@outlook.com>

RUN apt-get update && apt-get install -y ca-certificates wget tar --no-install-recommends

ENV KAFKA_VERSION=2.11 \
    KAFKA_SUBVERSION=2.1.1 \
    KAFKA_WORKDIR=/opt \
    TZ=Asia/Shanghai

RUN set -ex \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && cd ${KAFKA_WORKDIR} \
    && wget http://mirror.bit.edu.cn/apache/kafka/${KAFKA_SUBVERSION}/kafka_${KAFKA_VERSION}-${KAFKA_SUBVERSION}.tgz \
    && tar -xzf ${KAFKA_WORKDIR}/kafka_${KAFKA_VERSION}-${KAFKA_SUBVERSION}.tgz -C ${KAFKA_WORKDIR}/ \ 
    && rm -rf ${KAFKA_WORKDIR}/kafka_${KAFKA_VERSION}-${KAFKA_SUBVERSION}.tgz 

WORKDIR ${KAFKA_WORKDIR}/kafka_${KAFKA_VERSION}-${KAFKA_SUBVERSION}

COPY config/server.properties ${KAFKA_WORKDIR}/kafka_${KAFKA_VERSION}-${KAFKA_SUBVERSION}/config/
COPY config/zookeeper.properties ${KAFKA_WORKDIR}/kafka_${KAFKA_VERSION}-${KAFKA_SUBVERSION}/config/
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh 

EXPOSE 9092 2181

ENTRYPOINT ["/entrypoint.sh"]
