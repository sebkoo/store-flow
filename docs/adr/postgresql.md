# ADR: PostgreSQL as the source of truth

- Status: Accepted
- Date: 2026-10-28 · Phase 04

## Context

The API keeps issues in a list in memory, and a restart loses all of them.
Later, several programs must read and write the same issues at the same time.

## Decision

PostgreSQL holds the business data of StoreFlow, starting with the issues.
It runs in Docker from one `compose.yaml` (`postgres:18`), with a named volume for the data.

## Reason

Transactions, constraints and SQL keep the data correct, also when two programs write at once.
Docker gives every machine the same database version, started with one command.

## Trade-offs

Every schema change needs a migration, and the API now needs a running database.
Docker takes memory and disk space on my Mac.

## Rejected alternatives

- A JSON file: two programs that write at the same time can damage it.
- SQLite: a database in one file, best when one program on one machine uses it.
- A document database such as MongoDB: issues have fixed fields and links, which fit tables.
