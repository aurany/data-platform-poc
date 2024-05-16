#!/bin/sh

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Removing logfiles..."
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
rm -rf /opt/cassandra/logs/system.log
rm -rf /debezium/debezium.log

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Starting Cassandra..."
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
sh /opt/cassandra/bin/cassandra -f &

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Waiting for cassandra logfile to be created..."
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
while ! ls /opt/cassandra/logs | grep -q system.log
do
  sleep 1
done;

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Waiting for Cassandra to be ready..."
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
until cqlsh -e 'describe cluster' ; do
    sleep 1
done

#echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#echo "Creating tables..."
#echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#cqlsh -f /debezium/inventory.cql

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Starting Debezium..."
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
java \
    -Dlog4j.debug \
    -Dlog4j.configuration=file:$DEBEZIUM_HOME/log4j.properties \
    --add-exports java.base/jdk.internal.misc=ALL-UNNAMED \
    --add-exports java.base/jdk.internal.ref=ALL-UNNAMED \
    --add-exports java.base/sun.nio.ch=ALL-UNNAMED \
    --add-exports java.management.rmi/com.sun.jmx.remote.internal.rmi=ALL-UNNAMED \
    --add-exports java.rmi/sun.rmi.registry=ALL-UNNAMED \
    --add-exports java.rmi/sun.rmi.server=ALL-UNNAMED \
    --add-exports java.sql/java.sql=ALL-UNNAMED \
    --add-opens java.base/java.lang.module=ALL-UNNAMED \
    --add-opens java.base/jdk.internal.loader=ALL-UNNAMED \
    --add-opens java.base/jdk.internal.ref=ALL-UNNAMED \
    --add-opens java.base/jdk.internal.reflect=ALL-UNNAMED \
    --add-opens java.base/jdk.internal.math=ALL-UNNAMED \
    --add-opens java.base/jdk.internal.module=ALL-UNNAMED \
    --add-opens java.base/jdk.internal.util.jar=ALL-UNNAMED \
    --add-opens=java.base/sun.nio.ch=ALL-UNNAMED \
    --add-opens jdk.management/com.sun.management.internal=ALL-UNNAMED \
    --add-opens=java.base/java.io=ALL-UNNAMED \
    -jar $DEBEZIUM_HOME/debezium-connector-cassandra.jar \
    $DEBEZIUM_HOME/config.properties