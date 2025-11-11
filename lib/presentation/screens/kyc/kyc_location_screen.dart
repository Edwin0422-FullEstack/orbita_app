// lib/presentation/screens/kyc/kyc_location_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:orbita/presentation/providers/kyc/kyc_location_provider.dart';
import 'package:orbita/presentation/providers/session/session_provider.dart';
// (Necesitaremos los documentos para el 'submit' final)
// import 'package:orbita/presentation/providers/kyc/kyc_document_provider.dart';

class KycLocationScreen extends ConsumerWidget {
  const KycLocationScreen({super.key});

  /// Método final que envía todo
  void _submitKyc(WidgetRef ref) {
    // 1. Obtener todos los datos recopilados
    // final images = ref.read(kycDocumentsProvider);
    // final location = ref.read(kycLocationProvider).value;

    // TODO: Enviar 'images' y 'location' a un
    // 'KycRepository' para subirlos a la API.

    // 2. MOCK: Como estamos en mock, solo actualizamos el estado
    //    de la sesión local para marcar al usuario como verificado.
    ref.read(sessionProvider.notifier).setUserVerified();

    // 3. ¡LISTO! GoRouter detectará este cambio de estado
    //    (isVerified: true) y nos redirigirá a /home.
    //    No necesitamos un 'context.go()' aquí.
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Observamos el estado del provider de ubicación
    final locationState = ref.watch(kycLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación (Paso 4/4)'),
        // No hay botón de 'atrás', es el paso final
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              '¡Último paso! Tu Ubicación',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Para aprobar tu cupo inicial, necesitamos verificar tu ubicación actual por regulaciones de seguridad.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),

            // --- 2. ÁREA DE ESTADO DINÁMICO ---
            locationState.when(
              // Estado Inicial o Exitoso
              data: (Position? position) {
                if (position == null) {
                  // Aún no la pide
                  return Center(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.location_on_outlined),
                      label: const Text('Permitir Ubicación'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      onPressed: () {
                        ref.read(kycLocationProvider.notifier).getLocation();
                      },
                    ),
                  );
                } else {
                  // ¡Éxito!
                  return Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[600], size: 80),
                      const SizedBox(height: 16),
                      const Text(
                        '¡Ubicación Obtenida!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                }
              },
              // Estado de Carga
              loading: () => const Center(child: CircularProgressIndicator()),
              // Estado de Error
              error: (error, stack) => Center(
                child: Column(
                  children: [
                    Icon(Icons.error, color: Colors.red[600], size: 80),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${error.toString()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    // Botón para reintentar
                    OutlinedButton(
                      onPressed: () {
                        ref.read(kycLocationProvider.notifier).getLocation();
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // --- 3. BOTÓN DE FINALIZAR (Condicional) ---
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                // Deshabilitado si no hay ubicación
                onPressed: locationState.value == null
                    ? null
                    : () => _submitKyc(ref),
                child: const Text('Finalizar Verificación'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}