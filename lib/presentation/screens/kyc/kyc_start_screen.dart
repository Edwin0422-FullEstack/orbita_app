// lib/presentation/screens/kyc/kyc_start_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// 1. IMPORTAMOS EL HOME CONTROLLER (QUE TIENE EL LOGOUT)
import 'package:orbita/presentation/providers/home/home_controller.dart';

class KycStartScreen extends ConsumerWidget {
  const KycStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación de Identidad'),
        // 2. HACEMOS QUE LA FLECHA "ATRÁS" FUNCIONE
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Cancelar y Salir',
          onPressed: () {
            // 3. ¡LA MAGIA!
            //    Llamamos al logout. Esto limpiará la sesión.
            //    El GoRouter (que está 'observando' la sesión)
            //    detectará el cambio y el firewall
            //    automáticamente nos enviará a /login.
            ref.read(homeControllerProvider.notifier).logout();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 100,
                color: colorScheme.primary, // Verde esmeralda
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Un último paso!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Para desbloquear tu cupo de préstamo, necesitamos validar tu identidad (KYC). Es un proceso rápido y seguro.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              FilledButton.icon(
                icon: const Icon(Icons.shield_outlined),
                label: const Text('Comenzar Verificación'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  context.go('/kyc/document-scan');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}