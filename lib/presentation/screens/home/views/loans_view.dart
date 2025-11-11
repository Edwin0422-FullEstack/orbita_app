// lib/presentation/screens/home/views/loans_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/presentation/providers/session/session_provider.dart';

class LoansView extends ConsumerWidget {
  const LoansView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionUser = ref.watch(sessionProvider);
    final isVerified = sessionUser?.isVerified ?? false;
    final colorScheme = Theme.of(context).colorScheme;

    // Usamos un AnimatedSwitcher para una transición suave
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: isVerified
      // ---- VISTA SI ESTÁ VERIFICADO ----
          ? _VerifiedLoanView(key: const ValueKey('verified'))
      // ---- VISTA SI NO ESTÁ VERIFICADO ----
          : _UnverifiedLoanView(key: const ValueKey('unverified')),
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
            Icon(
              Icons.lock_outline,
              size: 80,
              color: colorScheme.error,
            ),
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
              onPressed: () {
                // El firewall nos atrapará, pero esto es más explícito
                context.go('/kyc/start');
              },
            )
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
    // (Este sería nuestro "ranking" o cupo mockeado)
    const String loanCupo = "\$500.000";

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
          // El "Ranking" o Cupo
          Text(
            loanCupo,
            textAlign: TextAlign.center,
            style: textTheme.displayLarge?.copyWith(
              color: colorScheme.primary, // Verde esmeralda
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ranking: Orbita Plata', // Ranking
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 48),
          // El botón de Solicitar
          FilledButton(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              // TODO: Navegar al flujo de solicitud
            },
            child: const Text('Solicitar Préstamo'),
          ),
        ],
      ),
    );
  }
}