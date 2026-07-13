# DEVELOPMENT_RULES.md

> Mandatory dev standards for `user_app` (Flutter + GetX). Verified against current codebase 2026-07-13 — corrections from the original draft are marked `[VERIFIED]`.

---

# 1. Core Principles

* Follow **Clean Architecture** (see root `CLAUDE.md` — `core/` never imports `features/`).
* Follow **Feature-First Architecture** (`lib/features/<name>/{data,domain,presentation}`).
* Keep code modular, reusable, maintainable.
* Follow **SOLID**.
* Follow **Material 3**.
* Composition over duplication.
* Consistency across the app.

---

# 2. Core Module First

`core/` is the foundation. **Search `core/` before creating anything new.**

Maximize reuse of existing:
Widgets, Components, Theme, Colors, Typography, Dimensions, Icons, Dialogs, Bottom Sheets, Animations, Extensions, Helpers, Utilities, Validators, Services, `ApiClient`, Cache Layer (`PreferenceCache`), `BaseController`, Base Screens, Base Models, Navigation, Constants, Enums, Hooks, Mixins.

Before writing new code ask: Does this exist? Can I reuse/extend/generalize it? Will another feature need it? If yes — extend, don't duplicate.

---

# 3. Reusable Component Policy

Used by 2+ features → move to `core/`. Never duplicate: Buttons, Cards, App Bars, Dialogs, Bottom Sheets, Text Fields, Loading Widgets, Empty/Error States, Validators, Extensions, Helpers, API logic, Cache logic.

---

# 4. Theme & Color Rules

100% theme-driven.

## Always use
```dart
context.colorScheme        // ThemeExtensions on BuildContext, theme_extensions.dart
context.textTheme
Theme.of(context).colorScheme
Theme.of(context).textTheme
```
`[VERIFIED]` This repo's pattern is `context.colorScheme` / `context.primary` / `context.onSurface` etc. via the `ThemeExtensions on BuildContext` extension in `lib/core/presentation/theme/theme_extensions.dart` — not `Theme.of(context).extension<T>()`. Use semantic aliases only: `primary`, `secondary`, `tertiary`, `surface`, `error`, `outline`, etc. (see that file for the full alias list).

## Never use inside widgets/screens
```dart
Colors.red / Colors.blue / Colors.black / Colors.white
Color(0xFF...)
HexColor(...)
const Color(...)
```
Hardcoded colors are only allowed inside `lib/core/presentation/theme/color_schemes.dart` and other centralized theme definition files.

`[VERIFIED — existing debt]` `flutter analyze`-style grep currently finds raw `Color(0xFF...)` / named `Colors.*` outside theme files in ~19 places (e.g. `frosted_glass.dart`, `glass_text_field.dart`, `animated_icon_button.dart`, several feature screens). Treat these as legacy debt to migrate opportunistically — do not add new ones, and prefer fixing on touch.

## Adding a new color
1. Check `color_schemes.dart` first.
2. Add a semantic alias to `theme_extensions.dart` if needed.
3. Update both light and dark `ColorScheme`s.
4. Never create local color constants in a feature file.

## Light & Dark Theme
Both must: look premium, use soft colors, be easy on the eyes, pass Material 3 contrast guidelines, avoid pure black backgrounds, use layered surfaces.

---

# 5. Typography Rules

Always `context.textTheme` / `Theme.of(context).textTheme`. No inline `TextStyle(fontSize: ...)` magic numbers.

---

# 6. Spacing Rules

`[VERIFIED]` Correct tokens for this repo (`lib/core/presentation/theme/app_dimensions.dart`):
```dart
AppDimens.spacing.s16      // or context.dimens.spacing.s16
AppDimens.radius.br12      // or context.dimens.radius.br12
AppDimens.icon.s24
AppDimens.elevation...
AppDimens.duration.ms300
```
Avoid:
```dart
SizedBox(height: 17)
EdgeInsets.all(13)
```
unless introducing a new global token in `app_dimensions.dart`.

---

# 7. Component Rules

Reuse existing components first. Before creating Button / Card / Tile / Dialog / Sheet / Input / Avatar / Badge / Loading / Empty / Error widget — search `lib/core/presentation/widgets/` (see `app_sheet/`, `buttons/`, `text_field/`, `snackbar/`, `loading_view/`, `show_dialog/`, etc.). Do not duplicate.

---

# 8. Creating a New Feature

Use the generator — do not hand-roll the skeleton:
```bash
dart generate_feature.dart <snake_case_name>
```
Rules: snake_case, lowercase start, min 2 chars, no Dart reserved words, run from repo root.

Produces (`lib/features/<name>/`):
```
data/model/<name>_list_response.dart
data/repo_impl/<name>_http_impl.dart
data/repo_impl/<name>_cache_impl.dart
domain/entity/<name>_item.dart
domain/repo/<name>_repository.dart
domain/usecase/<name>_use_case.dart
presentation/bindings/<name>_binding.dart
presentation/controller/<name>_screen_controller.dart
presentation/screens/<name>_screen.dart
presentation/pages.dart
```

After generating:
1. Add entity fields (`domain/entity`)
2. Add response fields + `fromJson` (`data/model`)
3. Set real endpoint in `data/repo_impl/<name>_http_impl.dart` (search `TODO`, replace `authorizedGet('')`)
4. Update cache serialization in `<name>_cache_impl.dart`
5. Add route constant to `lib/res/routes/app_routes.dart`
6. Spread `...XxxPages.routes` into `lib/res/routes/app_pages.dart`
7. Wire `HttpImpl → CacheImpl → Repository → UseCase → Controller` in the binding, all `Get.lazyPut(..., fenix: true)`
8. Build UI, register routes, test

Never bypass architecture layers.

---

# 9. Adding a New API to an Existing Feature

Do **not** create a new feature. Update the existing one.

```
UI → Controller → UseCase → Repository (interface) → RepoImpl (Cache→Http) → ApiClient
```

Steps: add repository method → add use case → add request/response models → implement in `XxxHttpImpl` → update `XxxCacheImpl` if cached → update controller (via `doAction<T>`) → update UI → handle loading/error/empty.

Never call `ApiClient` directly from a Controller or a widget.

---

# 10. Repository Rules

`XxxHttpImpl` — HTTP call, returns `Either<Failure, T>` (mapped from `Resource`).
`XxxCacheImpl` — wraps the Http impl, persists to `PreferenceCache` on success, is what gets registered as `XxxRepository` in the Binding.
Controllers never touch `ApiClient` or `Dio` directly.

---

# 11. Model Rules

```
API JSON → Data Model (DTO, fromJson) → Domain Entity (pure Dart) → Presentation
```
Never expose a DTO/API model directly to a widget — map to the domain entity first.

---

# 12. Controller Rules

Controllers (`extends BaseController`) only:
* Manage UI state (`status`, `isLoading`, `errorMessage`, `RxList`/`Rx` fields)
* Call UseCases via `doAction<T>(action, onSuccess, onError?)`
* Handle navigation (`Get.toNamed`, etc.)

Controllers must NOT parse JSON, call `ApiClient`/repositories directly, or hold business logic.

`devAutoFill` helpers must be wrapped in `assert(() { ... }())` so they're stripped from release builds.

---

# 13. UI Rules

Every screen should cover, where applicable: Loading (`StateStatus.loading` / `status.isBusy`), Empty (`StateStatus.empty`), Error (`StateStatus.error`), Refresh (`RefreshIndicator` / pull-to-paginate), Light + Dark theme, accessible contrast.

---

# 14. Performance Rules

Prefer: `const` widgets, lazy `Get.lazyPut(fenix: true)`, pagination (`paginating` status), `PreferenceCache` caching, reusable `core/` widgets.
Avoid: unnecessary rebuilds, duplicate API calls, duplicate cache reads, deeply nested widget trees.

---

# 15. Naming Rules

```
Feature   user_profile
Class     UserProfileScreen
Variable  userProfile
File      user_profile_screen.dart
Constant  maxRetryCount
```
Standard Dart/Effective Dart conventions otherwise.

---

# 16. Before Creating Anything

Does this exist already? Can it be reused / moved to `core/` / made generic? Does it follow the layer boundaries in `CLAUDE.md`? Does it follow the theme/dimension tokens above? Never introduce duplicate functionality.

---

# 17. Pull Request Checklist

* ✅ No hardcoded colors (`Colors.*`, `Color(0xFF...)`) outside theme files
* ✅ Uses `context.colorScheme` / `context.textTheme` / `AppDimens`
* ✅ Light & Dark mode both verified
* ✅ No duplicate widgets/logic — checked `core/` first
* ✅ Clean Architecture layers respected (UI → Controller → UseCase → Repository → RepoImpl → ApiClient)
* ✅ Controllers contain no JSON parsing / direct API calls
* ✅ Routes registered in `app_routes.dart` + `app_pages.dart`
* ✅ `devAutoFill`-style code wrapped in `assert()`
* ✅ No unnecessary dependencies
* ✅ `flutter analyze` clean

---

# 18. Session Memory (`memory.md`)

Maintain `memory.md` at repo root (`user_app/memory.md`). Log every session's tasks, phases, plans.

Per session entry, append (never overwrite):
```
## YYYY-MM-DD — <short session title>
**Task:** what asked
**Phase:** where in build order / feature lifecycle
**Plan:** steps agreed/taken
**Status:** done / in-progress / blocked
**Notes:** decisions, gotchas, follow-ups
```

Rules:
* Append-only, newest entry at bottom (chronological).
* Update at session start (log task/plan) and session end (log status/outcome).
* Do not duplicate what's derivable from git log — log intent/decisions, not diffs.
* Keep entries terse — bullet points, not prose.

---

# Golden Rules

**Architecture** — Never bypass Clean Architecture. Never skip UseCases. Never call `ApiClient` from UI/Controller directly. No business logic in Controllers.

**Reusability** — Maximize `core/` reuse. Reuse before creating. Extend before duplicating. Promote reusable code into `core/`.

**UI** — No hardcoded colors/spacing/typography. Always support Light & Dark. Keep UI consistent.

**Code Quality** — Clean, readable, small methods, no dead code, no duplication, production-ready.
