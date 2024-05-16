
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
        "topics": "debezium.the_shop.customers,debezium.the_shop.products,debezium.the_shop.orders",
        "connector.class": "io.tabular.iceberg.connect.IcebergSinkConnector",
        "iceberg.catalog.s3.endpoint": "http://minio:9000",
        "iceberg.catalog.s3.secret-access-key": "password",
        "iceberg.catalog.s3.access-key-id": "admin",
        "iceberg.catalog.s3.path-style-access": "true",
        "iceberg.catalog.uri": "http://rest:8181",
        "iceberg.catalog.warehouse": "s3://warehouse/",
        "iceberg.catalog.client.region": "us-east-1",
        "iceberg.catalog.type": "rest",
        "iceberg.control.commit.interval-ms": "1000",
        "iceberg.tables.auto-create-enabled": "true",
        "iceberg.tables.evolve-schema-enabled": "true",
        "iceberg.tables.route-field": "__table",
        "iceberg.table.the_shop.customers.route-regex": "customers",
        "iceberg.table.the_shop.products.route-regex": "products",
        "iceberg.table.the_shop.orders.route-regex": "orders",
        "iceberg.tables": "the_shop.customers,the_shop.products,the_shop.orders",
        "key.converter": "org.apache.kafka.connect.json.JsonConverter",
        "key.converter.schemas.enable": "true",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "value.converter.schemas.enable": "true",
        "transforms": "unwrap,convertTimezone",
        "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
        "transforms.unwrap.add.fields": "op,table,source.ts_ms",
        "transforms.convertTimezone.type": "io.debezium.transforms.TimezoneConverter",
        "transforms.convertTimezone.converted.timezone": "+02:00"
    }'
sleep infinity

# "transforms.ExtractField.type": "org.apache.kafka.connect.transforms.ExtractField$Value",
# "transforms.ExtractField.field": "value"

# "iceberg.tables.default-id-columns": "value",
# "iceberg.tables.cdc-field": "__op",
# "iceberg.tables.upsert-mode-enabled": "true",

# "transforms.extract.type": "org.apache.kafka.connect.transforms.ExtractField$Value",
# "transforms.extract.field": "value"

# "transforms": "flatten",
# "transforms.flatten.type": "org.apache.kafka.connect.transforms.Flatten$Value",
# "transforms.flatten.delimiter": "_"

# iceberg.tables.cdc-field
