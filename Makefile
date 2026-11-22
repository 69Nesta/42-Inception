run:
	@docker compose -f ./srcs/compose.yaml up

build:
	@docker compose -f ./srcs/compose.yaml build

down:
	@docker compose -f ./srcs/compose.yaml down

re: build run

.PHONY: run build down re
