FROM confluentinc/cp-kafka-connect-base:7.5.3

ARG DEBEZIUM_VERSION

ENV DEBEZIUM_VERSION=$DEBEZIUM_VERSION \
    MAVEN_CENTRAL="https://repo1.maven.org/maven2" \
    DEBEZIUM_HOME=/usr/share/java

RUN curl -fSL -o $DEBEZIUM_HOME/debezium-connector-cassandra.jar \
                 $MAVEN_CENTRAL/io/debezium/debezium-connector-cassandra-4/$DEBEZIUM_VERSION/debezium-connector-cassandra-4-$DEBEZIUM_VERSION-jar-with-dependencies.jar