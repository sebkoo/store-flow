# Issue states

| From        | Allowed next         | Who (from Phase 09) | Extra rule                   |
| ------------|----------------------|---------------------|------------------------------|
| OPEN        | ASSIGNED             | MANAGER, ADMIN      | `assigneeId` is required     |
| ASSIGNED    | IN_PROGRESS, OPEN    | assignee / MANAGER  | back to OPEN clears assignee |
| IN_PROGRESS | RESOLVED             | assignee / MANAGER  |                              |
| RESOLVED    | (none - final state) |                     |                              |

Any other move is refused with `409 INVALID_TRANSITION`.
If the issue changed between reading and writing, answer `409 CONFLICT`.
