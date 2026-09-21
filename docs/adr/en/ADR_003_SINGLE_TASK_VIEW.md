---
title: "ADR-003: Single Task View"
category: adr
lang: en
version: 1.0
last_updated: 2026-09-20
audience: architect
related:
  - ADR_001_APP_ARCHITECTURE.md
  - ADR_002_LOCAL_PERSISTENCE_SWIFTDATA.md
---

# ADR-003: Single Task View

*All tasks live in one view with automatic sections, with no lists and no manual reordering.*

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

An earlier draft organized tasks into lists. The product owner preferred to see every task in one view, ordered coherently. This changes the data model: there is no `List` entity.

## Decision

Show all pending tasks in one view, grouped into fixed sections:

| Section | Rule |
| ------- | ---- |
| Overdue | Due date before now |
| Today | Due date is today |
| Upcoming | Due date after today |
| No date | No due date |

Inside each section, sort by priority (high first), then by due time, then by creation date.

Completed tasks are struck through and hidden from the main view. A view switch (`Pending` / `Completed`) shows them, and they can be reopened there.

The sectioning and sorting rules live in a testable logic type (see ADR-001).

## Consequences

### Positive

- One entity and no relationships.
- The screen orders itself with no user configuration.
- Sorting and sectioning are pure logic and easy to test.

### Negative

- No manual reordering, because it conflicts with automatic sections.
- No grouping by project or context.

### Risks

- A long "No date" section: revisit with search or tags after the MVP.

## Alternatives Considered

### Lists with one task per list

Discarded by the product owner in favor of a single view.

### Flat list with a selectable sort order

Discarded in favor of automatic sections that need no configuration.

### Automatic sections plus manual drag

Discarded because a manual position can contradict the section a due date implies.

## Related Documents

- [ADR-001: App Architecture](ADR_001_APP_ARCHITECTURE.md)
- [ADR-002: Local Persistence with SwiftData](ADR_002_LOCAL_PERSISTENCE_SWIFTDATA.md)
