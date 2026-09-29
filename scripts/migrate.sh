#!/usr/bin/env bash
set -euo pipefail 
cd "$(dirname "$0")/.."

psql_run() {
  docker compose exec -T postgres psql -U storeflow -d storeflow -v ON_ERROR_STOP=1 -q "$@"
}

psql_run -c "create table if not exists schema_migrations (filename text primary key, applied_at timestamptz not null default now());"

for file in db/migrations/*.sql; do
  name=$(basename "$file")
  applied=$(psql_run -tA -c "select 1 from schema_migrations where filename = '$name'")
  if [ "$applied" = "1" ]; then
    echo "skip $name"
    continue
  fi
  echo "apply $name"
  { echo "BEGIN;"; cat "$file"; echo "insert into schema_migrations (filename) values ('$name');"; echo "commit;"; } | psql_run
done
echo "migrations are up to date"