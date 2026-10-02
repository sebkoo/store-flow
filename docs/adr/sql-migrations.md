# ADR: Plain SQL migrations with a small runner, no ORM

- Status: Accepted
- Date: 2026-09-29 · Phase 04

## Context

The issues table needs the same shape on every machine, and every change needs a history.
The table must stay readable as plain SQL, whatever program uses it later.

## Decision

Each schema change is a numbered `.sql` file in `db/migrations`.
`scripts/migrate.sh` applies new files in order and records each one in `schema_migrations`.
The API sends plain SQL through the `pg` package.

## Reason

I see every statement that runs, and no single program owns the schema.
A fresh database, a teammate and a test all get the same tables from the same files.

## Trade-offs

More SQL to type, and no automatic mapping from rows to objects.
A migration only goes forward: an undo is a new file that I write myself.

## Rejected alternatives

- An ORM such as Prisma: the schema then lives in the models of one program.
- Changes typed by hand in `psql`: no history, and other machines never get them.
