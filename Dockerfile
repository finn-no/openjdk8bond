FROM alpine:edge

USER root

RUN mkdir /app
ENV JAVA_APP_DIR /app
ENV JAVA_VERSION 8.72.15-r2


RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk add --update \
    curl \
    openjdk8-jre-base=$JAVA_VERSION \
 && rm /var/cache/apk/*

ADD agent-bond-opts /opt/run-java-options
RUN mkdir -p /opt/agent-bond \
 && curl http://central.maven.org/maven2/io/fabric8/agent-bond-agent/0.1.1/agent-bond-agent-0.1.1.jar \
         -o /opt/agent-bond/agent-bond.jar \
 && chmod 444 /opt/agent-bond/agent-bond.jar \
 && chmod 755 /opt/run-java-options
ADD jmx_exporter_config.json /opt/agent-bond/
EXPOSE 8778 9779

# Add run script as /app/run-java.sh and make it executable
COPY run-java.sh /app/run-java.sh
RUN chmod 755 /app/run-java.sh



CMD [ "/app/run-java.sh" ]
