
prep:
	git clone https://github.com/delta-io/kafka-delta-ingest.git

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down -v

wait:
	docker logs -f cassandra 2>&1 | grep -i -m 1 -e 'polling' -e 'exception'
	docker logs -f connect 2>&1 | grep -i -m 1 -e 'finished' -e 'exception'

all: down build up wait

#docker exec -it spark spark-sql -f /home/iceberg/query.sql