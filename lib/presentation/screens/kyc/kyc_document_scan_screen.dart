// lib/presentation/screens/kyc/kyc_document_scan_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
// 1. IMPORTAMOS EL NUEVO PROVIDER
import 'package:orbita/presentation/providers/kyc/kyc_document_provider.dart';

class KycDocumentScanScreen extends ConsumerWidget {
  const KycDocumentScanScreen({super.key});

  Future<void> _pickImage(WidgetRef ref, ImageSource source) async {
    final imagePicker = ref.read(imagePickerProvider);
    try {
      final file = await imagePicker.pickImage(source: source, imageQuality: 80);
      if (file != null) {
        // 2. USAMOS EL NUEVO MÉTODO
        ref.read(kycDocumentsProvider.notifier).setFront(file);
      }
    } catch (e) { /* (Manejar error) */ }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. OBSERVAMOS EL ESTADO DENTRO DEL PROVIDER
    final imageFile = ref.watch(kycDocumentsProvider.select((s) => s.front));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación (Paso 1/3)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 4. USAMOS EL NUEVO MÉTODO
            ref.read(kycDocumentsProvider.notifier).clearFront();
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Foto de tu Cédula (Frente)',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Asegúrate de que la foto sea clara, legible y sin reflejos.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: imageFile == null
                      ? const Center(
                    child: Icon(Icons.credit_card_outlined, size: 80, color: Colors.grey),
                  )
                      : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(File(imageFile.path), fit: BoxFit.cover),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton.filled(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            // 5. USAMOS EL NUEVO MÉTODO
                            ref.read(kycDocumentsProvider.notifier).clearFront();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              // ... (Botones de Galería y Cámara sin cambios) ...
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Galería'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () => _pickImage(ref, ImageSource.gallery),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Cámara'),
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () => _pickImage(ref, ImageSource.camera),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: imageFile == null
                    ? null
                    : () {
                  // 6. ¡NAVEGAMOS AL REVERSO!
                  context.go('/kyc/document-scan-back');
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