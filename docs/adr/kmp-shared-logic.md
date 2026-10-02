# ADR: Kotlin Multi-platform for the shared rules, with native screens

- Status: Accepted
- Date: 2026-10-01 · Phase 07

## Context

The issue shape and the title rule exist twice: in TypeScript (the API) and in Swift (the app).
An Android app adds a third copy, and copies drift: two phones can disagree about one issue.

## Decision

A Kotlin Multi-platform module, `shared`, holds the issue models, the rules, the validation and the JSON contract.
iOS uses it as the framework `StoreFlowShared`.
The screens stay native: SwiftUI on iOS, and Jetpack Compose on Android.

## Reason

One implementation and one test suite for the behavior that must match on both phones.
Swift stays for the screens and for all iOS integration.

## Trade-offs

A new language and a new build tool (Gradle), and an Xcode build step for the framework.
Swift sees the Kotlin types through an interop layer, which feels less natural than Swift.

## Rejected alternatives

- A copy of the rules in each app: every change is three changes, and one gets forgotten.
- One shared UI (Compose Multi-platform, Flutter): the screens stop being native.
- Rules only on the server: no right buttons on the phone, and no offline work later.
