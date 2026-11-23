up:
	@docker compose -f ./srcs/compose.yaml up

build:
	@docker compose -f ./srcs/compose.yaml build

down:
	@docker compose -f ./srcs/compose.yaml down

re: build down up

.PHONY: run build down re
