# Metabase + PostgreSQL with duckdb — Automated Environment

This repository provides a fully automated environment for running **Metabase** connected to a **pg_duckdb** database, including automatic configuration through the `metabase-setup.sh` script.

## Requirements

- **Docker**
- **Docker Compose v2+**

## Configuration

### 1. Configure `.env`

Set your variables for PostgreSQL and Metabase setup. Example:

- DB_ variables are for the database;
- MB_DB_ variables are for the database connection with Metabase;
- MB_ variables are information for Metabase.

```
DB_NAME=pgduckdb
DB_USER=pgduckdb
DB_PASSWORD=adminDuckdb

MB_PORT=3300
MB_JAVA_TIMEZONE=America/Sao_Paulo

MB_DB_TYPE=postgres
MB_DB_DBNAME=pgduckdb
MB_DB_PORT=5432
MB_DB_USER=pgduckdb
MB_DB_PASS=adminDuckdb
MB_DB_HOST=postgres

MB_EMAIL=admin@example.com
MB_PASSWORD=StrongPass123!
MB_FIRST_NAME=Admin
MB_LAST_NAME=User
MB_TOKEN=mysecrettoken123
```

## ▶️ Starting the Environment

Start everything with:

```bash
docker compose up
```

Metabase will start and automatically run the setup script.

## About the Setup Script

The `metabase-setup.sh` script:

1. Completes Metabase's initial setup via API  
2. Requests a session token  
3. Creates the PostgreSQL database connection inside Metabase  

The script uses `curl` to perform the setup steps programmatically.

## Accessing Metabase

Once containers are running:

**URL:** http://localhost:3300

The port 3300 is defined with `MB_PORT`.

Login using the credentials defined in `.env`:

- **Email:** `$MB_EMAIL`  
- **Password:** `$MB_PASSWORD`

## Logs

View logs for debugging:

```bash
docker compose logs -f metabase
docker compose logs -f db
```

## Stopping the Environment

To stop:

```bash
docker compose down
```

To stop and remove volumes:

```bash
docker compose down -v
```
