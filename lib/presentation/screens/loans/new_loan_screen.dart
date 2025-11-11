// lib/presentation/screens/loans/new_loan_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider para el paso actual del Stepper
final _stepperIndexProvider = StateProvider.autoDispose<int>((_) => 0);

class NewLoanScreen extends ConsumerWidget {
  const NewLoanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(_stepperIndexProvider);
    final textTheme = Theme.of(context).textTheme;

    // Pasos del formulario
    final steps = [
      Step(
        title: const Text('Monto'),
        content: Column(
          children: [
            Text('¿Cuánto necesitas?', style: textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Monto del Préstamo',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        isActive: currentStep >= 0,
      ),
      Step(
        title: const Text('Plazo'),
        content: Column(
          children: [
            Text('¿En cuántos meses?', style: textTheme.titleLarge),
            const SizedBox(height: 16),
            // (Aquí iría un Slider o Dropdown)
            const Text('Selector de Plazo (Placeholder)'),
          ],
        ),
        isActive: currentStep >= 1,
      ),
      Step(
        title: const Text('Confirmar'),
        content: const Column(
          children: [
            Text('Resumen de tu solicitud (Placeholder)'),
          ],
        ),
        isActive: currentStep >= 2,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar Nuevo Préstamo'),
      ),
      body: Stepper(
        type: StepperType.horizontal, // Stepper horizontal moderno
        currentStep: currentStep,
        steps: steps,
        onStepContinue: () {
          if (currentStep < steps.length - 1) {
            ref.read(_stepperIndexProvider.notifier).state++;
          } else {
            // TODO: Lógica de 'submit' del préstamo
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            ref.read(_stepperIndexProvider.notifier).state--;
          }
        },
        onStepTapped: (index) {
          // Permite navegar tocando los pasos
          ref.read(_stepperIndexProvider.notifier).state = index;
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                FilledButton(
                  onPressed: details.onStepContinue,
                  child: Text(currentStep == steps.length - 1 ? 'Enviar' : 'Siguiente'),
                ),
                if (currentStep > 0) ...[
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Atrás'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}