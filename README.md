# NHL SQL Practice Project

Simple SQL practice project built with PostgreSQL and Docker.

This project is focused on learning SQL basics on a small NHL-themed database. It is a training project for practicing queries, joins, aggregations, and simple data checks.

## Tech Stack

- PostgreSQL 16
- Docker Compose
- DBeaver
- SQL

## Database Tables

The project uses 5 tables:

- `teams`
- `players`
- `games`
- `goals`
- `penalties`

## Project Structure

```text
nhl-sql-project/
|
+-- docker-compose.yml
+-- sql/
    +-- 01_schema.sql
    +-- 02_seed.sql
    +-- 03_queries.sql
```

## What Is Inside

- `01_schema.sql` creates the database tables
- `02_seed.sql` inserts sample NHL data
- `03_queries.sql` contains 17 practice queries

The queries cover:

- basic `SELECT`
- `JOIN`
- `GROUP BY`
- simple game statistics
- simple QA-style data validation checks

## How to Run

Start the database:

```bash
docker compose up -d
```

Then connect in DBeaver with:

- Host: `localhost`
- Port: `5432`
- Database: `nhl_db`
- Username: `nhl`
- Password: `nhl`

After that, open `sql/03_queries.sql` and run the queries.

## Purpose

This project was made for SQL practice, mainly to improve:

- table relationships understanding
- joins
- aggregation queries
- basic database validation thinking

## Note

This is a learning project, not a production system.
