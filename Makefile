
build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down -v

all: down build up