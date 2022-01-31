FROM openjdk:11-jre-slim

LABEL org.opencontainers.image.authors="Björn Wilmsmann <bjoernkw@bjoernkw.com>, Philip Riecks <mail@philipriecks.de>"
# Derived from https://github.com/njmittet/alpine-activemq
# by Nils Jørgen Mittet <njmittet@gmail.com>

ENV ACTIVEMQ_VERSION 5.15.14
ENV ACTIVEMQ apache-activemq-$ACTIVEMQ_VERSION
ENV ACTIVEMQ_HOME /opt/activemq

RUN apt-get update && \
    apt-get install -f -y curl && \
    mkdir -p /opt && \
    curl -s -S https://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$ACTIVEMQ-bin.tar.gz | tar -xvz -C /opt && \
    ln -s /opt/$ACTIVEMQ $ACTIVEMQ_HOME

# Create app runtime user and group
RUN groupadd activemq && \
    useradd -m -d $ACTIVEMQ_HOME -g activemq activemq && \
    chown -R activemq:activemq /opt/$ACTIVEMQ && \
    chown -h activemq:activemq $ACTIVEMQ_HOME 

EXPOSE 1883 5672 8161 61613 61614 61616

USER activemq
WORKDIR $ACTIVEMQ_HOME

CMD ["/bin/sh", "-c", "bin/activemq console"]
