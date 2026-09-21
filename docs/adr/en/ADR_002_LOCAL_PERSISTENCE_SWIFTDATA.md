---
title: "ADR-002: Local Persistence with SwiftData"
category: adr
lang: en
version: 1.0
last_updated: 2026-09-20
audience: architect
related:
  - ADR_001_APP_ARCHITECTURE.md
---

# ADR-002: Local Persistence with SwiftData

*Tasks are stored only on the device with SwiftData, with no backend and no accounts.*

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

The MVP has one entity and needs no sync. The project is for learning and portfolio use, so avoiding servers, cost and account management keeps the scope small.

## Decision

Persist data locally with **SwiftData**, with a single `TodoItem` model:

| Field | Type | Notes |
| ----- | ---- | ----- |
| `title` | String | Required |
| `notes` | String | Optional text |
| `dueDate` | Date? | Optional. No date, no reminder |
| `priority` | Enum | Low (default), medium, high |
| `isCompleted` | Bool | Completed tasks are hidden from the main view |
| `createdAt` | Date | Used as a sort tiebreaker |

## Consequences

### Positive

- No backend, no cost, no account handling.
- `@Query` fits the view layer directly.
- CloudKit sync and widgets can reuse the same container later.

### Negative

- Data exists only on the device.
- Deleting the app deletes the data.

### Risks

- Future model changes: keep the model simple and add versioned schemas if it grows.

## Alternatives Considered

### Core Data

Discarded because SwiftData covers the need with less code. It can be revisited if learning Core Data becomes a goal.

### Custom backend

Discarded because it adds cost and maintenance with no MVP benefit.

## Related Documents

- [ADR-001: App Architecture](ADR_001_APP_ARCHITECTURE.md)
