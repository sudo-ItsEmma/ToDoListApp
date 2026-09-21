---
title: "ADR-003: Vista única de tareas"
category: adr
lang: es
version: 1.0
last_updated: 2026-09-20
audience: architect
related:
  - ADR_001_APP_ARCHITECTURE.md
  - ADR_002_LOCAL_PERSISTENCE_SWIFTDATA.md
---

# ADR-003: Vista única de tareas

*Todas las tareas viven en una sola vista con secciones automáticas, sin listas ni reordenamiento manual.*

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

Un borrador anterior organizaba las tareas en listas. El dueño del producto prefirió ver todas las tareas en una sola vista, ordenadas de forma coherente. Esto cambia el modelo de datos: no existe la entidad `List`.

## Decisión

Mostrar todas las tareas pendientes en una vista, agrupadas en secciones fijas:

| Sección | Regla |
| ------- | ----- |
| Vencidas | Fecha de vencimiento anterior a ahora |
| Hoy | Fecha de vencimiento es hoy |
| Próximas | Fecha de vencimiento posterior a hoy |
| Sin fecha | Sin fecha de vencimiento |

Dentro de cada sección se ordena por prioridad (alta primero), luego por hora de vencimiento y luego por fecha de creación.

Las tareas completadas se tachan y salen de la vista principal. Un interruptor de vista (`Pendientes` / `Completadas`) las muestra, y desde ahí se pueden reabrir.

Las reglas de secciones y orden viven en un tipo de lógica testeable (ver ADR-001).

## Consecuencias

### Positivas

- Una sola entidad y sin relaciones.
- La pantalla se ordena sola, sin configuración del usuario.
- El orden y las secciones son lógica pura y fáciles de probar.

### Negativas

- Sin reordenamiento manual, porque choca con las secciones automáticas.
- Sin agrupación por proyecto o contexto.

### Riesgos

- Una sección "Sin fecha" muy larga: revisar con búsqueda o etiquetas después del MVP.

## Alternativas consideradas

### Listas con una tarea en una sola lista

Descartada por el dueño del producto a favor de una vista única.

### Lista plana con orden elegible

Descartada a favor de secciones automáticas que no requieren configuración.

### Secciones automáticas más arrastrar

Descartada porque una posición manual puede contradecir la sección que implica la fecha.

## Documentos relacionados

- [ADR-001: Arquitectura de la app](ADR_001_APP_ARCHITECTURE.md)
- [ADR-002: Persistencia local con SwiftData](ADR_002_LOCAL_PERSISTENCE_SWIFTDATA.md)
