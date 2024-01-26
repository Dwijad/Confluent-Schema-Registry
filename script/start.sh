#!/bin/bash -x

KAFKA_HOME=/u01/cnfkfk

cat << EOF > $KAFKA_HOME/etc/schema-registry/schema-registry.properties
listeners=${listeners:-http://0.0.0.0:8081 , https://0.0.0.0:8082}
ssl.truststore.location=${SSL_TRUSTSTORE_LOCATION:-/u01/cnfkfk/etc/ssl/sr.truststore.jks}
ssl.truststore.password=${SSL_TRUSTSTORE_PASSWORD:-password}
ssl.keystore.location=${SSL_KEYSTORE_LOCATION:-/u01/cnfkfk/etc/ssl/sr.keystore.jks}
ssl.keystore.password=${SSL_KEYSTORE_PASSWORD:-password}
ssl.key.password=${SSL_KEY_PASSWORD:-password}
ssl.client.auth=${SSL_CLIENT_AUTH:-false}
ssl.endpoint.identification.algorithm=${SSL_ENDPOINT_IDENTIFICATION_ALGORITHM:-}
kafkastore.ssl.truststore.location=${KAFKASTORE_SSL_TRUSTSTORE_LOCATION:-/u01/cnfkfk/etc/ssl/sr.truststore.jks}
kafkastore.ssl.truststore.password=${KAFKASTORE_SSL_TRUSTSTORE_PASSWORD:-password}
kafkastore.ssl.keystore.location=${KAFKASTORE_SSL_KEYSTORE_LOCATION:-/u01/cnfkfk/etc/ssl/sr.keystore.jks}
kafkastore.ssl.keystore.password=${KAFKASTORE_SSL_KEYSTORE_PASSWORD:-password}
kafkastore.ssl.key.password=${KAFKASTORE_SSL_KEY_PASSWORD:-password}
kafkastore.ssl.endpoint.identification.algorithm=${KAFKASTORE_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM:-}
kafkastore.bootstrap.servers=${KAFKASTORE_BOOTSTRAP_SERVERS:-test-kafka.default.svc.cluster.local:9092} 
kafkastore.topic=${KAFKASTORE_TOPIC:-_schemas} 
kafkastore.security.protocol=${KAFKASTORE_SECURITY_PROTOCOL:-SASL_SSL} 
kafkastore.sasl.mechanism=${KAFKASTORE_SASL_MECHANISM:-PLAIN} 
kafkastore.sasl.jaas.config=${KAFKASTORE_SASL_JAAS_CONFIG:-org.apache.kafka.common.security.plain.PlainLoginModule required username=user1 password=password;} 
inter.instance.protocol=${INTER_INSTANCE_PROTOCOL:-https} 
access.control.allow.methods=${ACCESS_CONTROL_ALLOW_METHODS:-GET,POST,PUT,DELETE,OPTIONS,HEAD} 
access.control.allow.origin=${ACCESS_CONTROL_ALLOW_ORIGIN:-*}
EOF

sleep infinity