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

    $ DOCKER_BUILDKIT=1 docker buildx build -t dwijad/schema-registry:latest --no-cache --progress=plain .
    
### Run
    $ docker run -d \
    --name=schema-registry-0 \
    -e KAFKA_JMX_PORT="8080" \
    -e SCHEMA_REGISTRY_JMX_ENABLED="1" \
    dwijad/schema-registry:latest

To disable JMX unset run the docker command without passing   `KAFKA_JMX_PORT` and `SCHEMA_REGISTRY_JMX_ENABLED` environment vriable.

 ### Environment variables:

    Name: UID
    Default value: 1000
    Description: User ID used to build Dockerfile   

    Name: GID
    Default value: 1000
    Description: Group ID used to build Dockerfile

    Name: USERNAME 
    Default value: kafka
    Description: Kafka files/folder owner 
    
    Name: SCHEMA_REGISTRY_VERSION 
    Default value: 3.5.0
    Description: Schema registry version
     
    Name: LISTENERS 
    Default value: 3.5.0
    Description: Comma-separated list of listeners that listen for API requests over either HTTP or HTTPS.

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

### Kubernetes

```
export SCHEMA_REGISTRY_HOST_NAME
```        env:
        # https://docs.confluent.io/6.0.0/schema-registry/docs/config.html#host-name
        - name: SCHEMA_REGISTRY_HOST_NAME
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTM1MzE1MjYzMywxMTY3MjQzMzM3LDEwMz
Y1NDI3MDgsMzAxMjQ5NTgzLC0xMDkwNjcyNzQzLDE2NjY4MDM5
NDAsLTIwOTMyODc2ODUsMTA2NDEyOTE4NSwtMjAyNjE0NzM4Ni
wyNzI2MjEzNzAsNzg4MTY4MzAyLDQ4MjIyNjU1OCwxNTUzMzY5
NTc3XX0=
-->