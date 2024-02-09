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
    -e SCHEMA_REGISTRY_JMX_PORT="8080" \
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
    Default value: http://0.0.0.0:8081, https://0.0.0.0:8082
    Description: Comma-separated list of listeners that listen for API requests over either HTTP or HTTPS.

    Name: SSL_KEYSTORE_LOCATION 
    Default value: /u01/cnfkfk/etc/ssl/kafka-broker-0.keystore.jks
    Description: SSL Keystore file

    Name: SSL_KEYSTORE_PASSWORD 
    Default value: password
    Description: SSL Keystore password
  
    Name:  SSL_TRUSTSTORE_LOCATION 
    Default value: /u01/cnfkfk/etc/ssl/kafka.truststore.jks
    Description: SSL truststore file
 
    Name:  SSL_CLIENT_AUTH 
    Default value: false
    Description: Whether or not to require the HTTPS client to authenticate via the server’s trust store.

    Name:  SSL_ENDPOINT_IDENTIFICATION_ALGORITHM
    Default value: Empty string
    Description: The endpoint identification algorithm to validate the server hostname using the server certificate.
    
    Name:  KAFKASTORE_SSL_KEY_PASSWORD
    Default value: password
    Description: Kafkastore key password
    
    Name:  KAFKASTORE_SSL_KEYSTORE_LOCATION 
    Default value: /u01/cnfkfk/etc/ssl/kafka-broker-0.keystore.jks
    Description: Kafkastore SSL keystore location 
    
    Name:  KAFKASTORE_SSL_KEYSTORE_PASSWORD 
    Default value: password
    Description: Kafkastore SSL keystore password 
    
    Name:  KAFKASTORE_SSL_TRUSTSTORE_LOCATION 
    Default value: /u01/cnfkfk/etc/ssl/kafka.truststore.jks
    Description: Kafkastore SSL truststore location
    
    Name:  KAFKASTORE_SSL_TRUSTSTORE_PASSWORD
    Default value: password
    Description: Kafkastore SSL truststore password    

    Name:  KAFKASTORE_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM 
    Default value: Empty string
    Description: The endpoint identification algorithm to validate the kafka server hostname using the server certificate.
        
    Name:  KAFKASTORE_BOOTSTRAP_SERVERS 
    Default value: test-kafka.default.svc.cluster.local:9092
    Description: Kafka broker endpoint 
   
    Name:  KAFKASTORE_TOPIC 
    Default value: _schemas
    Description: The durable single partition topic that acts as the durable log for the data.
        
    Name:   KAFKASTORE_SECURITY_PROTOCOL  
    Default value: SASL_SSL
    Description: The security protocol to use when connecting with Kafka, the underlying persistent storage.
    
    Name:   INTER_INSTANCE_PROTOCOL  
    Default value: http
    Description: The protocol used while making calls between the instances of Schema Registry.
    
    Name:   ACCESS_CONTROL_ALLOW_METHODS  
    Default value: GET,POST,PUT,DELETE,OPTIONS,HEAD
    Description: Set value to Jetty Access-Control-Allow-Origin header for specified methods.
       
    Name:  ACCESS_CONTROL_ALLOW_ORIGIN
    Default value: *
    Description: Set value for Jetty `Access-Control-Allow-Origin` header
     
    Name:   SCHEMA_COMPATIBILITY_LEVEL   
    Default value: full
    Description: The schema compatibility type.
    
    Name:   SCHEMA_REGISTRY_JMX_OPTS   
    Default value: "-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.rmi.port=8080 -Djava.rmi.server.hostname=schema-registry-0 -javaagent:/u01/cnfkfk/etc/schema-registry/jmx_prometheus_javaagent-0.20.0.jar=8080:/u01/cnfkfk/etc/schema-registry/jmx-schema-registry-prometheus.yml"
    Description: JMX options. Use this variable to override the default JMX options

    Name:   SCHEMA_REGISTRY_JMX_ENABLED   
    Default value: None
    Description: Whether JMX should be enabled or not.

    Name:   SCHEMA_REGISTRY_HOST_NAME   
    Default value: Default hostname of the container.
    Description: Hostname of the schema registry server.         

    Name:   SCHEMA_REGISTRY_JMX_HOSTNAME  
    Default value: Default hostname of the container.
    Description: JMX Hostname of the schema registry server. 

    Name:   SCHEMA_REGISTRY_JMX_PORT 
    Default value: 8080
    Description: Schema registry JMX port.


### Kubernetes


export SCHEMA_REGISTRY_HOST_NAME
       env:
        # https://docs.confluent.io/6.0.0/schema-registry/docs/config.html#host-name
        - name: SCHEMA_REGISTRY_HOST_NAME
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
#### Test

$ curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" --data '{"schema": "{\"type\":\"record\",\"name\":\"Payment\",\"namespace\":\"io.confluent.examples.clients.basicavro\",\"fields\":[{\"name\":\"id\",\"type\":\"string\"},{\"name\":\"amount\",\"type\":\"double\"}]}"}' http://schema-registry-0:8081/subjects/test-value/versions
{"id":1}

$ curl -s "http://schema-registry-0:8081/subjects/" | jq
[
  "test-value"
]

$ curl -s "http://schema-registry-0:8081/subjects/test-value/versions/1"|jq '.'
{
  "subject": "test-value",
  "version": 1,
  "id": 1,
  "schema": "{\"type\":\"record\",\"name\":\"Payment\",\"namespace\":\"io.confluent.examples.clients.basicavro\",\"fields\":[{\"name\":\"id\",\"type\":\"string\"},{\"name\":\"amount\",\"type\":\"double\"}]}"
}


<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE3OTk4Nzc0MDksLTE4NzYyMzg0NzMsLT
MzOTQ1Mjk1OCwtMTU0ODQwMzU5MiwxMTY3MjQzMzM3LDEwMzY1
NDI3MDgsMzAxMjQ5NTgzLC0xMDkwNjcyNzQzLDE2NjY4MDM5ND
AsLTIwOTMyODc2ODUsMTA2NDEyOTE4NSwtMjAyNjE0NzM4Niwy
NzI2MjEzNzAsNzg4MTY4MzAyLDQ4MjIyNjU1OCwxNTUzMzY5NT
c3XX0=
-->