CREATE KEYSPACE testdb
WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1}
AND durable_writes = true;

USE testdb;

CREATE TABLE products(
  id text PRIMARY KEY,
  name text
) WITH cdc=true;

INSERT INTO products(id, name) VALUES ('1', 'test');