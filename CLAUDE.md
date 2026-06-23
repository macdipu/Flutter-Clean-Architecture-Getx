# Clean Architecture GetX — Project Guide

## Stack
Flutter + GetX state management + Clean Architecture (data/domain/presentation per feature)

## Commands
```bash
flutter pub get
flutter analyze
flutter test
flutter run
flutter build apk --release
dart generate_feature.dart <snake_case_name>
```

## Environment Setup
Copy `env_example` to `.env` and fill in values. Never commit `.env`.
Config is loaded at runtime via `flutter_dotenv` (`.env` bundled as asset).
**Before production:** switch to `--dart-define-from-file=.env` compile-time injection — see README.

## Feature Generation
```bash
dart generate_feature.dart user_profile
```
After generating:
1. Update entity fields in `domain/entity/`
2. Update response DTO in `data/model/`
3. Update API endpoint URL in `data/repo_impl/xxx_http_impl.dart` (search TODO)
4. Add `AppRoutes.featureName` constant to `lib/res/routes/app_routes.dart`
5. Add `FeaturePages.routes` spread to `lib/res/routes/app_pages.dart`

## Architecture Rules (ENFORCED)

### Layer boundaries — never cross these:
- `core/` NEVER imports from `features/`
- `core/domain/` NEVER imports Flutter framework or GetX
- `features/xxx/domain/` ONLY imports `core/domain/`
- `features/xxx/data/` MAY import `core/data/` and `core/domain/`
- `features/xxx/presentation/` MAY import `core/presentation/` and feature domain

### DI rules:
- ALWAYS use `Get.find<T>()` in widget/controller field initializers (binding provides it)
- NEVER use `Get.put(Controller())` inside a widget State class
- Register with `Get.lazyPut(..., fenix: true)` in Bindings
- Global singletons (ApiClient, PreferenceCache, etc.) registered in `app_flavour.dart`

### State management:
- Async operations → use `doAction<T>()` from `BaseController`
- Initial data fetching → override `onInit()`, NOT constructor
- List updates → `RxList.assignAll()`, not `RxList.value = ...`
- Dispose TextEditingControllers in `onClose()`

### Security:
- Auth tokens stored via `flutter_secure_storage` (NOT SharedPreferences)
- Secrets via `--dart-define-from-file=.env` (NOT bundled assets)
- Never hardcode credentials, tokens, or API keys in source
- `devAutoFill` test helpers MUST be wrapped in `assert(() { ... }())`

### Code style:
- Entities in `domain/entity/` are PURE Dart — no fromJson/toJson
- DTOs in `data/model/` handle all JSON serialization
- No `!` (bang) on nullable unless provably non-null at that point
- No `print()` — use `debugPrint()` or Logger
- No comments explaining WHAT — only WHY (non-obvious constraints/workarounds)

## Project Structure
```
lib/
├── app/
│   ├── flavours/    — AppConfig (compile-time env), bootstrap DI
│   ├── shell/       — Bottom nav shell + binding
│   └── views/       — MyApp root widget
├── core/
│   ├── data/        — HTTP client, cache, DTOs
│   ├── domain/      — Failures, use case base classes, shared value objects
│   └── presentation/ — BaseController, theme, widgets, hooks
├── features/
│   └── xxx/
│       ├── data/    — model (DTO), repo_impl (http + cache)
│       ├── domain/  — entity, repo (interface), usecase
│       └── presentation/ — bindings, controller, screens
├── res/             — routes, strings, drawables
└── services/        — Platform integrations (notifications, biometrics, etc.)
```

## Known TODOs (do before production)
- [ ] Enable Firebase (`app_flavour.dart` TODO comment)
- [ ] Add `google-services.json` / `GoogleService-Info.plist`
- [ ] Replace `flutter_secure_storage` stub calls with actual secure token storage
- [ ] Write unit tests for all UseCases and repository implementations
- [ ] Add integration tests for critical flows (login, navigation)
- [ ] Configure CI/CD pipeline (GitHub Actions or Fastlane)
- [ ] Add SSL/TLS certificate pinning to `ApiClient`
- [ ] Set up crash reporting (Firebase Crashlytics)
