FROM eclipse-temurin:17-jre-focal

LABEL org.opencontainers.image.authors="Björn Wilmsmann <bjoernkw@bjoernkw.com>, Philip Riecks <mail@philipriecks.de>"
# Derived from https://github.com/njmittet/alpine-activemq and https://github.com/rmohr/docker-activemq
# by Nils Jørgen Mittet <njmittet@gmail.com> and Roman Mohr <roman@fenkhuber.at>

ENV ACTIVEMQ_VERSION 5.17.4
ENV ACTIVEMQ apache-activemq-$ACTIVEMQ_VERSION
ENV ACTIVEMQ_HOME /opt/activemq
# See https://archive.apache.org/dist/activemq/5.17.4/apache-activemq-5.17.4-bin.tar.gz.sha512
ENV SHA512_VAL=1fbc83f5efdab9980690e938c101a3beea22d4af496c1f793b41dbbe086e341f159bb62740451221139d6e5968184bc82b55c27f46510811896c84ec12c0d595

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
