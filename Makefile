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

kvm:
	@qemu-system-x86_64 \
	-enable-kvm \
	-m 3G \
	-smp 2 \
	-cpu host \
	-hda /sgoinfre/rpetit/inception/kvm.qcow2 \
	-daemonize \
	-netdev user,id=net0,hostfwd=tcp::2222-:22 \
	-device virtio-net-pci,netdev=net0 \
	-monitor tcp:127.0.0.1:4444,server,nowait

ssh:
	ssh root@localhost -p 2222

re: down build up

.PHONY: run build down re
