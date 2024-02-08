# Schema registry


Docker Schema Registry image for the Confluent Platform using Oracle JDK 17. This image was created with the purpose of offering the [Confluent Open Source Platform](https://www.confluent.io/product/confluent-open-source/) running on top of [Oracle JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html) apart from integrating kafkastore keystore/truststore to the schema registry.

### Supported tags and respective Dockerfile links

 - latest ([Dockerfile](https://github.com/Dwijad/Confluent-Schema-Registry/blob/main/Dockerfile))

### Summary:

-   Debian "buster" image variant
-   Oracle JDK (build 17.0.10+11-LTS-240)
-   Oracle Java Cryptography Extension added
-   SHA 256 sum checks for all downloads
-   JAVA_HOME environment variable set up

### Build

To build from scratch, clone the repo and copy kafka keystore/truststore certificates and public certificate authority (CA) file of kafka broker to `script/ca` folder.

    $ git clone https://github.com/Dwijad/Confluent-Schema-Registry.git
    $ copy {ca-cert, kafka.truststore.jks, kafka.keystore.jks} to ~/Confluent-Schema-Registry/script/ca 

Build the docker image

    $ DOCKER_BUILDKIT=1 docker buildx build -t dwijad/kafka-connect:latest --no-cache --progress=plain .
    

 ### Environment variables:
 
 KAFKA_VERSION
 SCALA_VERSION
 SCHEMA_REGISTRY_VERSION
 LISTENERS 
 SSL_KEYSTORE_LOCATION   
 SSL_KEYSTORE_PASSWORD
 SSL_KEY_PASSWORD
 SSL_TRUSTSTORE_PASSWORD   
 SSL_TRUSTSTORE_LOCATION   
 SSL_CLIENT_AUTH   
 SSL_ENDPOINT_IDENTIFICATION_ALGORITHM    
 KAFKASTORE_SSL_KEY_PASSWORD   
 KAFKASTORE_SSL_KEYSTORE_LOCATION   
 KAFKASTORE_SSL_KEYSTORE_PASSWORD   
 KAFKASTORE_SSL_TRUSTSTORE_LOCATION    
 KAFKASTORE_SSL_TRUSTSTORE_PASSWORD   
 KAFKASTORE_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM   
 KAFKASTORE_BOOTSTRAP_SERVERS   
 KAFKASTORE_TOPIC   
 KAFKASTORE_SECURITY_PROTOCOL   
 INTER_INSTANCE_PROTOCOL   
 ACCESS_CONTROL_ALLOW_METHODS
 ACCESS_CONTROL_ALLOW_ORIGIN
 SCHEMA_COMPATIBILITY_LEVEL   
 HOST_NAME
 KAFKA_JMX_PORT
 KAFKA_JMX_HOSTNAME   
 SCHEMA_REGISTRY_JMX_OPTS   
 KAFKA_HEAP_OPTS   
  KAFKA_OPTS
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIwMjYxNDczODYsMjcyNjIxMzcwLDc4OD
E2ODMwMiw0ODIyMjY1NTgsMTU1MzM2OTU3N119
-->