# ADR: One API for every client, built with Hono and Zod

- Status: Accepted
- Date: 2026-09-28 · Phase 03

## Context

My Phase 02 server checks input by hand, and its errors come in different shapes.
It has no tests, and phones and a web dashboard will call it through many endpoints.

## Decision

All clients call one API in `apps/api`, built with Hono and Zod.
Its four jobs: routing, validation, a request ID for each call, and one error shape.
The issue rules live in their own files, apart from the HTTP code.

## Reason

One place checks every request, and every client gets the same errors.
A Zod schema is the runtime check and the TypeScript type at the same time.

## Trade-offs

Hono has a smaller ecosystem than Express and less built-in structure than NextJS.
When the rules grow, that structure must come from somewhere: a question for a later day.

## Rejected alternatives

- Keep the hand-made server: routing, parsing and errors stay hand-written and untested.
- Express with a validation library: familiar, but built on Node's own request objects.
- NestJS or Spring Boot now: far more structure than one issues endpoint needs.
