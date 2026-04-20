# Eurocertifica Flutter

Aplicação de cursos convertida para Flutter com uma estrutura inspirada em Clean Architecture.

## Estrutura

- `lib/core`: tema e elementos transversais.
- `lib/features/learning/domain`: entidades, contratos e casos de uso.
- `lib/features/learning/data`: seed de cursos, modelos JSON e persistência local.
- `lib/features/learning/presentation`: controlador, telas e widgets.

## Rodar

```bash
flutter pub get
flutter run -d chrome
```

## Validar

```bash
flutter analyze
flutter test
```
