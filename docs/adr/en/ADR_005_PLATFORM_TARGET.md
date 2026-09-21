---
title: "ADR-005: Platform Target"
category: adr
lang: en
version: 1.0
last_updated: 2026-09-20
audience: architect
related:
  - ADR_001_APP_ARCHITECTURE.md
---

# ADR-005: Platform Target

*The app targets iPhone and iPad, with iOS 26 as the minimum version and Swift 6.2 or later.*

## Table of Contents

- [Status](#status)
- [Context](#context)
- [Decision](#decision)
- [Consequences](#consequences)
  - [Positive](#positive)
  - [Negative](#negative)
  - [Risks](#risks)
- [Alternatives Considered](#alternatives-considered)
- [Related Documents](#related-documents)

## Status

Proposed

## Context

The project is for learning and portfolio use. The installed `swiftui-pro` skill assumes iOS 26 and Swift 6.2 as the defaults for new apps.

## Decision

- Device: **iPhone and iPad** (product owner decision, 2026-09-20; replaces "iPhone only").
- Language: **Spanish only**, including text, dates and times.
- Minimum version: **iOS 26**.
- Language: **Swift 6.2 or later** with modern concurrency.
- UI: native SwiftUI components with the iOS 26 visual style, automatic light and dark themes, Dynamic Type and VoiceOver support.
- No UIKit unless a need is proven, and no third-party frameworks without approval.

## Consequences

### Positive

- Access to the newest APIs with no compatibility code.
- Consistent with the `swiftui-pro` review rules.

### Negative

- Excludes devices that cannot run iOS 26.
- Every screen must be checked on iPad (regular width, orientations, keyboard and pointer).

### Risks

- No iPad simulator is installed in the current environment; one must be installed to verify the layout.
- Tooling versions: the exact Xcode version is decided when the development environment is defined, and needs the product owner's approval.

## Alternatives Considered

### iPhone only

The initial decision, to avoid adaptive layout work in the MVP. Discarded because the product owner wants the app to work on iPad as well.

### iOS 18 minimum

Discarded because it reaches more devices at the cost of newer APIs, which does not fit the goal of the project.

## Related Documents

- [ADR-001: App Architecture](ADR_001_APP_ARCHITECTURE.md)
