#!/bin/bash

# Calculating schema registry id
SCHEMA_REGISTRY_ID=0

DOMAIN=schema-registry-
DOMAIN="$DOMAIN$SCHEMA_REGISTRY_ID"

# Ensure all environment variables are properly configured.
: "${KAFKA_HOME=/u01/cnfkfk}"
: "${KEY_STORE=$KAFKA_HOME/etc/ssl/sr.keystore.jks}"
: "${TRUST_STORE=$KAFKA_HOME/etc/ssl/sr.truststore.jks}"
: "${DOMAIN=$DOMAIN}"
: "${PASSWORD=password}"

echo -e "KAFKA_HOME=$KAFKA_HOME\n\
KEY_STORE=$KEY_STORE\n\
TRUST_STORE=$TRUST_STORE\n\
DOMAIN=$DOMAIN\n\
PASSWORD=$PASSWORD"

# Create keystore, if the file does not exist
if [[ ! -f ${KEY_STORE} ]]; then
    echo "No keystore file is found; hence creating a new one at $KAFKA_HOME/etc/ssl/"
                                                                                                    
    keytool -keystore sr.keystore.jks  -alias $DOMAIN -dname "CN=$DOMAIN, OU=unit, O=company, L=guwahati, S=assam, C=IN" -ext SAN=DNS:$DOMAIN -validity 3650 -genkey -keyalg RSA -storepass $PASSWORD && \
    keytool -keystore sr.truststore.jks -alias CARoot -importcert -file ca-cert  -storepass "password" -keypass "password" -noprompt
    keytool -keystore sr.keystore.jks -alias $DOMAIN -certreq -file "cert-file-$DOMAIN" -storepass $PASSWORD && \
    openssl x509 -req -CA ca-cert -CAkey ca-key -in "cert-file-$DOMAIN" -out "cert-signed-$DOMAIN" -days 3650 -CAcreateserial -extensions v3_req -ext SAN=DNS:$DOMAIN -passin pass:$PASSWORD && \
    keytool -noprompt -keystore sr.keystore.jks -alias ca -import -file ca-cert -storepass $PASSWORD -keypass $PASSWORD && \
    keytool -noprompt -keystore sr.keystore.jks -alias $DOMAIN -import -file "cert-signed-$DOMAIN" -storepass $PASSWORD

    echo "Generated keystore file is ${KEY_STORE} and ${TRUST_STORE}"
    cd /
fi

#keytool -keystore kafka.server.keystore.jks -alias localhost -keyalg RSA -validity {validity} -genkey
#openssl req -new -x509 -keyout ca-key -out ca-cert -days {validity}
#keytool -keystore kafka.client.truststore.jks -alias CARoot -importcert -file ca-cert
#keytool -keystore kafka.server.truststore.jks -alias CARoot -importcert -file ca-cert
#keytool -keystore kafka.server.keystore.jks -alias localhost -certreq -file cert-file
#openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file -out cert-signed -days {validity} -CAcreateserial -passin pass:{ca-password}
#keytool -keystore kafka.server.keystore.jks -alias CARoot -importcert -file ca-cert
#keytool -keystore kafka.server.keystore.jks -alias localhost -importcert -file cert-signed