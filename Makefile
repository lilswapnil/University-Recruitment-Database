# Makefile for University Recruitment Database
# Shortcuts for Docker + SQL Server + Oracle + Python ETL

DOCKER_COMPOSE = docker compose -f integrations/docker-compose.yml
MSSQL_USER = sa
MSSQL_PASS = SqlServerP@ssw0rd!
MSSQL_SERVER = host.docker.internal
MSSQL_DB = university_recruitment

.PHONY: up down logs init seed etl rank clean

## 🚀 Start containers
up:
	$(DOCKER_COMPOSE) up -d

## 🛑 Stop containers
down:
	$(DOCKER_COMPOSE) down

## 📜 Show logs
logs:
	$(DOCKER_COMPOSE) logs -f

## 🗄️ Initialize SQL Server schema
init:
	docker run --rm -it \
		--add-host=host.docker.internal:host-gateway \
		-v "$$(pwd)/integrations/sqlserver/init:/scripts" \
		mcr.microsoft.com/mssql-tools \
		/opt/mssql-tools18/bin/sqlcmd -C -S $(MSSQL_SERVER) -U $(MSSQL_USER) -P "$(MSSQL_PASS)" \
		-i /scripts/01_create_db.sql

## 📤 Publish demo deltas from Oracle
seed:
	docker exec -it uni-oracle bash -lc \
	"sqlplus -s admissions/AdmissionsP@ssw0rd@localhost/XEPDB1 @/container-entrypoint-initdb.d/03_publish_demo.sql"

## 🐍 Run Python ETL
etl:
	python integrations/etl_oracle_to_sqlserver.py

## 📊 Show candidate ranking directly from SQL Server
rank:
	docker run --rm -it \
		--add-host=host.docker.internal:host-gateway \
		mcr.microsoft.com/mssql-tools \
		/opt/mssql-tools18/bin/sqlcmd -C -S $(MSSQL_SERVER) -U $(MSSQL_USER) -P "$(MSSQL_PASS)" \
		-d $(MSSQL_DB) -Q "EXEC dwh.rank_candidates;"

## 🧹 Cleanup images & volumes
clean:
	docker system prune -af --volumes
