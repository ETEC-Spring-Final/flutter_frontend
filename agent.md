# Vehicle Rental System — AI / Contributor Guide

**Purpose of this document.** This guide is written for AI agents and new
developers who need to understand this Flutter codebase quickly and correctly.
It documents the *current, actual* state of the code (verified against the
source on 2026-09-17), including the many stubs, mock data, and known issues.
Do **not** trust `vehicle_guide.md` (it describes the older skeleton) or
`README.md` (stock Flutter boilerplate) — trust this file and the code.

> **Verify before trusting:** any time you make a change, re-check the relevant
> files. This project is mid-refactor and moving fast.

---

## 1. What This App Is

A **Flutter mobile app for renting vehicles**. Users browse vehicles (home or
explore with search/brand filters), view vehicle details (photo carousel,
specs, map location), see favorites, view booking categories, and change
language/theme in profile. After a booking is confirmed the app can request a
**Bakong (EMVCo) payment QR from the Spring Boot backend** and display/scan it
(see §11). Integration with the Spring Boot backend
(`http://10.0.2.2:8080/api`) exists for the QR flow, while **vehicle/booking
data still runs on hardcoded mock data** — no HTTP is used for vehicles/bookings
yet.

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
| QR Code        | `qr_flutter` (render generated QR), `mobile_scanner` (scan), `crypto` (md5) |
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

**Exception — the QR Code feature is fully wired:** it has a real
data/domain chain (`QrRemoteDataSource` → `QrCodeRepositoryImpl` →
`GenerateQrCode`/`CheckQrTransaction` → `QrCodeBloc`) that talks to the Spring
Boot Bakong endpoints through the DI-resolved `ApiClient`. It keeps an offline
mock fallback so the screen still renders when the backend is unreachable. See
§11 for the exact request/response shapes.

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
│   ├── constants/                # api_constants.dart (baseUrl + endpoint list)
│   ├── di/                       # all GetIt registration (see §7)
│   ├── errors/                   # failure.dart (Failure subtypes)
│   ├── extensions/               # empty
│   ├── network/                  # api_client.dart (Dio wrapper), api_endpoints.dart, network_info.dart
│   │   └── interceptors/         # auth_interceptor.dart, logging_interceptor.dart (implemented)
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
│   ├── qr_code/                  # Bakong QR payment (FULLY WIRED — see §11)
│   │   ├── data/                 # datasource + model + mapper + repository impl
│   │   ├── domain/               # entity, repository(abstract), usecase
│   │   └── presentation/         # bloc + view(qr_code_screen.dart)
│   ├── favorite/                 # empty skeleton
│   └── shared/                   # shared/widgets (moved favorites/vehicle_card shared code)
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
   - `await configureDependencies()` (from `lib/core/di/injection_container.dart`)
   - `runApp(MultiBlocProvider([LocaleBloc, ThemeBloc, AuthBloc, FavoriteBloc,
     BookingBloc, VehicleBloc, QrCodeBloc], child: CarRentalApp()))` — note all
     are resolved from `sl<...>()` except Locale/Theme.
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

**Note:** `initialLocation` is `/splash`, and `SplashScreen` routes into the
5-tab `MainScreen` (no auth gate is enforced yet).

---

## 6. Routing (`lib/app/router`)

- **`app_routes.dart`** — `AppRoutes`: path constants:
  - `/login`, `/register`, `/forgotPassword`, `/splash`, `/onboarding`
  - `/` (mainHome), `/home`, `/explore`, `/booking`, `/favorite`, `/profile`
  - `/detail` (used as `/detail/:id`)
  - `qrCode` (`/qrCode`)
- **`router_names.dart`** — `RouterNames`: names (`RouterNames.login`, ...).
- **`app_router.dart`** — `AppRouter.router` (`GoRouter`),
  `initialLocation: AppRoutes.splash` (`/splash`). Registered routes (all
  `builder: (c,s) => const XScreen()`):

| Path            | Widget                        |
| --------------- | ----------------------------- |
| `/splash`       | `SplashScreen`                |
| `/login`        | `LoginScreen`                 |
| `/register`     | `RegisterScreen`              |
| `/onboarding`   | `OnboardingScreen`            |
| `/`             | `MainScreen(index: 0)`        |
| `/notification` | `NotificationScreen`          |
| `/explore`      | `ExploreScreen`               |
| `/booking`      | `BookingScreen`               |
| `/favorite`     | `FavoriteScreen`              |
| `/profile`      | `ProfileScreen`               |
| `/detail/:id`   | `VehicleDetailScreen(vehicle: state.extra as Vehicle)` |
| `/qrCode`       | `QrCodeScreen(booking: state.extra as Booking?)` — pass a `Booking` via `extra` to auto-generate its payment QR |

**Detail route gotcha:** `VehicleDetailScreen` receives its `Vehicle` via
`GoRouterState.extra`, and URLs are `/detail/:id`. However, screens often
navigate with `MaterialPageRoute` and/or `Navigator.push` directly instead of
go_router — search before assuming a screen uses go_router.

**QR route:** `context.push(AppRoutes.qrCode, extra: booking)` is used from the
booking confirmation screen right after `BookingBloc` emits `BookingCreated`.
If `extra` is null the QR screen falls back to a manual amount/bill form.

---

## 7. Dependency Injection (`lib/core/di`)

All files declare `final sl = GetIt.instance;`. `injection_container.dart`
calls the per-feature/per-layer registration functions in order. Order matters:
`registerNetwork()` (Dio + ApiClient) must run before anything that resolves
`ApiClient`, and `qrCodeInjection()` runs before `registerBlocs()` so
`QrCodeBloc`'s use cases exist.

| File                        | Registers                                                                 |
| --------------------------- | ------------------------------------------------------------------------- |
| `network_injection.dart`    | `Connectivity`, `NetworkInfo`, `FlutterSecureStorage`, `SecureStorageService`, `AuthInterceptor`, `LoggingInterceptor`, `Dio`, `ApiClient` |
| `datasource_injection.dart` | `LocationRemoteDataSource` (others commented out)                         |
| `auth_injection.dart`       | Auth data source/repo/use cases (largely commented out)                   |
| `vehicle_injection.dart`    | Vehicle data source/repo/use cases (partly commented out)                 |
| `booking_injection.dart`    | `BookingRemoteDataSource`/`Impl`, `BookingRepository`, `GetBookings`, `CreateBooking` |
| `favorite_injection.dart`   | Favorite repository/BLoC bits                                             |
| `qr_code_injection.dart`    | `QrRemoteDataSource`/`Impl`, `QrCodeRepository`, `GenerateQrCode`, `CheckQrTransaction` |
| `service_injection.dart`    | App services (mostly commented out)                                       |
| `repository_injection.dart` | `FavoriteRepositoryImpl`, `LocationRepositoryImpl`                        |
| `use_case_injection.dart`   | `GetLocationName` (others commented out)                                  |
| `bloc_injection.dart`       | `LocaleBloc`, `ThemeBloc`, `FavoriteBloc`, `BookingBloc`, `QrCodeBloc`    |

### Dio config (`network_injection.dart`)

- `baseUrl: ApiConstants.baseUrl` = `http://10.0.2.2:8080/api` (host machine as
  seen from the Android emulator). Also defined in
  `lib/core/constants/api_constants.dart` — centralize or keep in sync.
- 10 s connect/receive/send timeouts; headers `Accept`/`Content-Type: application/json`.
- `AuthInterceptor` and `LoggingInterceptor` extend Dio's `Interceptor` and are
  added **without** casts, so resolving `Dio`/`ApiClient` from GetIt is safe now
  (the old `as Interceptor` crash has been fixed).

---

## 8. Networking (`lib/core/network`)

| File | Status |
| --- | --- |
| `api_client.dart` | Thin typed wrapper over Dio: `get/post/put/delete`. Used by the QR (and booking/location) data sources. |
| `api_endpoints.dart` | Endpoint constants: auth, vehicles, customers, bookings, **plus `/v1/bakong/qr-image`, `/v1/bakong/generate-qr`, `/v1/bakong/check-transection`**. |
| `network_info.dart` | `NetworkInfo` interface + `NetworkInfoImpl` over `connectivity_plus`. Implemented. |
| `interceptors/auth_interceptor.dart` | Implemented — extends Dio `Interceptor`, attaches bearer token from `SecureStorageService` (skips `/auth/`), 401 refresh is a documented TODO. |
| `interceptors/logging_interceptor.dart` | Implemented — logs request/response/error. |
| `api_exception.dart` | `ApiException(message, statusCode)`. |

**Real HTTP wiring today:** (1) the QR feature's
`QrRemoteDataSourceImpl` calls the Bakong endpoints through `ApiClient`; and
(2) the vehicle detail screen's pickup-location flow calls the public Nominatim
geocoding API directly through a presentation-layer service (not `ApiClient`).

**Base URL:** `ApiConstants.baseUrl` (`http://10.0.2.2:8080/api`) is used by the
DI `Dio`. Note `ApiConstants` also holds the Bakong paths under `// bakong`;
`ApiEndpoints` is the canonical list used by data sources.

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

Expected shape: a Spring Boot API at `http://10.0.2.2:8080/api` with endpoints
for auth (`/auth/login`), vehicles (`/vehicles`), customers, bookings, and the
Bakong QR endpoints (`/v1/bakong/...`). A vehicle remote datasource already
exists in `lib/feature/vehicle/data/datasource/` that does a Dio `GET /vehicles`,
plus a repository impl and mapper — **but its DI chain is not registered and the
BLoC call is commented out**. Wire it via `vehicle_injection` once the API is
live. **The QR feature (`lib/feature/qr_code/`) is the working reference** for
how a feature should be wired (datasource → repository → use case → BLoC → DI).

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

### qr_code → Bakong QR payment (FULLY WIRED) — `lib/feature/qr_code/`

The QR feature requests an EMVCo/KHQR payment code from the backend **after a
booking** and displays/scans it. It follows the full clean-architecture chain
and is the first feature wired end-to-end to `ApiClient`.

**Flow:** `PaymentScreen._payNow` → `CreateBookingEvent` → `BookingBloc` emits
`BookingCreated(booking)` → `BookingConfirmationScreen` shows a "Bakong QR
Payment" card → taps push `/qrCode` with the `Booking` as `extra` →
`QrCodeScreen` builds a `QrGenerateRequest.fromBooking(booking)` and dispatches
`GenerateQrCodeEvent` → `QrCodeBloc` calls `GenerateQrCode` use case →
`QrCodeRepositoryImpl.generateQr` → `QrRemoteDataSourceImpl.generateQr` →
`POST /v1/bakong/generate-qr` → renders the returned `qr` string with
`QrImageView`. A "I've Paid — Check" button sends the `md5` to
`CheckQrTransactionEvent` → `POST /v1/bakong/check-transection`.

**API contract (verify against backend before changing):**

Request — `POST /v1/bakong/generate-qr` (EMVCo fields):
```json
{ "currency": "KHR", "amount": 0.1, "merchantName": "string",
  "merchantCity": "string", "merchantId": "string", "acquiringBank": "string",
  "upiAccountInformation": "string", "expirationTimestamp": 0,
  "billNumber": "string", "storeLabel": "string", "terminalLabel": "string",
  "mobileNumber": "string", "purposeOfTransaction": "string",
  "merchantAlternateLanguagePreference": "string",
  "merchantNameAlternateLanguage": "string",
  "merchantCityAlternateLanguage": "string" }
```
Response:
```json
{ "qr": "string", "md5": "string" }
```
Check — `POST /v1/bakong/check-transection`:
```json
request:  { "md5": "string" }
response: { "md5": "string" }
```

**Files:**
- `domain/entity/qr_generate_request.dart` — request model; `fromBooking()` sets
  `billNumber = booking.bookingNumber`, `amount = booking.totalPrice`,
  `currency = 'KHR'`, 15-min expiry. Merchant fields are blank placeholders
  until the Bakong merchant is provisioned.
- `domain/entity/qr_generate_result.dart` — `qr` + `md5`.
- `domain/entity/qr_transaction.dart` — `md5`; `isConfirmed => md5.isNotEmpty`.
- `domain/repository/qr_code_repository.dart` — `generateQr`, `checkTransaction`.
- `domain/usecase/generate_qr_code.dart`, `domain/usecase/check_qr_transaction.dart`.
- `data/model/*` + `data/mapper/qr_mapper.dart` — models mirror the entities.
- `data/datasource/qr_remote_data_source(_impl).dart` — `ApiClient` calls;
  unwraps a possible `{ "data": ... }` envelope like the booking datasource.
- `data/repository/qr_code_repository_impl.dart` — calls the remote source and,
  on failure, falls back to a locally built payload (`crypto` md5) so the screen
  works before the backend is live. **The fallbacks are marked `TODO` and must be
  removed once the API is up.**
- `presentation/bloc/qr_code_bloc.dart` (+ `_event`/`_state`) — events:
  `GenerateQrCodeEvent(QrGenerateRequest)`, `ScanQrCodeEvent(String)`,
  `CheckQrTransactionEvent(String md5)`, `ResetQrCodeEvent`. States:
  `QrCodeInitial`, `QrCodeLoading`, `QrCodeGenerated(qrResult, request)`,
  `QrCodeScanned(content)`, `QrTransactionChecked(transaction)`,
  `QrCodeError(Failure)`. Constructor takes the two use cases.
- `presentation/view/qr_code_screen.dart` — "Receive"/"Scan" toggle; renders the
  backend `qr`; manual amount/bill form when opened without a booking; scan tab
  uses `mobile_scanner`.

**Other entry point:** Profile screen → "QR Code" menu tile
(`context.push('/qrCode')`, no booking → manual form).

**Permissions:** Android `CAMERA` (main manifest) and iOS
`NSCameraUsageDescription` are required by `mobile_scanner`.

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

- `sl` alias is redeclared per file (same `GetIt.instance`). Follow suit.
- `configureDependencies()` is `async` (main `await`s it). Most registrations
  are `registerLazySingleton`, so nothing heavy runs at boot.
- When implementing a feature: register data source → repository → use case in
  a per-feature `core/di/*_injection.dart`, call it from
  `injection_container.dart` **before** `registerBlocs()`, then add the BLoC to
  `bloc_injection.dart`. The `qr_code` feature is the reference implementation.

---

## 16. Commands

```bash
flutter pub get        # install dependencies
flutter gen-l10n       # regenerate localization after editing .arb files
flutter run            # run on device/emulator
flutter analyze        # static analysis (see baseline below)
flutter test           # WARNING: the current test fails (see Known Issues)
flutter build apk --release   # Android release (main manifest now has INTERNET + CAMERA)
```

---

## 17. Known Issues & Gotchas (read before editing)

1. **Dio interceptors are fixed** — `AuthInterceptor`/`LoggingInterceptor`
   extend Dio's `Interceptor` and are added without casts, so resolving
   `ApiClient` from GetIt no longer crashes. (This guide previously described a
   `as Interceptor` landmine that has since been resolved.)
2. **`test/widget_test.dart` is the stock counter test** and fails against
   `CarRentalApp`. Any run of `flutter test` fails today.
3. **Android main manifest has `INTERNET` + `CAMERA` permissions** (CAMERA for
   the QR scanner). iOS `Info.plist` has `NSCameraUsageDescription`. Manifest
   label ("Auto Rent Premium Car") still doesn't match the app title.
4. **Vehicle/booking data is still hardcoded mocks** (`vehicles`,
   `categories`, bookings) with external Pinterest/Facebook image URLs — offline
   behavior falls back to these. Images require internet; no local assets exist.
   The **QR feature is the exception** (real API wiring + mock fallback).
5. **Duplicate base URL** in `network_injection.dart` and
   `core/constants/api_constants.dart` — keep in sync or centralize.
6. **`VehicleBloc/Event/State`** are empty stubs; the vehicle remote
   datasource/repo are written but **not registered in DI** and BLoC calls are
   commented out. So the BLoC's data path isn't active.
7. **Roaming navigation styles:** screens mix go_router (`context.go/push`),
   `Navigator.push`, `MaterialPageRoute`, and `state.extra`. Check each file
   before assuming. Note `Navigator.pushNamed('/booking')` in
   `booking_confirmation_screen.dart` won't resolve under go_router.
8. **Analyzer baseline: 43 issues, 0 errors** (as of 2026-09-17). Includes
   unused imports in DI folder, deprecated `withOpacity` (use `withValues`),
   deprecated `Radio.groupValue`/`onChanged`,
   `library_private_types_in_public_api`, and `implementation_imports` in
   `vehicle_repository_impl.dart`. Keep `flutter analyze` at 0 errors.
9. **Locale/theme not persisted** across restarts.
10. **Auth screens are placeholders**; there is no session/login enforcement —
    the app opens into the splash → tab shell.
11. Recent refactors moved/deleted files (`bookng_screen.dart` →
    `booking_screen.dart`, favorite/vehicle-card/badge widgets moved into
    `core/widgets/` or `feature/shared/widgets/`). If a file is missing, search
    for its new home before recreating it.
12. **QR repository has temporary mock fallbacks**: `QrCodeRepositoryImpl`
    returns a locally built payload/md5 when the Bakong API call throws. Remove
    the fallbacks (search `TODO: remove the mock fallback`) once the backend is
    live, and confirm the real endpoint paths/`data` envelope with the Spring
    Boot team.

---

## 18. Where to Go Next (suggested order)

1. Confirm the Bakong response contract with the backend, then delete the
   `QrCodeRepositoryImpl` mock fallbacks and the `data`-envelope guesswork.
2. Wire the vehicle feature end-to-end: register datasource → repository →
   use case → BLoC in `core/di/`, uncomment the BLoC calls, point baseUrl at the
   real Spring Boot API.
3. Implement auth (login/signup/forgot) and persist the auth token via
   `SecureStorageService`/`AuthInterceptor`.
4. Auto-poll `CheckQrTransactionEvent` after showing a QR until payment is
   confirmed (replace the manual "I've Paid — Check" button).
5. Replace `test/widget_test.dart` with a smoke test of `CarRentalApp`.
6. Persist locale/theme (shared_preferences).
7. Add real strings to both `.arb` files as screens grow past 9 keys.