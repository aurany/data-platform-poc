import sys
# pyspark imports
import pyspark.sql.functions as func
from pyspark.sql import SparkSession
from pyspark.sql.avro.functions import from_avro, to_avro
from pyspark.sql.types import StringType, TimestampType, IntegerType, BinaryType

# schema registry imports
from confluent_kafka.schema_registry import SchemaRegistryClient
#from confluent_kafka.schema_registry.avro import AvroDeserializer

kafka_url = "kafka:9092"
schema_registry_url = "http://schema-registry:8081"
kafka_producer_topic = "test_prefix.testdb.messages"
#kafka_analyzed_topic = "output"
schema_registry_producer_subject = f"{kafka_producer_topic}-value"
#schema_registry_analyzed_subject = f"{kafka_analyzed_topic}-value"

spark = (SparkSession
    .builder
    .appName("data-platform-poc")
    .master("spark://spark-master:7077")
    .getOrCreate()
)

spark.sparkContext.setLogLevel("ERROR")

sr = SchemaRegistryClient({'url': schema_registry_url})
messages_schema = sr.get_latest_version(schema_registry_producer_subject)

messages_df = (spark 
    .readStream
    .format("kafka")
    .option("kafka.bootstrap.servers", kafka_url)
    .option("subscribe", kafka_producer_topic)
    .option("startingOffsets", "earliest")
    .load()
)

from_avro_options = {"mode": "PERMISSIVE"}
structured_df = (messages_df
    .select(
        from_avro(
            func.expr("substring(value, 6, length(value)-5)"),
            messages_schema.schema.schema_str,
            from_avro_options
        )
        .alias("data")
    )
)

value_df = structured_df.select("data.*")

write_query = (value_df
    .writeStream
    .format("delta")
    .outputMode("append")
    .option("mergeSchema", "true")
    .option("checkpointLocation", "s3a://test/check")
    .option("path", "s3a://test/data")
    .start()
)

write_query.awaitTermination()