# Vehicle Rental System — Project Guide

A Flutter mobile app for renting vehicles (browse vehicles, book, pay, manage
profile). This guide explains how the project is organized and how the pieces
fit together, so you can read the code and start contributing quickly.

---

## 1. Tech Stack

| Area        | Choice                                                       |
| ----------- | ------------------------------------------------------------ |
| Language    | Dart (SDK `^3.11.4`)                                         |
| UI          | Flutter, Material 3                                          |
| Architecture| Clean Architecture (Feature-first) + BLoC (Business Logic Component) |
| Navigation  | `go_router` (declarative routing)                            |
| State       | `flutter_bloc` (Bloc library)                                |
| DI          | `get_it` (service locator)                                   |
| Network     | `dio` + interceptors, `connectivity_plus`                   |
| Storage     | `shared_preferences`, `flutter_secure_storage`              |
| Localization| Flutter gen-l10n (English + Khmer)                           |
| Other       | `google_maps_flutter`, `geolocator`, `table_calendar`, `image_picker`, `cached_network_image`, `google_fonts` |

---

## 2. High-Level Architecture

The project follows **Clean Architecture**, split into three concerns per feature:

```
Presentation  (screens + widgets + Blocs)   ->  UI only, no business logic
Domain        (entities, use cases, repos)  ->  pure business rules
Data          (models, datasources, repo impl) -> talks to API / storage
```

**Data flow (one direction):**

```
UI (Screen)
  -> dispatches Event to BLoC        (e.g. ToggleThemeEvent)
     -> BLoC runs Use Case / logic
        -> Use Case calls Repository
           -> Repository calls Data Source (API / local storage)
  -> BLoC emits new State
     -> UI rebuilds from State
```

The app is currently **in early development**: the folder skeleton exists, but most
data/domain layers are empty stubs. The screens, theming, localization, routing,
and DI wiring are functional.

---

## 3. Folder Structure

```
lib/
├── main.dart                      # Entry point; wires BLoCs + runs the app
├── app/
│   ├── app.dart                   # Root MaterialApp.router widget
│   ├── config/                    # Environment / app config (mostly empty)
│   ├── locale/bloc/               # LocaleBloc — language switching (en/km)
│   ├── router/                    # GoRouter setup, route paths & names
│   └── theme/                     # Colors, text styles, sizes, light/dark themes
├── core/                          # Reusable, app-agnostic code
│   ├── constants/                 # App/API/storage key constants
│   ├── errors/                    # Failure types, error handler, exceptions
│   ├── extensions/                # Context/String/Number helpers (mostly empty)
│   ├── network/                   # ApiClient (Dio wrapper), endpoints, interceptors
│   ├── storage/                   # Local + secure storage wrappers
│   ├── utils/                     # Validators, formatters, helpers (empty)
│   └── widgets/                   # Shared UI widgets (AppBar, loading, etc.)
├── feature/                       # Feature-first modules
│   ├── auth/                      # Login, signup, splash (skeleton)
│   ├── home/                      # Main shell + bottom nav + home screen
│   ├── profile/                   # Profile & settings screen (working)
│   ├── vehicle/                   # Vehicle browsing (skeleton)
│   ├── booking/                   # Booking (skeleton)
│   ├── payment/                   # Payment (skeleton)
│   └── onboarding/                # Onboarding (skeleton)
├── injection/                     # get_it registration in one place
└── l10n/                          # Generated localization (en + km)
test/
└── widget_test.dart               # Default Flutter test (not yet updated)
```

Each feature follows the same shape (shown for `auth`):

```
feature/auth/
├── data/
│   ├── datasource/                # Remote/local data source
│   ├── models/                    # JSON models
│   └── repositories/              # Repository implementations
└── presentation/
    ├── view/                      # Screens
    └── widget/                    # Feature-specific widgets
```

---

## 4. Startup Flow (`main.dart` -> `app.dart`)

1. `main()` calls `configureDependencies()` to register everything in GetIt
   (network -> services -> repositories -> use cases -> BLoCs).
2. `MultiBlocProvider` supplies `LocaleBloc` and `ThemeBloc` to the whole tree.
3. `VehicleRentalApp` (app.dart) builds `MaterialApp.router`:
   - `locale` comes from `LocaleBloc` (English or Khmer).
   - `theme` / `darkTheme` / `themeMode` come from `ThemeBloc` (light/dark).

```text
main.dart
  └─ configureDependencies()   (injection/*)
  └─ MultiBlocProvider(LocaleBloc, ThemeBloc)
       └─ VehicleRentalApp
            └─ MaterialApp.router (router: AppRouter.router)
```

---

## 5. Routing (`lib/app/router`)

- **`router_names.dart`** — `RouterNames`: string route names
  (splash, login, signup, forgotpass, onboarding, main, home, profile).
- **`app_routes.dart`** — `AppRoutes`: path strings (`"/"`, `"/home"`, `"/profile"`, ...).
- **`app_router.dart`** — `AppRouter.router`, a `GoRouter`:
  - `/`  -> `MainScreen` (the tab shell)
  - `/home` -> `HomeScreen`

Only two routes are registered today; the others are placeholders. Add new
routes by adding a `GoRoute` here.

---

## 6. Dependency Injection (`lib/injection`)

Everything is registered in `configureDependencies()` via GetIt:

| File                        | Registers                                      |
| --------------------------- | ---------------------------------------------- |
| `network_injection.dart`    | Connectivity, NetworkInfo, FlutterSecureStorage, SecureStorageService, AuthInterceptor, LoggingInterceptor, Dio, ApiClient |
| `service_injection.dart`    | App services (currently commented out)         |
| `repository_injection.dart` | Repositories (currently commented out)         |
| `use_case_injection.dart`   | Use cases (currently commented out)            |
| `bloc_injection.dart`       | `LocaleBloc`, `ThemeBloc`                      |

**Dio setup (network_injection.dart):**
- Base URL: `http://10.0.2.2:8000/api` (Android emulator -> host machine).
- 30s connect/receive/send timeouts.
- Interceptors attached: `AuthInterceptor` (adds auth token — stub) and
  `LoggingInterceptor` (stub).

> When you implement a feature, uncomment/add its registration in the matching
> file. `registerServices()` is currently an empty placeholder.

---

## 7. Networking (`lib/core/network`)

- **`api_client.dart`** — thin typed wrapper around Dio: `get`, `post`, `put`,
  `delete`. This is the only place UI touches HTTP directly.
- **`api_endpoints.dart`** — endpoint paths for auth, vehicles, customers,
  bookings (e.g. `/auth/login`, `/vehicles`).
- **`network_info.dart`** — `NetworkInfo` interface + `NetworkInfoImpl` using
  `connectivity_plus` to report whether the device is online.
- **`interceptors/auth_interceptor.dart`** — intended to attach the bearer token
  from `SecureStorageService` to requests (stub).
- **`interceptors/logging_interceptor.dart`** — intended to log requests/responses
  (stub).
- **`api_exception.dart`** — `ApiException` with message + status code.

---

## 8. Storage (`lib/core/storage`)

- **`secure_storage_service.dart`** — wraps `flutter_secure_storage` for tokens
  and credentials (constructor wired in DI; methods to be added).
- **`secure_storage.dart`** / **`local_storage.dart`** — placeholder classes for
  future storage helpers.

---

## 9. Theme — Light & Dark (`lib/app/theme`)

- **`app_colors.dart`** — the full color palette: brand colors (navy primary,
  emerald secondary, brown tertiary), neutral scale, status colors, plus a
  complete parallel **dark mode** palette (`darkBackground`, `darkSurface`,
  `darkTextPrimary`, ...).
- **`app_text_styles.dart`** — Material text styles using the **Inter** font
  (Google Fonts), defaulting to light-mode text colors.
- **`app_size.dart`** — screen size helpers (`width`, `height`, `w()`/`h()`
  percentage helpers, `isMobile`/`isTablet`/`isDesktop`).
- **`app_dimensions.dart`** — constant spacing, radius, button/input/icon sizes,
  image aspect ratios, etc.
- **`app_theme.dart`** — builds two complete `ThemeData`s:
  - `AppTheme.lightTheme` — uses light `AppColors` and `AppTextStyles`.
  - `AppTheme.darkTheme` — reuses the text styles but overrides every color
    with the dark palette via `.copyWith(...)`.
  - Both configure app bar, buttons, inputs, cards, dividers, icons, navigation
    bar, FAB, and snackbar themes.

### How theme switching works

- **`ThemeBloc`** (`theme/bloc/theme_bloc.dart`) stores a `ThemeMode`
  (light/dark) in `ThemeState`.
  - Events: `ToggleThemeEvent`, `SetLightThemeEvent`, `SetDarkThemeEvent`.
- **`app.dart`** listens to `ThemeBloc` and passes:
  ```dart
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: themeState.themeMode,
  ```
- **`profile_screen.dart`** has a `SwitchListTile` that dispatches
  `ToggleThemeEvent`, so the switch instantly flips the whole app.

> Screens should always read colors from `Theme.of(context)` (e.g.
> `Theme.of(context).colorScheme.surface`) instead of hardcoding `AppColors`,
> so they adapt automatically to both themes.

---

## 10. Localization (`lib/l10n`)

- Source files: `app_en.arb` (English) and `app_km.arb` (Khmer).
- Generate code with: `flutter gen-l10n` (enabled by `generate: true` in
  `pubspec.yaml`).
- Generated files: `app_localizations.dart`, `_en.dart`, `_km.dart`.
- Use in widgets: `AppLocalizations.of(context)!.profile`.
- Switch language via `LocaleBloc` (`ChangeLocale(Locale('km'))`), triggered from
  the Profile screen language dialog.

---

## 11. Current Screens

| Screen                                   | File                                        | Notes                                  |
| ---------------------------------------- | ------------------------------------------- | -------------------------------------- |
| Main tab shell                           | `feature/home/presentation/view/main_screen.dart` | `BottomNavigationBar` with 5 tabs (Home, Search, Booking, Alerts, Profile); Profile is implemented, others currently reuse `HomeScreen` |
| Home                                     | `feature/home/presentation/view/home_screen.dart` | Simple scaffold with custom app bar   |
| Profile & Settings                       | `feature/profile/presentation/view/profile_screen.dart` | Profile card + language dialog + dark mode switch |
| Auth Home (placeholder)                  | `feature/auth/presentation/view/home_screen.dart` | Empty scaffold                        |
| Splash (placeholder)                     | `feature/auth/presentation/view/splash_screen.dart` | Empty file                            |

---

## 12. Shared Widgets (`lib/core/widgets`)

Only `app_custom_app_bar.dart` is implemented so far:

- **`AppCustomAppBar`** — gradient `AppBar` (indigo->purple) with a fixed
  `preferredSize`. The rest (`app_button`, `app_dialog`, `app_empty`,
  `app_error`, `app_loading`, `app_text_field`) are empty placeholders waiting
  to be implemented.

---

## 13. Getting Started

```bash
# 1. Get dependencies
flutter pub get

# 2. (Re)generate localization code if .arb files change
flutter gen-l10n

# 3. Run the app
flutter run

# 4. Static analysis
flutter analyze
```

**To run against a real backend:** update the Dio `baseUrl` in
`lib/injection/network_injection.dart` (currently `http://10.0.2.2:8000/api`,
which is the host machine as seen from the Android emulator).

---

## 14. Where to Go Next (suggestions)

1. **Implement a feature end-to-end** (e.g. Vehicle list): entity -> model ->
   datasource -> repository -> use case -> BLoC -> screen, registering each
   layer in `lib/injection/*`.
2. **Finish the auth flow**: login/signup screens, `AuthInterceptor` to attach
   the token, and session handling in storage.
3. **Implement the shared widgets** in `core/widgets` (button, loading, empty,
   error, text field) and reuse them across screens.
4. **Add real routes** in `app_router.dart` for login, onboarding, vehicle
   detail, etc.
5. **Update `test/widget_test.dart`** — it still references the default counter
   app and will fail against `VehicleRentalApp`.
6. **Persist the chosen language/theme** so the setting survives app restarts
   (use `shared_preferences` or secure storage).

---

## 15. Common Pitfalls

- **Hardcoded colors in new screens** break dark mode — always use
  `Theme.of(context)` or the `ColorScheme`.
- **Adding text in Khmer/English** — add the string to both `.arb` files, run
  `flutter gen-l10n`, then use `AppLocalizations.of(context)!...`.
- **New dependencies** must be added to `pubspec.yaml`; use the existing
  versions as a guide.
- **Data-layer files are stubs** — registering a repository that imports a
  missing class will fail to compile until the class exists.
