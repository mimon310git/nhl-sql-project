# NHL SQL Practice Project (PostgreSQL + Docker)

This is a hands-on SQL practice project focused on strengthening relational database fundamentals using a simplified NHL data model.

The goal of this project is learning and practicing SQL concepts in a structured and realistic environment, not building a production system.

---

## Project Purpose

This project was created as a personal SQL training exercise to:

- Practice relational database design
- Improve JOIN and aggregation skills
- Work with foreign keys and constraints
- Write analytical queries
- Practice data validation queries with a QA mindset
- Work with PostgreSQL in a Docker environment

---

## Tech Stack

- PostgreSQL 16
- Docker Compose
- DBeaver
- SQL (DDL + DML)

---

## Database Model

The database models simplified NHL-related data with 5 tables:

- `teams`
- `players`
- `games`
- `goals`
- `penalties`

Concepts used:

- Primary keys
- Foreign keys
- `CHECK` constraints
- `NOT NULL` constraints
- Multi-table relationships
- Data integrity rules

---

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

---

## How to Run

### 1. Start the database

```bash
docker compose up -d
```

This loads the schema and seed data automatically from the `sql/` directory.

### 2. Connect via DBeaver

Use these connection settings:

- Host: `localhost`
- Port: `5432`
- Database: `nhl_db`
- Username: `nhl`
- Password: `nhl`

### 3. Run practice queries

Open `sql/03_queries.sql` and execute queries in DBeaver.

---

## Query Practice Includes

The project contains 30 example queries covering:

### Basic SQL

- `SELECT`
- `WHERE`
- `ORDER BY`

### Joins

- `INNER JOIN`
- `LEFT JOIN`
- Multi-table joins

### Aggregations

- `COUNT`
- `SUM`
- `GROUP BY`
- `HAVING`

### CTE

- Common Table Expressions

### Statistics Examples

- Goals per player
- Goals per team
- Penalty minutes per player
- Game results

### Data Validation Checks

- Detect invalid relationships
- Check inconsistent scores
- Validate constraints
- Detect duplicates

---

## What I Practiced

- Writing clean SQL queries
- Understanding JOIN behavior
- Handling `NULL` values
- Designing a relational schema
- Working with Dockerized PostgreSQL
- Applying a QA-style data validation mindset

---

## Notes

This is a learning-focused project created to strengthen SQL fundamentals and database understanding.

It is intentionally simple and structured for practice purposes.

---

Continuous improvement project as part of ongoing SQL skill development.
