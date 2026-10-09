# ADR: Android's screens in androidApp, not in shared

- Status: Accepted
- Date: 2026-10-09 · Phase 08

## Context

The wizard put a Compose screen, `App.kt`, in `shared/src/commonMain`.
`shared` applies the Compose plugins, and the iPhone app inks `shared` as the framework.
My first Android screens come in this step, and iOS draws its screens with SwiftUI.

## Decision

Android's Compose screens and view models live in `androidApp`, in its `ui` package.
`shared` keeps the models, the rules and the API contract, with no Compose plugin.

## Reason

Swift never calls the Compose code, so the iOS framework no longer compiles it.
A module boundary keeps the screens out of the shared core, and the compiler checks it.

## Trade-offs

Two Gradle files change, and three template files go before the first screen.

## Rejected alternatives

- The wizard's layout: only package names keep the screens and the rules apart.
- The screens in `shared/src/androidMain`: the shared core still holds UI code.
