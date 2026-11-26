all : up
ARGS ?=

HOME = /home/rpetit

VOLUMES = \
	$(HOME)/data/db_volume \
	$(HOME)/data/web_volume

up: $(VOLUMES)
	@docker compose -f ./srcs/compose.yaml up $(ARGS)

start: $(VOLUMES)
	@docker compose -f ./srcs/compose.yaml start $(ARGS)

build:
	@docker compose -f ./srcs/compose.yaml build $(ARGS)

down:
	@docker compose -f ./srcs/compose.yaml down -v $(ARGS)

boom: down
	@docker compose -f ./srcs/compose.yaml down --rmi all $(ARGS)

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

erase: nuke
	rm -rf $(VOLUMES)

$(VOLUMES):
	@mkdir -p $(VOLUMES)

.PHONY: run build down re
