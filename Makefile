COMPOSE := docker compose --env-file .env -f infra/compose/docker-compose.yml

.PHONY: up down restart update logs ps status backup restore shell psql clean

## Start (build images first time / after code change)
up:
	$(COMPOSE) up -d --build

## Stop (keeps Postgres data; use `make clean` to wipe)
down:
	$(COMPOSE) down

## Restart running services
restart:
	$(COMPOSE) restart

## Update: pull code, rebuild, restart. Pass GIT=0 to skip git pull.
update:
	[ "$(GIT)" = "0" ] || git pull --ff-only
	$(COMPOSE) up -d --build

## Tail logs (all services)
logs:
	$(COMPOSE) logs -f

## Tail one service: make logs-api / logs-worker / logs-web / logs-supervisor
logs-%:
	$(COMPOSE) logs -f $*

## Container status
ps status:
	$(COMPOSE) ps

## Backup Postgres + data/ into backups/<stamp>/
backup:
	./scripts/backup.sh

## Restore: make restore STAMP=20261012-030000
restore:
	./scripts/restore.sh backups/$(STAMP)

## Shell into a service: make shell-api
shell-%:
	$(COMPOSE) exec $* bash

## Postgres shell
psql:
	$(COMPOSE) exec postgres psql -U rakazo -d rakazo

## DANGER: stop stack and delete Postgres volume + all data
clean:
	$(COMPOSE) down -v
