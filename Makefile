
prep:
	git clone https://github.com/delta-io/kafka-delta-ingest.git

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down -v

wait:
	docker logs --follow cassandra | grep -q -i -m 1 polling

all: down build up wait

#docker exec -it spark spark-sql -f /home/iceberg/query.sql