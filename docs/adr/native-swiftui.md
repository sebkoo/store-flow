# ADR: A native iPhone app in SwiftUI

- Status: Accepted
- Date: 2026-09-30 · Phase 06

## Context

Associates hold an iPhone all day on the shop floor, often with a weak network.
My API already answers `GET` and `POST /v1/issues`, with one error shape.

## Decision

The iphone app is native: Swift and SwiftUI, with `@Observable` view models.
An `APIClient` with `async/await` and `URLSession` does all HTTP work, apart from the screens.

## Reason

Native code gets the platform features directly: accessibility, the Keychain, background work.
A fake service tests the view models without a network.

## Trade-offs

The Android app needs its own UI later, so each screen exists twice.s

## Rejected alternatives

- One cross-platform UI (Flutter, React Native): one more framework, and a less native feel.
- A web page in Safari: weak offline work and weak device features.
- UIKit: mature, but more code per screen than SwiftUI for simple lists and forms.
