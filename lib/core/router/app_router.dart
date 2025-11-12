// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/domain/entities/user.dart';
import 'package:orbita/presentation/providers/session/session_provider.dart';
// Importamos TODAS las pantallas y vistas
import 'package:orbita/presentation/screens/home/home_screen.dart';
import 'package:orbita/presentation/screens/home/views/clients_view.dart';
import 'package:orbita/presentation/screens/home/views/dashboard_view.dart';
import 'package:orbita/presentation/screens/home/views/loans_view.dart';
import 'package:orbita/presentation/screens/home/views/reports_view.dart';
import 'package:orbita/presentation/screens/kyc/kyc_document_scan_back_screen.dart';
import 'package:orbita/presentation/screens/kyc/kyc_document_scan_screen.dart';
import 'package:orbita/presentation/screens/kyc/kyc_location_screen.dart';
import 'package:orbita/presentation/screens/kyc/kyc_selfie_screen.dart';
import 'package:orbita/presentation/screens/kyc/kyc_start_screen.dart';
import 'package:orbita/presentation/screens/login/login_screen.dart';
import 'package:orbita/presentation/screens/splash/splash_screen.dart';
import 'package:orbita/presentation/screens/loans/new_loan_screen.dart';

// --- 1. ¡LA CORRECCIÓN! ---
// Quitamos el guion bajo '_' para hacerla PÚBLICA.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
// -------------------------

final goRouterProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey, // <-- 2. Usamos la clave pública
    initialLocation: '/splash',

    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // --- EL SHELLROUTE ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          // Pestaña 0: Inicio
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardView(),
              ),
            ],
          ),
          // Pestaña 1: Préstamos
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/loans',
                builder: (context, state) => const LoansView(),
              ),
            ],
          ),
          // Pestaña 2: Clientes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/clients',
                builder: (context, state) => const ClientsView(),
              ),
            ],
          ),
          // Pestaña 3: Reportes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reports',
                builder: (context, state) => const ReportsView(),
              ),
            ],
          ),
        ],
      ),

      // --- RUTA DE NIVEL SUPERIOR ---
      GoRoute(
        path: '/loans/new',
        builder: (context, state) => const NewLoanScreen(),
      ),

      // --- GRUPO DE RUTAS KYC ---
      GoRoute(
        path: '/kyc/start',
        builder: (context, state) => const KycStartScreen(),
      ),
      GoRoute(
        path: '/kyc/document-scan',
        builder: (context, state) => const KycDocumentScanScreen(),
      ),
      GoRoute(
        path: '/kyc/document-scan-back',
        builder: (context, state) => const KycDocumentScanBackScreen(),
      ),
      GoRoute(
        path: '/kyc/selfie',
        builder: (context, state) => const KycSelfieScreen(),
      ),
      GoRoute(
        path: '/kyc/location',
        builder: (context, state) => const KycLocationScreen(),
      ),
    ],

    // --- FIREWALL ---
    redirect: (context, state) {
      final goingTo = state.matchedLocation;
      final bool isLoggedIn = session != null;
      final bool isVerified = session?.isVerified ?? false;

      if (goingTo == '/splash') return null;
      if (!isLoggedIn) return (goingTo == '/login') ? null : '/login';

      if (!isVerified) {
        if (goingTo.startsWith('/kyc')) return null;
        return '/kyc/start';
      }

      // Si está verificado
      if (goingTo == '/login' || goingTo == '/splash' || goingTo.startsWith('/kyc')) {
        return '/dashboard'; // Manda a la pestaña de inicio
      }

      if (goingTo == '/') return '/dashboard';

      return null;
    },
  );
});