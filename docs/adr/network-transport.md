# ADR: The API contract in shared Kotlin, the HTTP calls in each app

- Status: Accepted
- Date: 2026-10-09 · Phase 07

## Context

My Swift client of Phase 06 Swift knows the paths, the headers and the error shapes of the API.
Android needs the same knowledge, and copies drift.
A common KMP choice is one Ktor client in `commonMain`.

## Decision

`shared` turns each action into an `ApiRequest`, and each `ApiResponse` into models or errors.
Each app sends the requests itself: iOS with `URLSession` in Swift, Android in `androidApp` through `HttpTransport`.
`shared` depends on no HTTP library.

## Reason

Swift never awaits a Kotlin `suspend` function, an interop that Kotlin's documentation calls experimental.
both apps follow one rule: each app owns how it sends.

## Trade-offs

Each app writes its own transport, so timeouts and retries can drift apart.

## Rejected alternatives

- One Ktor client in `commonMain`: iOS then awaits Kotlin `suspend` functions.
- The Android transport in `shared/androidMain`: the shared core then holds an HTTP library.
