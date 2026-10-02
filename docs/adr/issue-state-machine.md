# ADR: [the decision, in a few words]

- Status: Accepted
- Date: 2026-09-29 · Phase 05

## Context

Issues move OPEN → ASSIGNED → IN_PROGRESS → RESOLVED, and back from ASSIGNED to OPEN
Today any client can send any status, and two people can press a button at the same moment.

## Decision

One transition table in code lists the allowed moves, and a pure function checks each move.
Every other move gets `409 INVALID_TRANSITION`.
The UPDATE runs only if the status is still the one that the client saw; else `409 CONFLICT`.

## Reason

The data never shows an impossible history, such as RESOLVED without ASSIGNED.
Two clicks at the same moment cannot both win, and each client gets a clear answer.

## Trade-offs

A new status changes the table, the tests and every client that shows buttons.

## Rejected alternatives

- A free `status` field: any client can write any status.
- Rules only in the app: `curl` has no buttons.
- A workflow engine library: far too big for four states.
