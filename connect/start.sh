
echo "Installing connector plugins"
confluent-hub install --no-prompt tabular/iceberg-kafka-connect:0.6.16

echo "Launching Kafka Connect worker"
/etc/confluent/docker/run & 

echo "Waiting for Kafka Connect to start listening on localhost"
while : ; do
    curl_status=$(curl -s -o /dev/null -w %{http_code} http://localhost:8083/connectors)
    echo -e $(date) "Kafka Connect listener HTTP state: " $curl_status " (waiting for 200)"
    if [ $curl_status -eq 200 ] ; then
        break
    fi
    sleep 5 
done

echo -e "Creating connector"
curl -X PUT \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' http://localhost:8083/connectors/IcebergSinkConnector/config \
    -d '{
        "tasks.max": "1",
        "topics": "test_prefix.testdb.customers,test_prefix.testdb.products",
        "connector.class": "io.tabular.iceberg.connect.IcebergSinkConnector",
        "iceberg.catalog.s3.endpoint": "http://minio:9000",
        "iceberg.catalog.s3.secret-access-key": "minio123",
        "iceberg.catalog.s3.access-key-id": "minio",
        "iceberg.catalog.s3.path-style-access": "true",
        "iceberg.catalog.uri": "http://rest:8181",
        "iceberg.catalog.warehouse": "s3a://warehouse/",
        "iceberg.catalog.client.region": "eu-west-1",
        "iceberg.catalog.type": "rest",
        "iceberg.control.commit.interval-ms": "1000",
        "iceberg.tables.auto-create-enabled": "true",
        "iceberg.tables.route-field": "payload.source.table",
        "iceberg.table.testdb.customers.route-regex": "customers",
        "iceberg.table.testdb.products.route-regex": "products",
        "iceberg.tables": "testdb.customers,testdb.products",
        "value.converter.schemas.enable": "false",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "key.converter": "org.apache.kafka.connect.storage.StringConverter",
        "schemas.enable": "false"
    }'
sleep infinity

#iceberg.tables.cdc-field