
build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down -v

wait:
	docker logs --follow cassandra | grep -i -m 1 polling
	sleep 3
	docker logs cassandra | grep -i exception

all: down build up wait