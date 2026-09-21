---
title: "ADR-005: Plataforma objetivo"
category: adr
lang: es
version: 1.0
last_updated: 2026-09-20
audience: architect
related:
  - ADR_001_APP_ARCHITECTURE.md
---

# ADR-005: Plataforma objetivo

*La app apunta a iPhone y iPad, con iOS 26 como versión mínima y Swift 6.2 o posterior.*

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

El proyecto es de aprendizaje y portafolio. La skill instalada `swiftui-pro` asume iOS 26 y Swift 6.2 como valores por defecto para apps nuevas.

## Decisión

- Dispositivo: **iPhone y iPad** (decisión del dueño del producto, 2026-09-20; sustituye a "solo iPhone").
- Idioma: **solo español**, incluidos textos, fechas y horas.
- Versión mínima: **iOS 26**.
- Lenguaje: **Swift 6.2 o posterior** con concurrencia moderna.
- Interfaz: componentes nativos de SwiftUI con el estilo visual de iOS 26, temas claro y oscuro automáticos, y soporte de Dynamic Type y VoiceOver.
- Sin UIKit salvo que se demuestre la necesidad, y sin frameworks de terceros sin aprobación.

## Consecuencias

### Positivas

- Acceso a las APIs más nuevas sin código de compatibilidad.
- Coherente con las reglas de revisión de `swiftui-pro`.

### Negativas

- Excluye dispositivos que no pueden ejecutar iOS 26.
- Hay que revisar que cada pantalla se vea bien en iPad (ancho regular, orientaciones, teclado y ratón).

### Riesgos

- No hay simulador de iPad instalado en el entorno actual; hay que instalar uno para verificar el diseño.
- Versiones de herramientas: la versión exacta de Xcode se decide al definir el entorno de desarrollo y requiere la aprobación del dueño del producto.

## Alternativas consideradas

### Solo iPhone

Era la decisión inicial, para evitar trabajo de diseño adaptable en el MVP. Se descartó porque el dueño del producto quiere que la app funcione también en iPad.

### iOS 18 como mínimo

Descartada porque llega a más dispositivos a costa de APIs más nuevas, lo que no encaja con el objetivo del proyecto.

## Documentos relacionados

- [ADR-001: Arquitectura de la app](ADR_001_APP_ARCHITECTURE.md)
