import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // 👈 AÑADIDO para formatear moneda y fecha
// import 'package:orbita/core/router/app_router.dart'; // No se usa en esta vista
import 'package:orbita/presentation/providers/session/session_provider.dart';

class LoansView extends ConsumerWidget {
  const LoansView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionUser = ref.watch(sessionProvider);
    final isVerified = sessionUser?.isVerified ?? false;

    // Tu lógica de AnimatedSwitcher es perfecta y se mantiene
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: isVerified
          ? const _VerifiedLoanView(key: ValueKey('verified')) // 👈 ESTA ES LA VISTA QUE VAMOS A CAMBIAR
          : const _UnverifiedLoanView(key: ValueKey('unverified')),
    );
  }
}

// --- WIDGET INTERNO (NO VERIFICADO) ---
// (Esta vista no se toca, está perfecta)
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

// --- WIDGET INTERNO (VERIFICADO) - ¡REFACTORIZADO! ---
class _VerifiedLoanView extends StatelessWidget {
  const _VerifiedLoanView({super.key});

  // TODO: Estos datos vendrán de un provider (ej: transactionsProvider)
  static final _mockTransactions = [
    {
      "id": "1",
      "title": "Abono",
      "date": DateTime(2024, 11, 30),
      "amount": 60000.0,
      "status": "Realizado",
      "isCredit": true, // Es un abono (entrada)
    },
    {
      "id": "2",
      "title": "Retiro de dinero",
      "date": DateTime(2024, 11, 9),
      "amount": 50000.0,
      "status": "Realizado",
      "isCredit": false, // Es un retiro (salida)
    },
    {
      "id": "3",
      "title": "Abono de cupo",
      "date": DateTime(2024, 10, 28),
      "amount": 150000.0,
      "status": "Realizado",
      "isCredit": true,
    }
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    // Esta vista es ahora un ListView que coincide con la captura de Monet
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      children: [
        // 1. Título "Historial" (como en la captura)
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            'Historial',
            style: textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
        ),

        // 2. Subtítulo "Últimos movimientos"
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            'Últimos movimientos',
            style: textTheme.titleMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
        ),

        // 3. Lista de tarjetas de transacción
        ..._mockTransactions.map((tx) {
          return _TransactionCard(transaction: tx);
        }).toList(),
      ],
    );
  }
}

/// Widget auxiliar para mostrar cada tarjeta de transacción
class _TransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Formateadores
    final currencyFormat = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);
    final dateFormat = DateFormat('MMMM d, y', 'es_CO');

    // Determina el color del monto
    final amountColor = transaction['isCredit'] as bool
        ? Colors.green.shade400 // Abono (Verde)
        : colors.onSurface; // Retiro (Color normal)

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colors.surfaceContainerHighest, // Color de tarjeta sutil
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        // Título (Abono, Retiro)
        title: Text(
          transaction['title'] as String,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        // Subtítulo (Fecha)
        subtitle: Text(
          dateFormat.format(transaction['date'] as DateTime),
          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        // Trailing (Monto y Estado)
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currencyFormat.format(transaction['amount']),
              style: textTheme.bodyLarge?.copyWith(
                color: amountColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              transaction['status'] as String,
              style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}