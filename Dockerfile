FROM eclipse-temurin:11-jre-focal

LABEL org.opencontainers.image.authors="Björn Wilmsmann <bjoernkw@bjoernkw.com>, Philip Riecks <mail@philipriecks.de>"
# Derived from https://github.com/njmittet/alpine-activemq and https://github.com/rmohr/docker-activemq
# by Nils Jørgen Mittet <njmittet@gmail.com> and Roman Mohr <roman@fenkhuber.at>

ENV ACTIVEMQ_VERSION 5.15.14
ENV ACTIVEMQ apache-activemq-$ACTIVEMQ_VERSION
ENV ACTIVEMQ_HOME /opt/activemq
# See https://archive.apache.org/dist/activemq/5.15.14/apache-activemq-5.15.14-bin.tar.gz.sha512
ENV SHA512_VAL=5708ed926988e4796a8badaed3dafd32bcbc47890169df2712568ad706858370b20e5cd9a4e3298521692151e63a5ac6d06866b3ad188aa0e36b28e370240d5c

RUN apt update && \
    apt install -y curl && \
    mkdir -p /opt && \
    curl https://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$ACTIVEMQ-bin.tar.gz -o $ACTIVEMQ-bin.tar.gz

RUN if [ "$SHA512_VAL" != "$(sha512sum $ACTIVEMQ-bin.tar.gz | awk '{print($1)}')" ];\
    then \
        echo "sha512 values doesn't match! exiting."  && \
        exit 1; \
    fi;

RUN tar xzf $ACTIVEMQ-bin.tar.gz -C /opt && \
    ln -s /opt/$ACTIVEMQ $ACTIVEMQ_HOME && \
    groupadd activemq && \
    useradd -m -d $ACTIVEMQ_HOME -g activemq activemq && \
    chown -R activemq:activemq /opt/$ACTIVEMQ && \
    chown -h activemq:activemq $ACTIVEMQ_HOME 

EXPOSE 1883 5672 8161 61613 61614 61616

USER activemq
WORKDIR $ACTIVEMQ_HOME

CMD ["/bin/sh", "-c", "bin/activemq console"]
