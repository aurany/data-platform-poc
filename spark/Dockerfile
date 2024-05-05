FROM bitnami/spark:3.5.1

USER root

RUN apt-get update && apt-get install -y curl

RUN curl -O https://repo1.maven.org/maven2/org/apache/spark/spark-avro_2.12/3.5.1/spark-avro_2.12-3.5.1.jar \
    && curl -O https://repo1.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/3.5.1/spark-sql-kafka-0-10_2.12-3.5.1.jar \
    && curl -O https://repo1.maven.org/maven2/org/apache/kafka/kafka-clients/3.5.1/kafka-clients-3.5.1.jar \
    && curl -O https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.4.0/delta-core_2.12-2.4.0.jar \
    && curl -O https://repo1.maven.org/maven2/io/delta/delta-storage/2.4.0/delta-storage-2.4.0.jar \
    && curl -O https://repo1.maven.org/maven2/io/delta/delta-spark_2.12/3.1.0/delta-spark_2.12-3.1.0.jar \
    && curl -O https://repo1.maven.org/maven2/org/apache/spark/spark-streaming-kafka-0-10_2.12/3.5.1/spark-streaming-kafka-0-10_2.12-3.5.1.jar \
    && curl -O https://repo1.maven.org/maven2/org/apache/spark/spark-token-provider-kafka-0-10_2.12/3.5.0/spark-token-provider-kafka-0-10_2.12-3.5.0.jar \
    && curl -O https://repo1.maven.org/maven2/org/apache/commons/commons-pool2/2.12.0/commons-pool2-2.12.0.jar \
    && curl -O https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.4.0/hadoop-aws-3.4.0.jar \
    && curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.12.710/aws-java-sdk-1.12.710.jar \
    && mv spark-avro_2.12-3.5.1.jar /opt/bitnami/spark/jars \
    && mv spark-sql-kafka-0-10_2.12-3.5.1.jar /opt/bitnami/spark/jars \
    && mv kafka-clients-3.5.1.jar /opt/bitnami/spark/jars \
    && mv delta-core_2.12-2.4.0.jar  /opt/bitnami/spark/jars \
    && mv delta-storage-2.4.0.jar /opt/bitnami/spark/jars \
    && mv delta-spark_2.12-3.1.0.jar /opt/bitnami/spark/jars \
    && mv spark-streaming-kafka-0-10_2.12-3.5.1.jar /opt/bitnami/spark/jars \
    && mv spark-token-provider-kafka-0-10_2.12-3.5.0.jar /opt/bitnami/spark/jars \
    && mv commons-pool2-2.12.0.jar /opt/bitnami/spark/jars \
    && mv hadoop-aws-3.4.0.jar /opt/bitnami/spark/jars \
    && mv aws-java-sdk-1.12.710.jar /opt/bitnami/spark/jars


COPY spark-defaults.conf /opt/bitnami/spark/conf/spark-defaults.conf

RUN pip install py4j confluent-kafka requests fastavro

WORKDIR /opt/bitnami/spark

USER 1001

# FROM docker.io/bitnami/spark:3.5

# USER root

# # Install prerequisites
# RUN apt-get update && apt-get install -y curl

# RUN curl -O https://repo1.maven.org/maven2/software/amazon/awssdk/s3/2.25.38/s3-2.25.38.jar \
#     && curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.12.708/aws-java-sdk-1.12.708.jar \
#     && curl -O https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.4.0/delta-core_2.12-2.4.0.jar \
#     && curl -O https://repo1.maven.org/maven2/io/delta/delta-storage/3.1.0/delta-storage-3.1.0.jar \
#     && curl -O https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar \
#     && curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.708/aws-java-sdk-bundle-1.12.708.jar \
#     && curl -O https://repo1.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/3.5.1/spark-sql-kafka-0-10_2.12-3.5.1.jar \
#     && mv s3-2.25.38.jar /opt/bitnami/spark/jars \
#     && mv aws-java-sdk-1.12.708.jar /opt/bitnami/spark/jars \
#     && mv delta-core_2.12-2.4.0.jar /opt/bitnami/spark/jars \
#     && mv delta-storage-3.1.0.jar /opt/bitnami/spark/jars \
#     && mv hadoop-aws-3.3.4.jar /opt/bitnami/spark/jars \
#     && mv aws-java-sdk-bundle-1.12.708.jar /opt/bitnami/spark/jars \
#     && mv spark-sql-kafka-0-10_2.12-3.5.1.jar /opt/bitnami/spark/jars

# COPY spark-defaults.conf /opt/bitnami/spark/conf/spark-defaults.conf

# # Python deps
# RUN python -m pip install -q confluent-kafka requests

# # Fix to help pyspark find py4j
# ENV PYTHONPATH=/opt/bitnami/spark/python/lib/py4j-0.10.9.7-src.zip:/opt/bitnami/spark/python/:/opt/bitnami/spark/python/: