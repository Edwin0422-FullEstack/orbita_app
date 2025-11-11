# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Development Commands

### Code Generation
This project uses `build_runner` to generate code for Riverpod providers, Freezed models, and JSON serialization.

**Generate all code files:**
```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

**Watch mode (auto-regenerates on file changes):**
```powershell
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Running the Application
```powershell
flutter run
```

### Testing
```powershell
flutter test
```

### Linting
```powershell
flutter analyze
```

## Architecture Overview

This is a Flutter application implementing **Clean Architecture** with **Riverpod** for state management.

### Layer Structure

The codebase is organized into four main layers:

#### 1. **Domain Layer** (`lib/domain/`)
Contains business logic and is framework-agnostic.
- **Entities** (`entities/`): Pure Dart classes representing business objects (e.g., `User`). Uses Freezed for immutability.
- **Repositories** (`repositories/`): Abstract contracts defining data operations (e.g., `AuthRepository`).
- **Enums** (`enums/`): Domain-specific enumerations (e.g., `AuthStatus`).

#### 2. **Data Layer** (`lib/data/`)
Implements data access and external service communication.
- **Models** (`models/`): DTOs (Data Transfer Objects) that handle JSON serialization (e.g., `UserModel`). Includes `.toEntity()` mappers to convert DTOs to domain entities.
- **Datasources** (`datasources/`): Abstract contracts and implementations for data sources (e.g., `AuthDatasource`, `MockAuthDatasourceImpl`, `ApiAuthDatasourceImpl`).
- **Repository Implementations** (`repositories_impl/`): Concrete implementations of domain repository contracts, orchestrating datasources and mapping DTOs to entities.

#### 3. **Presentation Layer** (`lib/presentation/`)
Contains UI and state management.
- **Screens** (`screens/`): Full-page widgets organized by feature (e.g., `home/`, `login/`, `kyc/`, `loans/`).
- **Providers** (`providers/`): Riverpod state controllers and business logic for screens, organized by feature.
- **Widgets** (`widgets/`): Reusable UI components.

#### 4. **Core Layer** (`lib/core/`)
Contains cross-cutting concerns and infrastructure.
- **Router** (`router/`): GoRouter configuration with navigation logic and route guards (`app_router.dart`).
- **Theme** (`theme/`): Material 3 theme configuration (`app_theme.dart` - uses emerald/jade seed color).
- **Providers** (`providers/`): Infrastructure providers for DI (Dio, secure storage, repositories, etc.).
- **Constants** (`constants/`): App-wide constants.

### Key Architectural Patterns

#### Dependency Injection
Uses Riverpod's code generation for dependency injection. All providers are defined with `@riverpod` annotation and generated with build_runner.

#### Data Source Switching
The app supports switching between mock and real API data sources via a flag in `lib/core/providers/repository_providers.dart`:
```dart
const bool _USE_MOCK_DATA = true; // Toggle this to switch data sources
```

#### Session Management
Global session state is managed through `sessionProvider` (`lib/presentation/providers/session/session_provider.dart`), which holds the current `User` entity and persists across the app lifecycle.

#### Navigation Architecture
Uses GoRouter with `StatefulShellRoute.indexedStack` for bottom navigation tabs. The `HomeScreen` receives a `StatefulNavigationShell` and delegates navigation to GoRouter rather than managing state directly.

**Route Guard:** The router includes redirect logic that enforces authentication and KYC verification status before allowing access to protected routes.

### State Management Conventions

- **Controllers:** Feature-specific logic uses Riverpod `@riverpod` controllers (e.g., `LoginController`, `SplashController`).
- **Session Provider:** Marked with `keepAlive: true` to persist for the app lifecycle.
- **AsyncValue:** Controllers return `AsyncValue<T>` to represent loading, data, and error states.

### Data Flow

1. **UI** calls methods on Riverpod **controllers** (presentation layer)
2. **Controllers** call **repositories** (domain layer contracts)
3. **Repository implementations** call **datasources** (data layer)
4. **Datasources** fetch raw data and return **DTOs** (models)
5. **Repositories** map DTOs to **entities** using `.toEntity()` extension methods
6. **Entities** flow back to UI through controllers

### Code Generation Dependencies

Files with the following patterns are generated and should not be edited manually:
- `*.g.dart` - JSON serialization and Riverpod providers
- `*.freezed.dart` - Freezed immutable classes

Always run `build_runner` after modifying files with `@freezed`, `@riverpod`, or `@JsonSerializable` annotations.

### Authentication Flow

1. **Splash Screen:** Checks auth status via `splashController` → redirects to login or dashboard
2. **Login Screen:** Authenticates via `LoginController` → updates `sessionProvider` → GoRouter redirects based on session state
3. **KYC Flow:** Multi-step verification process (`/kyc/*` routes) required before accessing main app
4. **Session Persistence:** Uses `flutter_secure_storage` to persist auth tokens

### Feature Modules

Current feature modules include:
- **Authentication** (login, logout, session management)
- **KYC** (document scanning, selfie capture, location verification)
- **Dashboard** (home view with statistics)
- **Loans** (loan management, create new loans)
- **Clients** (client management)
- **Reports** (analytics and reporting)
