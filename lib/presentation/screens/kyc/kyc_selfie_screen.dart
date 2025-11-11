// lib/presentation/screens/kyc/kyc_selfie_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orbita/presentation/providers/kyc/kyc_document_provider.dart';

class KycSelfieScreen extends ConsumerWidget {
  const KycSelfieScreen({super.key});

  /// Método de ayuda para tomar la selfie
  Future<void> _takeSelfie(WidgetRef ref) async {
    final imagePicker = ref.read(imagePickerProvider);
    try {
      // 1. SIN 'source'. Forzamos cámara y dispositivo frontal.
      final file = await imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front, // <-- ¡LA CLAVE!
        imageQuality: 80,
      );

      if (file != null) {
        ref.read(kycDocumentsProvider.notifier).setSelfie(file);
      }
    } catch (e) { /* (Manejar error) */ }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observamos solo la imagen de la SELFIE
    final imageFile = ref.watch(kycDocumentsProvider.select((s) => s.selfie));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación (Paso 3/4)'), // <-- 3 de 4
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(kycDocumentsProvider.notifier).clearSelfie();
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Tómate una Selfie',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Asegúrate de que tu rostro esté bien iluminado, sin gafas ni gorras.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // --- 2. VISTA PREVIA CIRCULAR ---
            AspectRatio(
              aspectRatio: 1.0, // Cuadrado para el círculo
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
                  shape: BoxShape.circle, // <-- ¡LA CLAVE!
                ),
                child: ClipOval( // <-- ¡LA CLAVE!
                  child: imageFile == null
                  // Estado Vacío
                      ? Center(
                    child: Icon(Icons.person_outline, size: 100, color: Colors.grey[400]),
                  )
                  // Estado con Imagen
                      : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(imageFile.path),
                        fit: BoxFit.cover,
                      ),
                      // Botón para limpiar
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton.filled(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            ref.read(kycDocumentsProvider.notifier).clearSelfie();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- 3. BOTÓN DE ACCIÓN ÚNICO ---
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.camera_alt_outlined),
                label: Text(imageFile == null ? 'Tomar Foto' : 'Tomar de Nuevo'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _takeSelfie(ref),
              ),
            ),

            const Spacer(), // Empuja el botón 'Siguiente' al fondo

            // --- 4. BOTÓN DE NAVEGACIÓN (Condicional) ---
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                // Deshabilitado si no hay imagen
                onPressed: imageFile == null
                    ? null
                    : () {
                  // ¡AQUÍ ESTÁ EL CAMBIO!
                  context.go('/kyc/location');
                },
                child: const Text('Siguiente'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}