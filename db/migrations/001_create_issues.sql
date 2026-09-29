create table issues (
  id uuid primary key default gen_random_uuid(),
  store_id text not null,
  title text not null check (char_length(title) between 3 and 120),
  type text not null,
  priority text not null default 'NORMAL' check (priority in ('LOW', 'NORMAL', 'HIGH')),
  status text not null default 'OPEN' check (status in ('OPEN', 'ASSIGNED', 'IN_PROGRESS', 'RESOLVED')),
  assignee_id uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_issues_store_status 
  on issues (store_id, status);