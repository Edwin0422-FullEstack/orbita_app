// lib/domain/enums/auth_status.dart
enum AuthStatus {
  checking,         // Todavía no sabemos el estado
  authenticated,    // El usuario está logueado
  unauthenticated,  // El usuario NO está logueado
  // (podríamos añadir 'firstTime', 'needsVerification', etc. después)
}