# Vehicle Rental System — AI / Contributor Guide

**Purpose of this document.** This guide is written for AI agents and new
developers who need to understand this Flutter codebase quickly and correctly.
It documents the *current, actual* state of the code (verified against the
source on 2026-08-29), including the many stubs, mock data, and known issues.
Do **not** trust `vehicle_guide.md` (it describes the older skeleton) or
`README.md` (stock Flutter boilerplate) — trust this file and the code.

> **Verify before trusting:** any time you make a change, re-check the relevant
> files. This project is mid-refactor and moving fast.

---

## 1. What This App Is

A **Flutter mobile app for renting vehicles**. Users browse vehicles (home or
explore with search/brand filters), view vehicle details (photo carousel,
specs, map location), see favorites, view booking categories, and change
language/theme in profile. One commit hint at planned integration with a
Spring Boot backend (`http://10.0.2.2:8000/api`), but **today the UI runs on
hardcoded mock data** — no HTTP is actually used for vehicles/bookings.

**Domains:** Flutter-only client. Backend API is out of this repo.

---

## 2. Tech Stack

| Area           | Choice                                                    |
| -------------- | --------------------------------------------------------- |
| Language       | Dart (SDK `^3.11.4`), Flutter (lints `^6.0.0` = Flutter ~3.35 era) |
| Architecture   | Feature-first, Clean-Architecture-aware (presentation / domain / data) |
| State          | `flutter_bloc`/`bloc` v9                                  |
| Navigation     | `go_router` v17                                           |
| DI             | `get_it` (single `GetIt.instance` used via local aliases) |
| Networking     | `dio` v5 + `connectivity_plus` (mostly unwired)           |
| Storage        | `shared_preferences`, `flutter_secure_storage` (stubs)   |
| Localization   | Flutter gen-l10n — **English + Khmer**                    |
| Responsive     | `flutter_screenutil` (`ScreenUtilInit`, designSize 375x812) |
| Maps           | `google_maps_flutter`, `flutter_map` + `latlong2`, `geolocator` |
| Other          | `cached_network_image`, `image_picker`, `table_calendar`, `carousel_slider`, `google_fonts` (Inter), `url_launcher`, `fpdart`, `intl` |

App package name: `vehicle_rental_system`, version `1.0.0+1`.

---

## 3. High-Level Architecture & Data Flow

Intended (Clean Architecture, one-directional):

```
Screen  --dispatches-->  BLoC  --calls-->  UseCase  --calls-->  Repository
                                                                    |
                                                                    v
                                                        Data Source (API / storage)
BLoC  --emits-->  State  --rebuilds-->  UI
```

**Reality today:** most data/domain layers are empty stubs or unfinished. All
vehicle/book category data is **hardcoded mock lists** shipped with the
entities (see §10). Some presentation-layer files use their own
direct HTTP (e.g. the map / pickup-location service) instead of the DI-resolved
`ApiClient`.

---

## 4. Folder Structure (lib/)

```
lib/
├── main.dart                     # Entry: configureDependencies() + MultiBlocProvider + runApp
├── app/
│   ├── app.dart                  # CarRentalApp: ScreenUtilInit > BlocBuilders > MaterialApp.router
│   ├── config/                   # empty app config / environment files
│   ├── locale/bloc/              # LocaleBloc (en/km language switching)
│   ├── router/                   # app_router.dart, app_routes.dart, router_names.dart, app_paths.dart?
│   └── theme/                    # colors, text styles, sizes, dimensions, light/dark ThemeData
│       └── bloc/                 # ThemeBloc (light/dark toggle)
├── core/
│   ├── constants/                # api_constants.dart (baseUrl), storage_keys, app_constants (mostly empty)
│   ├── errors/                   # failure.dart?, error_handler, app_exception (mostly empty)
│   ├── extensions/               # empty
│   ├── network/                  # api_client.dart (Dio wrapper), api_endpoints.dart, network_info.dart
│   │   └── interceptors/         # auth_interceptor.dart, logging_interceptor.dart (STUBS)
│   ├── storage/                  # secure_storage_service.dart, secure_storage.dart, local_storage.dart (STUBS)
│   ├── utils/                    # validators.dart, formatter.dart, helper.dart (empty)
│   └── widgets/                  # 11 shared widgets (see §12)
├── feature/                      # feature-first modules
│   ├── auth/                     # login / signup / forgot_password screens (placeholders)
│   │   └── data/                 # datasource / models / repositories (empty dirs)
│   ├── home/                     # MainScreen (5-tab shell), HomeScreen + widgets
│   │   └── presentation/data|domain|view|widgets
│   ├── profile/                  # ProfileScreen (# settings, language dialog, dark-mode switch)
│   ├── vehicle/                  # Explore/Detail/Favorite/Booking screens + entities + bloc stubs + data layer
│   │   ├── data/                 # datasource, mapper, model, repository (DATASOURCE & REPO WRITTEN, not wired)
│   │   ├── domain/               # entity(vehicle, vehicle_category), repository(abstract), usecase
│   │   └── presentation/         # bloc(stubs), service, view, widgets
│   ├── booking/                  # empty skeleton (view/widget dirs)
│   ├── payment/                  # empty skeleton
│   ├── onboarding/               # splash_screen.dart, onboarding_screen.dart (placeholders)
│   ├── favorite/                 # empty skeleton
│   └── shared/                   # shared/widgets (moved favorites/vehicle_card shared code)
├── injection/                    # all GetIt registration in 6 files (see §6)
└── l10n/                         # generated AppLocalizations (en + km)
```

The feature layering convention used (e.g. `vehicle`):

```
feature/<name>/
├── data/
│   ├── datasource/               # remote/local data sources
│   ├── mapper/ model repository/
│   └── (repositories/ impls)
├── domain/
│   ├── entity/
│   ├── repository/               # abstract interfaces
│   └── usecase/
└── presentation/
    ├── bloc/                     # Bloc/Event/State
    ├── service/                  # helpers like maps
    ├── view/                     # screens
    └── widgets/                  # feature widgets
```

---

## 5. Startup Flow

1. `main()` (`lib/main.dart`):
   - `WidgetsFlutterBinding.ensureInitialized()`
   - `await configureDependencies()` (from `lib/injection/injection_container.dart`)
   - `runApp(MultiBlocProvider([LocaleBloc, ThemeBloc], child: CarRentalApp()))`
2. `CarRentalApp` (`lib/app/app.dart`):
   - `ScreenUtilInit(designSize: Size(375,812), minTextAdapt: true, splitScreenMode: true)`
   - Nested `BlocBuilder<LocaleBloc>` + `BlocBuilder<ThemeBloc>`.
   - Builds `MaterialApp.router`:
     - `theme: AppTheme.lightTheme`, `darkTheme: AppTheme.darkTheme`,
       `themeMode: themeState.themeMode`
     - `routerConfig: AppRouter.router`
     - `locale: localeState.locale` (defaults to `Locale('en')`)
     - `supportedLocales: [Locale('en'), Locale('km')]`
     - `localizationsDelegates` incl. `AppLocalizations.delegate`

**Note:** the app boots to the 5-tab `MainScreen` at `/` (no auth/splash gate
is enforced yet).

---

## 6. Routing (`lib/app/router`)

- **`app_routes.dart`** — `AppRoutes`: path constants:
  - `/login`, `/signup`, `/forgotPassword`, `/splash`, `/onboarding`
  - `/` (mainHome), `/home`, `/explore`, `/booking`, `/favorite`, `/profile`
  - `/detail` (used as `/detail/:id`)
- **`router_names.dart`** — `RouterNames`: names (`RouterNames.login`, ...).
- **`app_router.dart`** — `AppRouter.router` (`GoRouter`),
  `initialLocation: AppRoutes.mainHome` (`/`). Registered routes (all
  `builder: (c,s) => const XScreen()`):

| Path            | Widget                        |
| --------------- | ----------------------------- |
| `/splash`       | `SplashScreen`                |
| `/login`        | `LoginScreen`                 |
| `/signup`       | `SignupScreen`                |
| `/forgotPassword` | `ForgotPasswordScreen`      |
| `/onboarding`   | `OnboardingScreen`            |
| `/`             | `MainScreen(index: 0)`        |
| `/home`         | `HomeScreen`                  |
| `/explore`      | `ExploreScreen`               |
| `/booking`      | `BookingScreen`               |
| `/favorite`     | `FavoriteScreen`              |
| `/profile`      | `ProfileScreen`               |
| `/detail/:id`   | `VehicleDetailScreen(vehicle: state.extra as Vehicle)` |

**Detail route gotcha:** `VehicleDetailScreen` receives its `Vehicle` via
`GoRouterState.extra`, and URLs are `/detail/:id`. However, screens often
navigate with `MaterialPageRoute` and/or `Navigator.push` directly instead of
go_router — search before assuming a screen uses go_router.

---

## 7. Dependency Injection (`lib/injection`)

All files declare `final GetIt getIt = GetIt.instance;` (there is no registry
singleton; `injection_container.dart` calls the 6 `register*()` functions in
order). Responsibilities:

| File                        | Registers                                                                 |
| --------------------------- | ------------------------------------------------------------------------- |
| `network_injection.dart`    | `Connectivity`, `NetworkInfo`/`NetworkInfoImpl`, `FlutterSecureStorage`, `SecureStorageService`, `AuthInterceptor`, `LoggingInterceptor`, `Dio`, `ApiClient` |
| `service_injection.dart`    | App services (mostly commented out)                                       |
| `repository_injection.dart` | Repositories (mostly commented out)                                       |
| `use_case_injection.dart`   | Use cases (mostly commented out)                                          |
| `bloc_injection.dart`       | `LocaleBloc`, `ThemeBloc`                                                 |

### Critical gotcha — Dio interceptor cast (`network_injection.dart:73-75`)

```dart
dio.interceptors.add(getIt<AuthInterceptor>() as Interceptor);
```

`AuthInterceptor` and `LoggingInterceptor` **do not extend dio's `Interceptor`**
— so `as Interceptor` throws `TypeError` the moment the DI-resolved `Dio` is
created. Today this is a **deferred landmine**: nothing in the active UI
resolves `Dio`/`ApiClient` from GetIt (screens build their own HTTP), so the
app runs. The moment vehicle/auth features start using `ApiClient`, it will
crash. Fix: implement the interceptor stubs to extend `Interceptor`, then
remove the casts.

### Dio config (network_injection.dart:62-70)

- `baseUrl: 'http://10.0.2.2:8000/api'` (host machine as seen from the Android
  emulator; **duplicated** in `lib/core/constants/api_constants.dart` — keep both
  in sync or centralize).
- 30 s connect/receive/send timeouts; headers `Accept`/`Content-Type: application/json`.

---

## 8. Networking (`lib/core/network`)

| File | Status |
| --- | --- |
| `api_client.dart` | Thin typed wrapper over Dio: `get/post/put/delete`. Implemented but **unused by active UI**. |
| `api_endpoints.dart` | 9 endpoint constants (auth login, vehicles, customers, bookings, ...). Not referenced by live code. |
| `network_info.dart` | `NetworkInfo` interface + `NetworkInfoImpl` over `connectivity_plus`. Implemented. |
| `interceptors/auth_interceptor.dart` | **Stub** — constructor only; does not attach bearer tokens, does not extend dio `Interceptor`. |
| `interceptors/logging_interceptor.dart` | **Empty class**. |
| `api_exception.dart` | `ApiException(message, statusCode)`. |

**Location (Nominatim) is the only *real* HTTP wiring:** the vehicle detail
screen's pickup-location flow calls the public Nominatim geocoding API directly
through a presentation-layer service (not through `ApiClient`).

---

## 9. Storage (`lib/core/storage`) — all stubs

- `secure_storage_service.dart` — wraps `flutter_secure_storage`; constructor
  wired in DI, no read/write methods implemented.
- `secure_storage.dart`, `local_storage.dart` — placeholder classes.

No persistence is used yet: theme/language/favorites are not persisted across
app restarts.

---

## 10. Domain Entities & Mock Data (IMPORTANT)

### `Vehicle` — `lib/feature/vehicle/domain/entity/vehicle.dart`

Immutable class with `copyWith`. All fields:

```dart
id (int), images (List<String>), brand (String), model (String),
year (int), licensePlate (String), color (String),
type (String)            // 'SUV' | 'Sedan' | 'Luxury' | 'Pickup' | 'Van' | 'Electric'
pricePerDay (double), description (String), rating (double),
feature (List<String>), latitude (double), longitude (double),
transmission (String), fuelType (String), seats (int), doors (int),
luggage (int), kilometer (double), isFavorite (bool), status (String)
```

The same file exports **`final List<Vehicle> vehicles`** at top level — the
**hardcoded mock catalog of 10 cars** (MG D60, Ford Territory, Toyota Camry,
Toyota Fortuner, Honda CR-V, Lexus RX 350, Ford Ranger, Hyundai Staria,
Toyota RAV4, Tesla Model 3). Images are external Pinterest/Facebook URLs,
coordinates are Phnom Penh locations. **This is the data source for home,
explore, and detail screens.**

### `VehicleCategory` — `lib/feature/vehicle/domain/entity/vehicle_category.dart`

```dart
id (int), name (String), image (String)
```

Same file exports `const List<VehicleCategory> categories` — **15 hardcoded
brands** (Lexus, MG, Ford, Range Rover, BMW, Ferrari, Tesla, Toyota, Mercedes,
Audi, Honda, Hyundai, Kia, Nissan, Porsche), each with an external image URL.
Used by the home "brand chips" and the explore category filter.

### Booking data

A hardcoded mock booking list (~10 bookings) and category tabs live in the
`vehicle/booking` presentation layer (`booking_card.dart`). No real booking API.

### When you add a real backend

Expected shape: a Spring Boot API at `http://10.0.2.2:8000/api` with endpoints
for auth (`/auth/login`), vehicles (`/vehicles`), customers, and bookings.
A vehicle remote datasource already exists in
`lib/feature/vehicle/data/datasource/` that does a Dio `GET /vehicles`, plus a
repository impl and mapper — **but its DI chain is not registered and the
BLoC call is commented out**. Wire it via `vehicle_injection` once the API is live.

---

## 11. Features — Screen-by-Screen

### home → `MainScreen` (the tab shell) — `lib/feature/home/presentation/view/main_screen.dart`
- `BottomNavigationBar` with **5 tabs**: Home, Search (Explore), Booking,
  Alerts (Favorite), Profile.
- Takes `index` ctor arg (the router builds it with `index: 0`).
- Explore tab is linked to `ExploreScreen` through a `GlobalKey` so the shell
  can drive filtering between tabs.

### home → `HomeScreen` — `lib/feature/home/presentation/view/home_screen.dart`
- Custom app bar + widgets: `animated_greeting.dart`, `home_banner_slider.dart`
  (carousel), brand chips row, and car lists (`popular_cars_section.dart`,
  recommended section). Everything reads from the mock `vehicles`/`categories`.

### vehicle → `ExploreScreen` — `lib/feature/vehicle/presentation/view/explore_screen.dart`
- Search field + category filter chips (`explore_category_filter.dart`), then a
  list of `vehicle_card_explore.dart` cards from the mock catalog.

### vehicle → `VehicleDetailScreen` — `lib/feature/vehicle/presentation/view/vehicle_detail_screen.dart`
- ~1061 lines. Photo carousel, specs grid, feature list, favorite toggle,
  **FlutterMap (OSM)** showing the car's lat/lng, pickup-location flow using
  Nominatim geocoding (presentation-layer `service/`), and a "Rent Now" button
  that is currently a **TODO**.
- Constructor takes a `Vehicle` directly: `VehicleDetailScreen({required this.vehicle})`.

### vehicle → `BookingScreen` — `lib/feature/vehicle/presentation/view/booking_screen.dart`
- Category tabs + hardcoded mock booking cards (`booking_card.dart`). Range
  calendar (`table_calendar`) may be used for date selection.

### vehicle → `FavoriteScreen` — `lib/feature/vehicle/presentation/view/favorite_screen.dart`
- Favorites UI, uses shared `FavoriteToggle`.

### profile → `ProfileScreen` — `lib/feature/profile/presentation/view/profile_screen.dart`
- ~446 lines. Profile header (data is **hardcoded**), **language dialog**
  (dispatches `LocaleBloc` `ChangeLocale`), **dark-mode `SwitchListTile`**
  (dispatches `ThemeBloc` `ToggleThemeEvent`).

### auth
- `LoginScreen`, `SignupScreen`, `ForgotPasswordScreen` — mostly `Placeholder`
  / bare scaffolds. Auth data-layer dirs are empty. No auth works.
- (The old `auth/home_screen.dart` and `splash_screen.dart` were deleted.)

### onboarding
- `lib/feature/onboarding/view/splash_screen.dart` and `onboarding_screen.dart`
  — placeholder screens.

### booking / payment / favorite folders
- Empty skeletons (view/widget dirs only).

### `lib/feature/vehicle/presentation/bloc/`
- `vehicle_bloc.dart`, `vehicle_state.dart`, `vehicle_event.dart` — sealed,
  empty stubs with TODOs. **Not wired into any screen.**

---

## 12. Shared Widgets (`lib/core/widgets/`)

| File | What it is |
| --- | --- |
| `app_app_bar.dart` | `AppCustomAppBar` — gradient app bar. |
| `app_back_button.dart` | Custom back/close button used by screens. |
| `app_badge.dart` | Badge widget. |
| `app_button.dart` | Reusable button. |
| `app_dialog.dart` | Dialog helper. |
| `app_empty.dart` | Empty-state widget (has an analyzer warning: `unnecessary_null_comparison` at line 45). |
| `app_error.dart` | Error-state widget. |
| `app_loading.dart` | Loading-state widget. |
| `app_text_field.dart` | Styled text field, used by auth/chat-like inputs. |
| `favorite_toggle.dart` | Heart/favorite toggle (used by detail + favorite screens). |

Feature-level shared widgets also exist: `lib/feature/vehicle/presentation/widgets/vehicle_card.dart`, `vehicle_card_explore.dart`, `explore_category_filter.dart`; `lib/feature/shared/widgets/`.

---

## 13. Theme — Light & Dark (`lib/app/theme`)

| File | Role |
| --- | --- |
| `app_colors.dart` | Full light palette (navy/emerald/brown brand colors + neutrals + status) **and** a parallel dark palette (`darkBackground`, `darkSurface`, `darkTextPrimary`, ...). |
| `app_text_styles.dart` | Material text styles on the **Inter** google font, defaulting to light colors. |
| `app_size.dart` / `app_extensions` | Screen-size helpers (`w()`, `h()`, `isMobile/isTablet/isDesktop`). |
| `app_dimensions.dart` | Spacing, radius, button/input/icon sizes, aspect ratios constants. |
| `app_theme.dart` | `AppTheme.lightTheme` and `AppTheme.darkTheme` (`ThemeData`s built with all component themes: app bar, buttons, inputs, cards, icons, nav bar, FAB, snackbar). Dark theme reuses text styles and overrides colors via `copyWith`. |
| `bloc/theme_bloc.dart` | `ThemeBloc` — `ThemeMode` in state; events `ToggleThemeEvent`, `SetLightThemeEvent`, `SetDarkThemeEvent`. |

**Convention:** always read colors via `Theme.of(context).colorScheme` /
`ThemeData` so both themes adapt. **Don't** hardcode `AppColors` into widgets.

---

## 14. Localization (`lib/l10n`, `l10n.yaml`)

- Source: `app_en.arb` (English), `app_km.arb` (Khmer) — **9 keys today**.
- `pubspec.yaml` sets `generate: true`, so `flutter gen-l10n` creates
  `app_localizations.dart` (+ `_en`/`_km`). Generated files are checked in.
- Usage: `AppLocalizations.of(context)!.someKey`.
- When you add a string: add the key to **both** .arb files, run
  `flutter gen-l10n`, then use it.
- Switching is done by `LocaleBloc` (`ChangeLocale(Locale('km'))`), triggered
  from the Profile screen language dialog.

---

## 15. Injection / GetIt — reading conventions

- `getIt` alias is redeclared per file (same `GetIt.instance`). Follow suit.
- `configureDependencies()` waits: it is `async` (main `await`s it). Current
  registrations are all `registerLazySingleton`, so nothing heavy runs at boot.
- When implementing a feature: register data source → repository → use case →
  BLoC in the matching `injection/*.dart` file, and add it to the wiring in
  `injection_container.dart` if needed.

---

## 16. Commands

```bash
flutter pub get        # install dependencies
flutter gen-l10n       # regenerate localization after editing .arb files
flutter run            # run on device/emulator
flutter analyze        # static analysis (see baseline below)
flutter test           # WARNING: the current test fails (see Known Issues)
flutter build apk --release   # Android release (networking broken — see Known Issues)
```

---

## 17. Known Issues & Gotchas (read before editing)

1. **Dio interceptor `as Interceptor` casts** (`network_injection.dart:73,75`)
   throw a `TypeError` as soon as the DI-resolved `Dio` is used, because
   `AuthInterceptor`/`LoggingInterceptor` don't implement dio's `Interceptor`.
   Deferred crash, not current startup crash — but fix it before wiring the API.
2. **`test/widget_test.dart` is the stock counter test** and fails against
   `CarRentalApp`. Any run of `flutter test` fails today.
3. **`android/app/src/main/AndroidManifest.xml` lacks the `INTERNET`
   permission** (only in debug/profile manifests) → real networking breaks in
   release builds. Also, the manifest label ("Auto Rent Premium Car") doesn't
   match the app title.
4. **All data is hardcoded mocks** (`vehicles`, `categories`, bookings) with
   external Pinterest/Facebook image URLs — offline/no-network app behavior
   falls back to these. Images require internet; no local assets exist
   (`assets/` registered dirs are empty).
5. **Duplicate base URL** in `network_injection.dart` and
   `core/constants/api_constants.dart` — keep in sync or centralize.
6. **`VehicleBloc/Event/State`** are empty stubs; the vehicle remote
   datasource/repo are written but **not registered in DI** and BLoC calls are
   commented out. So the BLoC's data path isn't active.
7. **Roaming navigation styles:** screens mix go_router (`context.go/push`),
   `Navigator.push`, `MaterialPageRoute`, and `state.extra`. Check each file
   before assuming.
8. **Analyzer baseline: 14 issues, 0 errors** (as of last run). Includes
   deprecated `withOpacity` (use `withValues`), deprecated
   `Radio.groupValue`/`onChanged`, `library_private_types_in_public_api`
   (mixing `_Widget` types in public APIs), `unimportant` infos
   (`implementation_imports` in `vehicle_repository_impl.dart`,
   `depend_on_referenced_packages` in `vehicle_bloc.dart`). Keep `flutter analyze`
   at 0 errors.
9. **Locale/theme not persisted** across restarts.
10. **Auth screens are placeholders**; there is no session/login enforcement —
    the app opens straight into the tab shell.
11. Recent refactors moved/deleted files (`bookng_screen.dart` → `booking_screen.dart`,
    favorite/vehicle-card/badge widgets moved into `core/widgets/` or
    `feature/shared/widgets/`). If a file is missing, search for its new home
    before recreating it.

---

## 18. Where to Go Next (suggested order)

1. Fix the `as Interceptor` casts + implement auth/logging interceptor stubs.
2. Wire the vehicle feature end-to-end: register datasource → repository →
   use case → BLoC in `injection/`, uncomment the BLoC calls in
   `refreshData()`-style blocks, point baseUrl at the real Spring Boot API.
3. Implement auth (login/signup/forgot) and persist the auth token via
   `SecureStorageService`/`AuthInterceptor`.
4. Add `INTERNET` permission to the main Android manifest.
5. Replace `test/widget_test.dart` with a smoke test of `CarRentalApp`.
6. Persist locale/theme (shared_preferences).
7. Add real strings to both `.arb` files as screens grow past 9 keys.