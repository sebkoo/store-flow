# ADR: One repository for StoreFlow

- Status: Accepted
- Date: 2026-09-27 · Phase 01

## Context

I am building StoreFlow alone, as a learning project.
The app and the server will change together, and I want one place for code, notes, tests, and decisions.

## Decision

Use one Git repository for the whole project.
Each part gets a folder when it arrives.

## Reason

A change that touches two parts can be reviewed and committed together.

## Trade-offs

The repository grows, and tools for different languages will live side by side.

## Rejected alternatives

- One repository per part: too much coordination for one person.
- A monorepo build system (Nx, Bazel): a big extra tool before there is anything to build.
