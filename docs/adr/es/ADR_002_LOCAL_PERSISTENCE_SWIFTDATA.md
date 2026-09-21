---
title: "ADR-002: Persistencia local con SwiftData"
category: adr
lang: es
version: 1.0
last_updated: 2026-09-20
audience: architect
related:
  - ADR_001_APP_ARCHITECTURE.md
---

# ADR-002: Persistencia local con SwiftData

*Las tareas se guardan solo en el dispositivo con SwiftData, sin backend ni cuentas.*

## Tabla de contenido

- [Estado](#estado)
- [Contexto](#contexto)
- [Decisión](#decisión)
- [Consecuencias](#consecuencias)
  - [Positivas](#positivas)
  - [Negativas](#negativas)
  - [Riesgos](#riesgos)
- [Alternativas consideradas](#alternativas-consideradas)
- [Documentos relacionados](#documentos-relacionados)

## Estado

Propuesto

## Contexto

El MVP tiene una entidad y no necesita sincronización. El proyecto es de aprendizaje y portafolio, así que evitar servidores, costos y manejo de cuentas mantiene el alcance pequeño.

## Decisión

Persistir los datos localmente con **SwiftData**, con un único modelo `TodoItem`:

| Campo | Tipo | Notas |
| ----- | ---- | ----- |
| `title` | String | Obligatorio |
| `notes` | String | Texto opcional |
| `dueDate` | Date? | Opcional. Sin fecha, sin recordatorio |
| `priority` | Enum | Baja (por defecto), media, alta |
| `isCompleted` | Bool | Las completadas se ocultan de la vista principal |
| `createdAt` | Date | Criterio de desempate en el orden |

## Consecuencias

### Positivas

- Sin backend, sin costo y sin manejo de cuentas.
- `@Query` encaja directamente con la capa de vistas.
- La sincronización con CloudKit y los widgets podrán reutilizar el mismo contenedor.

### Negativas

- Los datos existen solo en el dispositivo.
- Borrar la app borra los datos.

### Riesgos

- Cambios futuros en el modelo: mantenerlo simple y añadir esquemas versionados si crece.

## Alternativas consideradas

### Core Data

Descartada porque SwiftData cubre la necesidad con menos código. Se puede retomar si aprender Core Data pasa a ser un objetivo.

### Backend propio

Descartada porque añade costo y mantenimiento sin beneficio para el MVP.

## Documentos relacionados

- [ADR-001: Arquitectura de la app](ADR_001_APP_ARCHITECTURE.md)
