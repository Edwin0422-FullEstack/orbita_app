// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

// La clave pública es ESENCIAL para este caso de uso.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey, // <-- Usamos la clave pública
    initialLocation: '/splash',
    observers: [RouteLogger()],
    debugLogDiagnostics: true,

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
                // ¡YA NO TIENE SUB-RUTAS!
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

      // --- ¡AQUÍ ESTÁ LA CORRECCIÓN! ---
      // La ruta vuelve a ser de NIVEL SUPERIOR (hermana del ShellRoute)
      GoRoute(
        path: '/loans/new',
        // Asignamos la clave raíz a esta ruta para asegurar
        // que se muestre por encima del Shell.
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NewLoanScreen(),
      ),
      // --- FIN DE LA CORRECCIÓN ---


      // --- GRUPO DE RUTAS KYC ---
      GoRoute(
        path: '/kyc/start',
        parentNavigatorKey: rootNavigatorKey, // Es buena idea hacer esto para todas las rutas "full screen"
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
    ],

    // --- FIREWALL ---
    redirect: (context, state) {
      final goingTo = state.matchedLocation;
      final bool isLoggedIn = session != null;
      final bool isVerified = session?.isVerified ?? false;

      if (kDebugMode) {
        // ignore: avoid_print
        print('[Router.redirect] to=$goingTo, isLoggedIn=$isLoggedIn, isVerified=$isVerified');
      }

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

// --- Observer de navegación para depurar ---
class RouteLogger extends NavigatorObserver {
  void _log(String msg) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[Nav] $msg');
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _log('push: ${route.settings.name ?? route} (from: ${previousRoute?.settings.name ?? previousRoute})');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _log('pop: ${route.settings.name ?? route} -> ${previousRoute?.settings.name ?? previousRoute}');
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _log('replace: ${oldRoute?.settings.name ?? oldRoute} -> ${newRoute?.settings.name ?? newRoute}');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
