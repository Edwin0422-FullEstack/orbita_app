import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/core/router/app_router.dart';
import 'package:orbita/presentation/providers/session/session_provider.dart';

class LoansView extends ConsumerWidget {
  const LoansView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionUser = ref.watch(sessionProvider);
    final isVerified = sessionUser?.isVerified ?? false;

    // Usamos AnimatedSwitcher para transición suave entre vistas
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: isVerified
          ? const _VerifiedLoanView(key: ValueKey('verified'))
          : const _UnverifiedLoanView(key: ValueKey('unverified')),
    );
  }
}

// --- WIDGET INTERNO (NO VERIFICADO) ---
class _UnverifiedLoanView extends StatelessWidget {
  const _UnverifiedLoanView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 80, color: colorScheme.error),
            const SizedBox(height: 24),
            const Text(
              'Cupo Bloqueado',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Completa tu verificación de identidad (KYC) para desbloquear tu cupo de préstamo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            FilledButton.icon(
              icon: const Icon(Icons.admin_panel_settings_outlined),
              label: const Text('Completar Verificación'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () => context.go('/kyc/start'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET INTERNO (VERIFICADO) ---
class _VerifiedLoanView extends StatelessWidget {
  const _VerifiedLoanView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const String loanCupo = "\$50.000"; // ejemplo de cupo

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tu Cupo Aprobado',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),

          // 💰 Cupo visual
          Text(
            loanCupo,
            textAlign: TextAlign.center,
            style: textTheme.displayLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),
          const Text(
            'Ranking: Orbita Bronce',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          const SizedBox(height: 48),

          // 🚀 Botón principal — Solicitar préstamo
          FilledButton.icon(
            icon: const Icon(Icons.post_add),
            label: const Text('Solicitar Préstamo'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              // Navegación segura usando rootNavigatorKey
              final ctx = rootNavigatorKey.currentContext ?? context;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navegando a /loans/new')),
              );
              GoRouter.of(ctx).go('/loans/new');
            },
          ),
        ],
      ),
    );
  }
}
