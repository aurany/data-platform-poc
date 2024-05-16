

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down -v

restart-cassandra:
	docker compose restart cassandra data-generator

all: down build up restart-cassandra
