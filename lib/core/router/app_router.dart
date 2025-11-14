// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/presentation/providers/session/session_provider.dart';

// Bloqueo por PIN
import 'package:orbita/presentation/providers/app_lock/app_lock_provider.dart';
import 'package:orbita/presentation/screens/lock/pin_lock_screen.dart';

// Pantallas
import 'package:orbita/presentation/screens/home/home_screen.dart';
import 'package:orbita/presentation/screens/home/views/clients_view.dart';// Importa la vista correcta
import 'package:orbita/presentation/screens/home/views/loans_view.dart';

import 'package:orbita/presentation/screens/kyc/kyc_document_scan_back_screen.dart';
import 'package:orbita/presentation/screens/kyc/kyc_document_scan_screen.dart';
import 'package:orbita/presentation/screens/kyc/kyc_location_screen.dart';
import 'package:orbita/presentation/screens/kyc/kyc_selfie_screen.dart';
import 'package:orbita/presentation/screens/kyc/kyc_start_screen.dart';


import 'package:orbita/presentation/screens/login/login_step_pin_screen.dart';

import 'package:orbita/presentation/screens/splash/splash_screen.dart';
import 'package:orbita/presentation/screens/loans/new_loan_screen.dart';

// import '../../presentation/screens/login/login_screen.dart'; // Asumo que es 'LoginDocumentScreen'
import '../../presentation/screens/home/views/dashboard_view.dart';
import '../../presentation/screens/home/views/reports_view.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/profile/profile_ranking_screen.dart'; // Importa la vista correcta


final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionProvider);
  final isLocked = ref.watch(appLockProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    observers: [RouteLogger()],
    debugLogDiagnostics: true,

    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // LOGIN NUEVO
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginDocumentScreen(),
      ),

      GoRoute(
        path: '/login/pin',
        builder: (context, state) =>
            LoginPinScreen(extra: state.extra as Map<String, String>),
      ),

      // Bloqueo por PIN
      GoRoute(
        path: '/app-lock',
        builder: (context, state) => const PinLockScreen(),
      ),

      // SHELL (navbar)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const HomeMainView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/loans',
                builder: (context, state) => const LoansView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/clients',
                builder: (context, state) => const ClientsView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reports', // Dejamos la ruta como '/reports'
                builder: (context, state) => const HelpCenterView(), // Pero muestra la vista correcta
              ),
            ],
          ),
        ],
      ),

      // Préstamos
      GoRoute(
        path: '/loans/new',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NewLoanScreen(),
      ),

      // KYC
      GoRoute(
        path: '/kyc/start',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const KycStartScreen(),
      ),
      GoRoute(
        path: '/kyc/document-scan',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const KycDocumentScanScreen(),
      ),
      GoRoute(
        path: '/kyc/document-scan-back',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const KycDocumentScanBackScreen(),
      ),
      GoRoute(
        path: '/kyc/selfie',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const KycSelfieScreen(),
      ),
      GoRoute(
        path: '/kyc/location',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const KycLocationScreen(),
      ),
      GoRoute(
        path: '/profile/ranking',
        parentNavigatorKey: rootNavigatorKey, // Para que se muestre full-screen
        builder: (context, state) => const ProfileRankingScreen(),
      ),
    ],

    // 🔥 REDIRECT LOGIC ARREGLADO
    redirect: (context, state) {
      final goingTo = state.matchedLocation;
      final bool isLoggedIn = session != null;
      final bool isVerified = session?.isVerified ?? false;

      // 👇 ¡AQUÍ ESTÁ LA CORRECCIÓN! 👇
      // Si estamos en el splash, NO HAGAS NADA.
      // Deja que el SplashScreen decida a dónde ir.
      if (goingTo == '/splash') {
        return null;
      }

      // BLOQUEO EN PRIMER PLANO
      if (isLoggedIn && isLocked) {
        if (goingTo == '/app-lock') return null;
        return '/app-lock';
      }

      if (goingTo == '/app-lock' && !isLocked) {
        return '/dashboard';
      }

      // ---- LOGIN FLOW NUEVO ----
      if (!isLoggedIn) {
        // ❗ PERMITIMOS LOGIN Y PIN
        if (goingTo == '/login' || goingTo == '/login/pin') return null;

        // ❌ TODO LO DEMÁS redirige a /login
        return '/login';
      }

      // ---- KYC ----
      if (!isVerified) {
        if (goingTo.startsWith('/kyc')) return null;
        return '/kyc/start';
      }

      // Bloqueo para evitar volver al login
      if (goingTo == '/login' || goingTo == '/login/pin' || goingTo.startsWith('/kyc')) {
        return '/dashboard';
      }

      if (goingTo == '/') return '/dashboard';

      return null;
    },
  );
});

// DEBUG NAVIGATION LOGS
class RouteLogger extends NavigatorObserver {
  void _log(String msg) {
    if (kDebugMode) print('[Nav] $msg');
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _log('push: ${route.settings.name ?? route}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _log('pop: ${route.settings.name ?? route}');
    super.didPop(route, previousRoute);
  }
}