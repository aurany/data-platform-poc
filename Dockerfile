FROM cassandra:4.0

ARG DEBEZIUM_VERSION

RUN apt-get update && \
    apt-get install -y curl sudo  && \
    sudo apt install -y openjdk-11-jdk

ENV DEBEZIUM_VERSION=$DEBEZIUM_VERSION \
    MAVEN_CENTRAL="https://repo1.maven.org/maven2" \
    CASSANDRA_YAML=/opt/cassandra/conf \
    DEBEZIUM_HOME=/debezium

COPY cassandra.yaml $CASSANDRA_YAML

RUN mkdir $DEBEZIUM_HOME
RUN curl -fSL -o $DEBEZIUM_HOME/debezium-connector-cassandra.jar \
                 $MAVEN_CENTRAL/io/debezium/debezium-connector-cassandra-4/$DEBEZIUM_VERSION/debezium-connector-cassandra-4-$DEBEZIUM_VERSION-jar-with-dependencies.jar

COPY log4j.properties config.properties inventory.cql add_messages.cql $DEBEZIUM_HOME/
COPY startup-script.sh $DEBEZIUM_HOME/startup-script.sh

RUN chmod +x $DEBEZIUM_HOME/startup-script.sh &&\
    chown -R cassandra:cassandra $CASSANDRA_YAML/cassandra.yaml $DEBEZIUM_HOME

USER cassandra

RUN mkdir -p $DEBEZIUM_HOME/relocation/archive $DEBEZIUM_HOME/relocation/error
CMD $DEBEZIUM_HOME/startup-script.sh