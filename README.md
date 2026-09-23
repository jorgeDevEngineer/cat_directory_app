# 🐱 Cat Directory App

Aplicación móvil desarrollada en Flutter para la prueba técnica de **Nextep Innovation**. La app interactúa con la API pública de [CatFact Ninja](https://catfact.ninja) para proporcionar un directorio interactivo de razas de gatos con soporte offline-first, paginación fluida y datos curiosos.

---

## 🧪 Pruebas Unitarias y Criterios de Calidad (F.I.R.S.T.)

Las pruebas unitarias en esta aplicación siguen estrictamente los principios de ingeniería de software sustentados en el acrónimo **F.I.R.S.T.**:

1. **Independencia (Isolated)**: Cada prueba se ejecuta de forma completamente aislada usando mocks (`mocktail`), sin depender de otros tests ni de un orden específico.
2. **Repetibilidad (Repeatable)**: Los resultados son 100% deterministas. No dependen del entorno, hora ni estado externo.
3. **Rapidez (Fast)**: Se ejecutan en milisegundos gracias al desacoplamiento de dependencias externas (red y persistencia).
4. **Autovalidación (Self-validating)**: Resultados automatizados binarios (pass/fail) sin necesidad de inspeccionar logs manualmente.
5. **Oportunidad y Enfoque (Timely)**: Desarrolladas junto a la lógica de negocio, enfocadas en una sola unidad funcional a la vez.

> ⚠️ **Regla de mantenimiento**: Cualquier test unitario que no cumpla con estas características (flaky, lento, o acoplado) debe ser refactorizado o eliminado para conservar la integridad del pipeline de CI/CD.

### 🚀 Cómo ejecutar la suite de pruebas:

Para ejecutar todas las pruebas unitarias del proyecto:

```bash
flutter test
```

Para ejecutar un archivo de pruebas específico:

```bash
# Ejemplo: Pruebas de modelos de datos (Fase 1)
flutter test test/features/breeds/data/models/models_test.dart

# Ejemplo: Pruebas del cliente de red y excepciones (Fase 2)
flutter test test/core/network/api_client.dart
```

---

## 🏗️ Arquitectura y Estructura

Clean Architecture por Features:
- `lib/app/`: Configuración global, temas y rutas.
- `lib/core/`: Capa transversal (red, caché, inyección de dependencias, utilidades).
- `lib/features/`: Módulos funcionales de la app (`breeds`, `breed_detail`, `splash`).
