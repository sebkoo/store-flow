# StoreFlow

A learning project: an omni-channel retail operations platform.
First users: store associates report problems from their phones; managers assign them.
Built one phase at a time; each technology arrives only when a problem needs it.

Status: First Slice complete (Phase 01-06).
A small issue tracker: a Hono + Zod API over PostgreSQL with a tested state machine, and a SwiftUI client.

## Run it locally

1. Check the tools: `./scripts/doctor.sh 6` (Node 22.12+, Docker Compose 2+, Xcode 26+).
2. From the repo root: `docker compose up -d --wait`, then `./scripts/migrate.sh`.
3. Start the API: `cd apps/api && npm install && npm run dev` (port 8787).
4. Open `ios/StoreFlow/StoreFlow.xcodeproj`, pick an iPhone Simulator and press ⌘R.

## Tests

- API: `npm test` in `apps/api`, with Docker running.
- iPhone ⌘U in Xcode.

## Limitations

- No login yet: every issue belongs to `store-001`.
- Lists show the newest 100 issues: a safety cap, not paging.
- The app's JSON models are typed by hand; no contract test checks them against the API.
- No security headers and no request-body limit: for local development only.

## Next steps

a shared Kotlin core, an Android app, login with roles and a manager web dashboard (Phase 07-10)
