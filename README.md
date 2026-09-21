# ToDoListApp

App de lista de tareas para iPhone y iPad, hecha con SwiftUI y SwiftData. Toda la interfaz está en español y los datos se guardan solo en el dispositivo, sin cuentas ni servidor.

Es un proyecto de aprendizaje y portafolio, construido en micro-pasos pequeños y revisables, con las decisiones de arquitectura documentadas en ADRs.

## Qué hace

- **Crear, editar y borrar tareas.** Cada tarea tiene título, notas, fecha y hora de vencimiento opcionales, y prioridad (baja, media o alta). Se borra deslizando la fila.
- **Secciones automáticas** en la vista principal: Vencidas, Hoy, Próximas y Sin fecha. Dentro de cada una se ordena por prioridad, luego por hora y luego por fecha de creación.
- **Completar con animación.** Al tocar el círculo, la tarea se marca, se tacha y sale de la lista. Un menú inferior cambia entre **Pendientes** y **Completadas**, y desde ahí se pueden reabrir con la animación inversa.
- **Recordatorios locales.** Una notificación por tarea, a su fecha y hora de vencimiento. Se cancela al completar o borrar, se reprograma al cambiar la fecha y se vuelve a programar al reabrir. El permiso se pide al guardar la primera tarea con fecha, y si se deniega la app sigue funcionando y explica cómo activarlo.
- **Estilo nativo de iOS 26** (Liquid Glass), con tema claro y oscuro, fuentes dinámicas y etiquetas de accesibilidad.

## Tecnología

| Elemento | Detalle |
| -------- | ------- |
| Lenguaje | Swift 6.2 |
| Interfaz | SwiftUI |
| Persistencia | SwiftData, una sola entidad (`TodoItem`) |
| Notificaciones | `UserNotifications`, notificaciones locales |
| Pruebas | Swift Testing para la lógica, XCTest para la interfaz |
| Plataformas | iOS 26 o posterior, iPhone y iPad |
| Dependencias | Ninguna de terceros |

## Cómo ejecutarla

Necesitas **Xcode 26** o posterior.

1. Clona el repositorio y abre `ToDoListApp/ToDoListApp.xcodeproj`.
2. Elige un simulador de iPhone y pulsa `Command + R`.
3. En compilaciones **Debug**, la app carga unas tareas de ejemplo la primera vez que abre con la base de datos vacía.

Para ejecutarla en un dispositivo físico, en *Signing & Capabilities* cambia el **Team** y el **Bundle Identifier** por los tuyos.

Las notificaciones se pueden probar en el simulador: crea una tarea con fecha uno o dos minutos adelante y espera. La app muestra el banner incluso abierta.

## Pruebas

`Command + U` corre todo. Ten en cuenta que Xcode reparte las pruebas de interfaz en varios clones del simulador, por lo que verás abrirse más de un iPhone. Para compilar sin eso, usa `Command + B`.

La lógica pura (secciones, orden, etiquetas de fecha y regla de recordatorios) está cubierta con Swift Testing. Las pantallas y el acceso a notificaciones se probaron a mano en el simulador.

## Estructura

```text
.
├── ToDoListApp/                      Proyecto de Xcode
│   ├── ToDoListApp.xcodeproj
│   ├── ToDoListApp/                  Código de la app
│   │   ├── Tasks/                    Modelo, vistas y reglas de las tareas
│   │   ├── Reminders/                Regla, servicio y delegado de las notificaciones
│   │   ├── Shared/                   Datos de ejemplo para Debug y las vistas previas
│   │   └── Assets.xcassets
│   ├── ToDoListAppTests/             Pruebas de lógica (Swift Testing)
│   └── ToDoListAppUITests/           Pruebas de interfaz de la plantilla
└── docs/adr/{es,en}/                 Decisiones de arquitectura
```

## Decisiones de arquitectura

Las decisiones importantes están registradas como ADRs, en español e inglés, dentro de `docs/adr/`:

| ADR | Tema |
| --- | ---- |
| 001 | Arquitectura: SwiftUI con SwiftData y las reglas en tipos pequeños y testeables |
| 002 | Persistencia local con SwiftData |
| 003 | Vista única con secciones automáticas y vista de Completadas |
| 004 | Recordatorios locales con un único servicio que programa y cancela |
| 005 | Plataforma: iPhone y iPad, iOS 26 o posterior |

## Fuera del alcance

Listas, etiquetas, subtareas, búsqueda, recurrencia, varios recordatorios por tarea, reordenar a mano, widgets, Siri e iCloud.

## Licencia

Distribuido bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE).

## Estado

Las cuatro funcionalidades del MVP están construidas y probadas en el simulador. Pendiente: revisar el diseño en iPad y probar los recordatorios en un iPhone físico.
