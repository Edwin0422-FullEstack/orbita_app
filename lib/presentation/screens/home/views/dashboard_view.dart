// lib/presentation/screens/home/views/dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbita/domain/entities/user.dart';
import 'package:orbita/presentation/providers/session/session_provider.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Leemos la sesión
    final sessionUser = ref.watch(sessionProvider);
    final bool isLoading = sessionUser == null; // Simple check

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¡Hola, ${sessionUser?.fullName.split(' ').first ?? "Usuario"}!',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(sessionUser?.email ?? ''),
        const SizedBox(height: 20),
        if (isLoading)
          const CircularProgressIndicator()
        else
        // Mostramos el estado de la cuenta
          Text(
            sessionUser?.isVerified ?? false
                ? 'Cuenta Verificada'
                : 'VERIFICACIÓN REQUERIDA',
            style: TextStyle(
                color: (sessionUser?.isVerified ?? false)
                    ? Colors.green
                    : Colors.orange,
                fontWeight: FontWeight.bold
            ),
          ),
      ],
    );
  }
}