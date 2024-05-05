CREATE KEYSPACE testdb
WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1}
AND durable_writes = true;

USE testdb;

-- Due to a bug in AvroSerializer/Schema Registry
-- we have to use only one datatype, here text..
CREATE TABLE messages(
  id text PRIMARY KEY,
  message text
) WITH cdc=true;

INSERT INTO messages(id, message) VALUES ('1', 'hej');