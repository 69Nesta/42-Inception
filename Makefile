all : up
ARGS ?=

mkdir:
	@mkdir -p ~/goinfre/data/web_volume ~/goinfre/data/db_volume

up: mkdir
	@docker compose -f ./srcs/compose.yaml up

build:
	@docker compose -f ./srcs/compose.yaml build

down:
	@docker compose -f ./srcs/compose.yaml down -v

boom: down
	@docker compose -f ./srcs/compose.yaml down --rmi all

nuke: boom
	@docker system prune -af

re: down build up

.PHONY: run build down re
