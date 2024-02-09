FROM debian:buster

ARG kafka_version=3.5.0 \
    schema_registry_version=3.5.0 \ 
    scala_version=2.13 \
    vcs_ref=unspecified \
    build_date=unspecified \
    UID=1000 \
    GID=1000 \
    USERNAME=kafka \
    LISTENERS \
    SSL_KEYSTORE_LOCATION \
    SSL_KEYSTORE_PASSWORD \
    SSL_KEY_PASSWORD \
    SSL_TRUSTSTORE_PASSWORD \
    SSL_TRUSTSTORE_LOCATION \ 
    SSL_CLIENT_AUTH \
    SSL_ENDPOINT_IDENTIFICATION_ALGORITHM \
    KAFKASTORE_SSL_KEY_PASSWORD \
    KAFKASTORE_SSL_KEYSTORE_LOCATION \
    KAFKASTORE_SSL_KEYSTORE_PASSWORD \
    KAFKASTORE_SSL_TRUSTSTORE_LOCATION \
    KAFKASTORE_SSL_TRUSTSTORE_PASSWORD \
    KAFKASTORE_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM \
    KAFKASTORE_BOOTSTRAP_SERVERS \
    KAFKASTORE_TOPIC \
    KAFKASTORE_SECURITY_PROTOCOL \
    INTER_INSTANCE_PROTOCOL \
    ACCESS_CONTROL_ALLOW_METHODS \
    ACCESS_CONTROL_ALLOW_ORIGIN \
    SCHEMA_COMPATIBILITY_LEVEL \
    HOST_NAME \
    KAFKA_JMX_PORT \
    KAFKA_JMX_HOSTNAME \
    SCHEMA_REGISTRY_JMX_OPTS \
    KAFKA_HEAP_OPTS \
    KAFKA_OPTS \
    SCHEMA_REGISTRY_JMX_ENABLED \
    SCHEMA_REGISTRY_HOST_NAME


LABEL org.label-schema.name="Schema Registry" \
      org.label-schema.description="Confluent Schema Registry" \
      org.label-schema.build-date="${build_date}" \
      org.label-schema.vcs-url="https://github.com/dwijad/schema-registry-sasl-ssl" \
      org.label-schema.vcs-ref="${vcs_ref}" \
      org.label-schema.version="${scala_version}_${kafka_version}" \
      org.label-schema.schema-version="1.0" \
      maintainer="dwijad"

ENV KAFKA_VERSION=$kafka_version \
    SCALA_VERSION=$scala_version \
    KAFKA_HOME=/u01/cnfkfk \
    SCHEMA_REGISTRY_VERSION=$SCHEMA_REGISTRY_VERSION \
    LISTENERS=$LISTENERS \
    SSL_KEYSTORE_LOCATION=$SSL_KEYSTORE_LOCATION \
    SSL_KEYSTORE_PASSWORD=$SSL_KEYSTORE_PASSWORD \
    SSL_KEY_PASSWORD=$SSL_KEY_PASSWORD \
    SSL_TRUSTSTORE_PASSWORD=$SSL_TRUSTSTORE_PASSWORD \
    SSL_TRUSTSTORE_LOCATION=$SSL_TRUSTSTORE_LOCATION \ 
    SSL_CLIENT_AUTH=$SSL_CLIENT_AUTH \
    SSL_ENDPOINT_IDENTIFICATION_ALGORITHM=$SSL_ENDPOINT_IDENTIFICATION_ALGORITHM \
    KAFKASTORE_SSL_KEY_PASSWORD=$KAFKASTORE_SSL_KEY_PASSWORD \
    KAFKASTORE_SSL_KEYSTORE_LOCATION=$KAFKASTORE_SSL_KEYSTORE_LOCATION \
    KAFKASTORE_SSL_KEYSTORE_PASSWORD=$KAFKASTORE_SSL_KEYSTORE_PASSWORD \
    KAFKASTORE_SSL_TRUSTSTORE_LOCATION=$KAFKASTORE_SSL_TRUSTSTORE_LOCATION \
    KAFKASTORE_SSL_TRUSTSTORE_PASSWORD=$KAFKASTORE_SSL_TRUSTSTORE_PASSWORD \
    KAFKASTORE_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM=$KAFKASTORE_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM \
    KAFKASTORE_BOOTSTRAP_SERVERS=$KAFKASTORE_BOOTSTRAP_SERVERS \
    KAFKASTORE_TOPIC=$KAFKASTORE_TOPIC \
    KAFKASTORE_SECURITY_PROTOCOL=$KAFKASTORE_SECURITY_PROTOCOL \
    INTER_INSTANCE_PROTOCOL=$INTER_INSTANCE_PROTOCOL \
    ACCESS_CONTROL_ALLOW_METHODS=$ACCESS_CONTROL_ALLOW_METHODS \
    ACCESS_CONTROL_ALLOW_ORIGIN=$ACCESS_CONTROL_ALLOW_ORIGIN \
    SCHEMA_COMPATIBILITY_LEVEL=$SCHEMA_COMPATIBILITY_LEVEL \
    HOST_NAME=$HOST_NAME \
    KAFKA_JMX_PORT=$KAFKA_JMX_PORT \
    KAFKA_JMX_HOSTNAME=$KAFKA_JMX_HOSTNAME \
    SCHEMA_REGISTRY_JMX_OPTS=$SCHEMA_REGISTRY_JMX_OPTS \
    KAFKA_HEAP_OPTS=$KAFKA_HEAP_OPTS \
    KAFKA_OPTS=$KAFKA_OPTS \
    SCHEMA_REGISTRY_JMX_ENABLED=$SCHEMA_REGISTRY_JMX_ENABLED \
    SCHEMA_REGISTRY_HOST_NAME=$SCHEMA_REGISTRY_HOST_NAME

ENV PATH=${PATH}:${KAFKA_HOME}/bin
USER root
WORKDIR /u01/cnfkfk

RUN set -eux  \
    && apt-get update  \
    && apt-get upgrade -y  \
    && apt-get install -y --no-install-recommends vim jq net-tools curl wget zip unzip openssl ca-certificates  \
    && apt clean  \
    && apt autoremove -y  \
    && apt -f install  \
    && apt-get install -y --no-install-recommends netcat sudo \
    && mkdir -p /u01/cnfkfk  \
    && groupadd --gid $GID $USERNAME \
    && adduser --uid $UID --gid $GID --disabled-password --gecos "" kafka --home /u01/cnfkfk --shell /bin/bash \
    && sudo echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && cp -r /etc/skel/.[^.]* /u01/cnfkfk \
    && mkdir -p /u01/cnfkfk/java \
    && chown -R kafka:kafka /u01 \
    && chmod -R 755  /u01/cnfkfk 

USER kafka
WORKDIR $KAFKA_HOME

ADD --chown=kafka:kafka --chmod=755 https://packages.confluent.io/archive/7.5/confluent-community-7.5.3.tar.gz $KAFKA_HOME
ADD --chown=kafka:kafka --chmod=755 https://download.oracle.com/java/17/archive/jdk-17.0.10_linux-x64_bin.tar.gz $KAFKA_HOME
ADD --chown=kafka:kafka --chmod=755 https://repo.maven.apache.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.20.0/jmx_prometheus_javaagent-0.20.0.jar $KAFKA_HOME/etc/schema-registry/
ADD --chown=kafka:kafka --chmod=755 config/jmx-schema-registry-prometheus.yml $KAFKA_HOME/etc/schema-registry

RUN tar -zx -C $KAFKA_HOME/java --strip-components=1 -f jdk-17.0.10_linux-x64_bin.tar.gz && \
    rm -f jdk-17.0.10_linux-x64_bin.tar.gz && \
    tar -zx -C $KAFKA_HOME --strip-components=1 -f confluent-community-7.5.3.tar.gz && \
    rm -rf confluent* && \
    chown -R kafka:kafka $KAFKA_HOME && \
    mkdir -p $KAFKA_HOME/etc/ssl

ADD --chown=kafka:kafka --chmod=755 script/generate_pem_cert.sh $KAFKA_HOME/etc/ssl
ADD --chown=kafka:kafka --chmod=755 script/ca/ $KAFKA_HOME/etc/ssl/

WORKDIR $KAFKA_HOME

ENV PATH="${PATH}:$KAFKA_HOME/java/bin:$KAFKA_HOME/bin" 
ENV JAVA_HOME="$KAFKA_HOME/java"


WORKDIR $KAFKA_HOME/etc/ssl


RUN chmod u+x $KAFKA_HOME/etc/ssl/generate_pem_cert.sh \    
    && $KAFKA_HOME/etc/ssl/generate_pem_cert.sh  


WORKDIR /u01/cnfkfk
ADD --chown=kafka:kafka --chmod=755 script/start.sh $KAFKA_HOME


CMD ["/bin/bash"]

ENTRYPOINT ["/bin/bash" , "start.sh"]
