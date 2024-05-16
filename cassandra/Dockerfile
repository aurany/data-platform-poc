FROM cassandra:4.0.2

ARG DEBEZIUM_VERSION

RUN apt-get update && \
    apt-get install -y curl sudo  && \
    sudo apt install -y openjdk-11-jdk

ENV DEBEZIUM_VERSION=$DEBEZIUM_VERSION \
    MAVEN_CENTRAL="https://repo1.maven.org/maven2" \
    CASSANDRA_CONF_HOME=/opt/cassandra/conf \
    DEBEZIUM_HOME=/debezium

COPY cassandra.yaml $CASSANDRA_CONF_HOME

RUN mkdir $DEBEZIUM_HOME
RUN curl -fSL -o $DEBEZIUM_HOME/debezium-connector-cassandra.jar \
                 $MAVEN_CENTRAL/io/debezium/debezium-connector-cassandra-4/$DEBEZIUM_VERSION/debezium-connector-cassandra-4-$DEBEZIUM_VERSION-jar-with-dependencies.jar

COPY log4j.properties config.properties start.sh inventory.cql $DEBEZIUM_HOME/

RUN chmod +x $DEBEZIUM_HOME/start.sh &&\
    chown -R cassandra:cassandra $CASSANDRA_CONF_HOME/cassandra.yaml $DEBEZIUM_HOME

USER cassandra

RUN mkdir -p $DEBEZIUM_HOME/relocation/archive $DEBEZIUM_HOME/relocation/error
CMD $DEBEZIUM_HOME/start.sh