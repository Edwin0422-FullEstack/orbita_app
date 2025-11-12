# 🚀 WARP.md - Guía del Proyecto Orbita

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## 📋 Información del Proyecto

- **Nombre:** Orbita
- **Descripción:** Plataforma de gestión financiera con Clean Architecture + Riverpod
- **Versión:** 1.0.0+1
- **SDK:** Flutter 3.9.2+

## 📁 Estructura del Proyecto

```
orbita_app/
├── lib/
│   ├── main.dart                          # Punto de entrada de la aplicación
│   │
│   ├── core/                              # ⚙️ CORE LAYER (Infraestructura)
│   │   ├── providers/                     # Providers de DI para servicios globales
│   │   │   ├── dio_provider.dart          # Cliente HTTP (Dio)
│   │   │   ├── storage_provider.dart      # Almacenamiento seguro
│   │   │   ├── local_auth_provider.dart   # Autenticación biométrica
│   │   │   └── repository_providers.dart  # Providers de repositorios
│   │   ├── router/
│   │   │   └── app_router.dart            # Configuración de GoRouter
│   │   └── theme/
│   │       └── app_theme.dart             # Tema Material 3 (emerald/jade)
│   │
│   ├── domain/                            # 🎯 DOMAIN LAYER (Lógica de negocio)
│   │   ├── entities/                      # Entidades de dominio (Freezed)
│   │   │   └── user.dart
│   │   ├── repositories/                  # Contratos de repositorios
│   │   │   └── auth_repository.dart
│   │   └── enums/
│   │       └── auth_status.dart
│   │
│   ├── data/                              # 💾 DATA LAYER (Acceso a datos)
│   │   ├── models/                        # DTOs (JSON serialization)
│   │   │   └── user_model.dart            # Con .toEntity() mapper
│   │   ├── datasources/                   # Fuentes de datos
│   │   │   ├── auth_datasource.dart       # Contrato abstracto
│   │   │   ├── mock_auth_datasource_impl.dart  # Implementación MOCK
│   │   │   └── api_auth_datasource_impl.dart   # Implementación API real
│   │   └── repositories_impl/
│   │       └── auth_repository_impl.dart  # Implementación de repositorio
│   │
│   └── presentation/                      # 🎨 PRESENTATION LAYER (UI)
│       ├── providers/                     # Controllers de Riverpod
│       │   ├── session/
│       │   │   └── session_provider.dart  # Estado de sesión global
│       │   ├── splash/
│       │   │   └── splash_controller.dart
│       │   ├── login/
│       │   │   └── login_controller.dart
│       │   ├── home/
│       │   │   └── home_controller.dart
│       │   └── kyc/
│       │       ├── kyc_document_provider.dart
│       │       └── kyc_location_provider.dart
│       │
│       └── screens/                       # Pantallas organizadas por feature
│           ├── splash/
│           │   └── splash_screen.dart
│           ├── login/
│           │   └── login_screen.dart
│           ├── home/
│           │   ├── home_screen.dart       # StatefulNavigationShell (tabs)
│           │   └── views/
│           │       ├── dashboard_view.dart
│           │       ├── clients_view.dart
│           │       ├── loans_view.dart
│           │       └── reports_view.dart
│           ├── kyc/
│           │   ├── kyc_start_screen.dart
│           │   ├── kyc_document_scan_screen.dart
│           │   ├── kyc_document_scan_back_screen.dart
│           │   ├── kyc_selfie_screen.dart
│           │   └── kyc_location_screen.dart
│           └── loans/
│               └── new_loan_screen.dart
│
├── assets/
│   ├── images/                            # Imágenes de la app
│   └── icons/                             # Íconos personalizados
│
├── test/                                  # Tests unitarios
│
├── android/                               # Proyecto nativo Android
├── ios/                                   # Proyecto nativo iOS
│
├── pubspec.yaml                           # Dependencias y configuración
├── analysis_options.yaml                  # Reglas de lint
└── WARP.md                                # Esta guía
```

## ⚙️ Comandos de Desarrollo

### 🔄 Generación de Código
Este proyecto usa `build_runner` para generar código de Riverpod, Freezed y JSON serialization.

**Generar todos los archivos de código:**
```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

**Modo watch (regenera automáticamente al cambiar archivos):**
```powershell
flutter pub run build_runner watch --delete-conflicting-outputs
```

**Limpiar archivos generados:**
```powershell
flutter pub run build_runner clean
```

### ▶️ Ejecutar la Aplicación
```powershell
flutter run
```

**Ejecutar en modo release:**
```powershell
flutter run --release
```

**Ejecutar en dispositivo específico:**
```powershell
flutter devices                    # Listar dispositivos disponibles
flutter run -d <device-id>        # Ejecutar en dispositivo específico
```

### 🧪 Testing
```powershell
flutter test                      # Ejecutar todos los tests
flutter test test/path/file.dart  # Ejecutar test específico
```

### 🔍 Linting y Análisis
```powershell
flutter analyze                   # Analizar código
flutter analyze --no-fatal-infos  # Ignorar infos como errores
```

### 📦 Dependencias
```powershell
flutter pub get                   # Instalar dependencias
flutter pub upgrade               # Actualizar dependencias
flutter pub outdated              # Ver dependencias desactualizadas
```

### 🧹 Limpieza
```powershell
flutter clean                     # Limpiar build cache
```

## 📦 Tecnologías y Dependencias Principales

### 📚 Core
- **flutter_riverpod** (^3.0.3) - Gestión de estado reactiva
- **riverpod_annotation** (^3.0.3) - Code generation para Riverpod
- **go_router** (^17.0.0) - Navegación declarativa y route guards

### 🌐 Networking & Storage
- **dio** (^5.5.0+1) - Cliente HTTP para APIs REST
- **flutter_secure_storage** (^9.2.2) - Almacenamiento seguro de tokens

### 🔐 Autenticación
- **local_auth** (^3.0.0) - Autenticación biométrica (huella, Face ID)

### 📝 Modelos de Datos
- **freezed** (^3.2.3) + **freezed_annotation** (^3.1.0) - Clases inmutables y unions
- **json_serializable** (^6.11.1) + **json_annotation** (^4.9.0) - JSON serialization

### 📸 Features
- **image_picker** (^1.1.2) - Acceso a cámara y galería
- **geolocator** (^14.0.2) - Geolocalización GPS

### 🛠️ Dev Tools
- **build_runner** (^2.4.11) - Generación de código
- **flutter_lints** (^6.0.0) - Reglas de lint recomendadas

---

## 🏛️ Architecture Overview

Aplicación Flutter implementando **Clean Architecture** con **Riverpod** para gestión de estado.

### 📋 Estructura de Capas

El código está organizado en 4 capas principales:

#### 1. 🎯 **Domain Layer** (`lib/domain/`)
**Lógica de negocio pura, independiente del framework.**

- **Entities** (`entities/`): Clases Dart puras representando objetos de negocio (ej. `User`)
  - Usan Freezed para inmutabilidad
  - NO dependen de frameworks externos
  
- **Repositories** (`repositories/`): Contratos abstractos definiendo operaciones de datos
  - Ejemplo: `AuthRepository` con métodos `login()`, `logout()`, etc.
  - Sólo interfaces, implementadas en la capa Data
  
- **Enums** (`enums/`): Enumeraciones del dominio (ej. `AuthStatus`)

#### 2. 💾 **Data Layer** (`lib/data/`)
**Acceso a datos y comunicación con servicios externos.**

- **Models** (`models/`): DTOs (Data Transfer Objects) para JSON serialization
  - Ejemplo: `UserModel` con `@freezed` y `@JsonSerializable`
  - Incluyen método `.toEntity()` para mapear a entidades de dominio
  
- **Datasources** (`datasources/`): Fuentes de datos concretas
  - `AuthDatasource`: Contrato abstracto
  - `MockAuthDatasourceImpl`: Implementación con datos falsos
  - `ApiAuthDatasourceImpl`: Implementación con API real (Dio)
  
- **Repository Implementations** (`repositories_impl/`): Implementaciones de contratos de dominio
  - Orquestan datasources
  - Mapean DTOs → Entities usando `.toEntity()`

#### 3. 🎨 **Presentation Layer** (`lib/presentation/`)
**UI y gestión de estado visual.**

- **Screens** (`screens/`): Pantallas completas organizadas por feature
  - `splash/`, `login/`, `home/`, `kyc/`, `loans/`
  - Cada feature tiene su propia carpeta
  
- **Providers** (`providers/`): Controllers de Riverpod para lógica de presentación
  - Organizados por feature
  - Retornan `AsyncValue<T>` para estados loading/data/error
  - Ejemplo: `LoginController`, `SplashController`
  
- **Widgets** (`widgets/`): Componentes UI reutilizables

#### 4. ⚙️ **Core Layer** (`lib/core/`)
**Infraestructura y cross-cutting concerns.**

- **Router** (`router/`): Configuración de GoRouter
  - Route guards para autenticación
  - `StatefulShellRoute.indexedStack` para tabs
  
- **Theme** (`theme/`): Tema Material 3
  - Color seed: emerald/jade
  - `app_theme.dart`
  
- **Providers** (`providers/`): Providers de infraestructura para DI
  - `dioProvider`: Cliente HTTP
  - `storageProvider`: Almacenamiento seguro
  - `localAuthProvider`: Biometría
  - `repositoryProviders`: Inyección de repositorios

### 🔧 Patrones Arquitectónicos Clave

#### 📦 Dependency Injection (DI)
Usa generación de código de Riverpod para inyección de dependencias.

- Todos los providers se definen con anotación `@riverpod`
- Archivos `*.g.dart` generados automáticamente con `build_runner`
- Providers accesibles globalmente mediante `ref.watch()` o `ref.read()`

```dart
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final datasource = ref.watch(authDatasourceProvider);
  return AuthRepositoryImpl(datasource);
}
```

#### 🔄 Switching entre Mock y API Real
El proyecto soporta cambio entre datos mock y API real mediante un flag:

**Archivo:** `lib/core/providers/repository_providers.dart`
```dart
const bool _USE_MOCK_DATA = true; // ⚙️ Cambiar a false para usar API real
```

Esto permite:
- ✅ Desarrollo sin backend
- ✅ Testing rápido
- ✅ Demos offline

#### 👤 Session Management
Estado global de sesión gestionado por `sessionProvider`:

**Archivo:** `lib/presentation/providers/session/session_provider.dart`

- Mantiene la entidad `User` actual
- Marcado con `keepAlive: true` para persistir durante todo el ciclo de vida
- Actualizado después de login/logout
- Observado por el router para redirecciones

#### 🧭 Navigation Architecture
Usa **GoRouter** con `StatefulShellRoute.indexedStack` para tabs de navegación inferior.

**Características:**
- `HomeScreen` recibe `StatefulNavigationShell`
- Navegación delegada a GoRouter (no estado local)
- **Route Guard:** Lógica de redirección que verifica:
  - ✅ Autenticación (token válido)
  - ✅ Estado KYC completado
  - ❌ Bloquea rutas protegidas sin auth

### 📡 Convenciones de State Management

| Tipo | Uso | Ejemplo |
|------|-----|--------|
| **Controllers** | Lógica de features con `@riverpod` | `LoginController`, `SplashController` |
| **Session Provider** | Estado global con `keepAlive: true` | `sessionProvider` |
| **AsyncValue<T>** | Estados loading/data/error | `AsyncValue<User>` |

### 🔄 Flujo de Datos (Data Flow)

```
📱 UI (Widget)
    ↓
    │ llama método
    ↓
🎮 Controller (Riverpod)
    ↓
    │ llama repositorio (contrato)
    ↓
🎯 Repository (Domain)
    ↓
    │ llama datasource
    ↓
💾 Datasource (Mock/API)
    ↓
    │ retorna DTO (Model)
    ↓
📦 UserModel
    ↓
    │ .toEntity() mapper
    ↓
🎯 User (Entity)
    ↓
    │ fluye de regreso
    ↓
📱 UI actualiza
```

**Pasos detallados:**
1. 📱 **UI** llama métodos en **controllers** de Riverpod
2. 🎮 **Controllers** invocan **repositories** (contratos de dominio)
3. 🎯 **Repository implementations** llaman **datasources**
4. 💾 **Datasources** obtienen datos crudos y retornan **DTOs** (models)
5. 📦 **Repositories** mapean DTOs → **Entities** con `.toEntity()`
6. 🎯 **Entities** fluyen de regreso a UI mediante controllers

### 🛠️ Code Generation

**⚠️ NO EDITAR MANUALMENTE estos archivos generados:**

| Pattern | Propósito | Generado por |
|---------|----------|-------------|
| `*.g.dart` | JSON serialization + Riverpod providers | `json_serializable` + `riverpod_generator` |
| `*.freezed.dart` | Clases inmutables con copyWith, toString, == | `freezed` |

**⚡ Cuándo regenerar código:**
- Después de modificar archivos con `@freezed`
- Después de modificar archivos con `@riverpod`
- Después de modificar archivos con `@JsonSerializable`

**Comando:**
```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### 🔐 Flujo de Autenticación (Auth Flow)

```
1️⃣ SPLASH SCREEN
   ├─ Verifica token guardado
   ├─ splashController.checkAuthStatus()
   └─ Redirige según estado:
       ├─ Sin token → /login
       ├─ Token válido + KYC pendiente → /kyc/start
       └─ Token válido + KYC completo → /home

2️⃣ LOGIN SCREEN
   ├─ Usuario ingresa credenciales
   ├─ loginController.login(email, password)
   ├─ AuthRepository.login() → obtiene User + token
   ├─ Guarda token en flutter_secure_storage
   ├─ Actualiza sessionProvider con User
   └─ GoRouter detecta cambio → redirige automáticamente

3️⃣ KYC FLOW (Verificación)
   ├─ /kyc/start → Pantalla de inicio
   ├─ /kyc/document-scan → Escanear frente de documento
   ├─ /kyc/document-scan-back → Escanear reverso
   ├─ /kyc/selfie → Capturar selfie
   ├─ /kyc/location → Capturar ubicación GPS
   └─ Completo → Actualiza user.kycCompleted → /home

4️⃣ SESSION PERSISTENCE
   ├─ flutter_secure_storage guarda token encriptado
   ├─ Persiste entre cierres de app
   └─ Auto-login en próxima apertura

5️⃣ LOGOUT
   ├─ sessionProvider.logout()
   ├─ Elimina token de storage
   ├─ Limpia sessionProvider
   └─ GoRouter redirige → /login
```

### 🎯 Features Implementados

| Feature | Descripción | Pantallas | Providers |
|---------|-------------|-----------|----------|
| 🔐 **Authentication** | Login, logout, gestión de sesión | `login_screen.dart`<br>`splash_screen.dart` | `loginController`<br>`splashController`<br>`sessionProvider` |
| 🎫 **KYC** | Verificación de identidad multi-paso | `kyc_start_screen.dart`<br>`kyc_document_scan_screen.dart`<br>`kyc_document_scan_back_screen.dart`<br>`kyc_selfie_screen.dart`<br>`kyc_location_screen.dart` | `kycDocumentProvider`<br>`kycLocationProvider` |
| 🏠 **Dashboard** | Vista principal con estadísticas | `home_screen.dart`<br>`dashboard_view.dart` | `homeController` |
| 💰 **Loans** | Gestión de préstamos | `new_loan_screen.dart`<br>`loans_view.dart` | - |
| 👥 **Clients** | Gestión de clientes | `clients_view.dart` | - |
| 📊 **Reports** | Análisis y reportes | `reports_view.dart` | - |

---

## 💡 Tips de Desarrollo

### 🚨 Problemas Comunes

**1. Error: "Missing required library"**
```powershell
# Solución: Instalar dependencias
flutter pub get
```

**2. Error: "*.g.dart file not found"**
```powershell
# Solución: Generar archivos de código
flutter pub run build_runner build --delete-conflicting-outputs
```

**3. Error de compilación después de cambios**
```powershell
# Solución: Limpiar y reconstruir
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**4. Hot reload no funciona correctamente**
```powershell
# Usar hot restart en su lugar: Shift + R en la terminal
# O detener y reiniciar: flutter run
```

### ✅ Mejores Prácticas

1. **🔄 Siempre regenerar código** después de cambios en:
   - Clases con `@freezed`
   - Providers con `@riverpod`
   - Models con `@JsonSerializable`

2. **📋 Organizar por features:** Mantener lógica agrupada por feature:
   ```
   presentation/
   ├── screens/kyc/
   └── providers/kyc/
   ```

3. **👍 Usar AsyncValue:** Para manejar estados asíncronos:
   ```dart
   state.when(
     data: (user) => Text('Hola ${user.name}'),
     loading: () => CircularProgressIndicator(),
     error: (err, stack) => Text('Error: $err'),
   )
   ```

4. **🚫 NO editar archivos generados:** Archivos `*.g.dart` y `*.freezed.dart`

5. **🛡️ Type-safety:** Usar tipos explícitos siempre que sea posible

6. **📝 Comentar lógica compleja:** Especialmente en mappers y transformaciones

### 🛠️ Workflow Recomendado

**Para agregar un nuevo feature:**

1. **Domain Layer:**
   - Crear entity en `domain/entities/`
   - Crear repository contract en `domain/repositories/`

2. **Data Layer:**
   - Crear model en `data/models/` con `@freezed` y `@JsonSerializable`
   - Crear datasource contract en `data/datasources/`
   - Implementar mock y API datasource
   - Implementar repository en `data/repositories_impl/`

3. **Core Layer:**
   - Agregar provider en `core/providers/repository_providers.dart`

4. **Presentation Layer:**
   - Crear controller en `presentation/providers/<feature>/`
   - Crear screens en `presentation/screens/<feature>/`
   - Agregar rutas en `core/router/app_router.dart`

5. **Generar código:**
   ```powershell
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Probar:**
   ```powershell
   flutter run
   ```

---

## 📖 Referencias Útiles

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## 👤 Para WARP AI

**Contexto importante:**
- Este proyecto sigue Clean Architecture estrictamente
- Usa Riverpod con code generation (`@riverpod`)
- Todos los archivos `*.g.dart` y `*.freezed.dart` son generados
- El flag `_USE_MOCK_DATA` en `repository_providers.dart` controla mock vs API real
- Siempre regenerar código después de cambios en anotaciones

**Al sugerir cambios:**
1. Respetar la separación de capas (Domain/Data/Presentation/Core)
2. Usar Riverpod para DI y state management
3. Seguir patrones existentes (naming, estructura de carpetas)
4. Recordar regenerar código si es necesario
