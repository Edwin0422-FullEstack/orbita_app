import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final _stepperIndexProvider = StateProvider.autoDispose<int>((_) => 0);

class NewLoanScreen extends ConsumerStatefulWidget {
  const NewLoanScreen({super.key});

  @override
  ConsumerState<NewLoanScreen> createState() => _NewLoanScreenState();
}

class _NewLoanScreenState extends ConsumerState<NewLoanScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _formController;
  late Animation<double> _logoSlide;
  late Animation<double> _logoRotation;
  late Animation<double> _formOpacity;

  double _months = 6;

  @override
  void initState() {
    super.initState();

    // 🌌 Animaciones del logo
    _logoController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _logoSlide = Tween<double>(begin: 300, end: 0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoRotation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    // 🌟 Animación del formulario
    _formController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _formOpacity = CurvedAnimation(parent: _formController, curve: Curves.easeIn);

    _logoController.forward().then((_) => _formController.forward());
  }

  @override
  void dispose() {
    _logoController.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final currentStep = ref.watch(_stepperIndexProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Nuevo Préstamo'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E0F5F), Color(0xFF343BBF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Fondo orbital animado
            Positioned.fill(
              child: CustomPaint(
                painter: _OrbitalBackgroundPainter(
                  color: colors.primary.withOpacity(0.3),
                  rotation: _logoController.value * 2 * math.pi,
                ),
              ),
            ),

            // Logo animado
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0, _logoSlide.value - 120),
                  child: Transform.rotate(
                    angle: _logoRotation.value,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            colors.primary.withOpacity(0.9),
                            colors.secondary.withOpacity(0.6),
                            Colors.transparent,
                          ],
                          stops: const [0.2, 0.6, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withOpacity(0.5),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.auto_awesome, size: 42, color: Colors.white),
                    ),
                  ),
                );
              },
            ),

            // Formulario animado
            FadeTransition(
              opacity: _formOpacity,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(_formController),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                  child: _LoanForm(
                    currentStep: currentStep,
                    months: _months,
                    onMonthsChanged: (v) => setState(() => _months = v),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fondo orbital sutil
class _OrbitalBackgroundPainter extends CustomPainter {
  final Color color;
  final double rotation;
  _OrbitalBackgroundPainter({required this.color, required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.45);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..color = color;

    for (int i = 0; i < 3; i++) {
      final radius = 100.0 + i * 45;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation + i * 0.3);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: radius * 2, height: radius * 1.2),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitalBackgroundPainter oldDelegate) => true;
}

/// Formulario Stepper con Slider funcional
class _LoanForm extends ConsumerWidget {
  final int currentStep;
  final double months;
  final ValueChanged<double> onMonthsChanged;
  const _LoanForm({
    required this.currentStep,
    required this.months,
    required this.onMonthsChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final steps = [
      Step(
        title: const Text('Monto'),
        content: Column(
          children: const [
            Text('¿Cuánto necesitas?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Monto del préstamo',
                prefixIcon: Icon(Icons.attach_money_rounded),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
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
            const Text('¿En cuántos meses?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Slider(
              value: months,
              min: 1,
              max: 24,
              divisions: 23,
              label: "${months.toInt()} meses",
              activeColor: colors.primary,
              thumbColor: colors.secondary,
              onChanged: onMonthsChanged, // ✅ parámetro obligatorio
            ),
          ],
        ),
        isActive: currentStep >= 1,
      ),
      Step(
        title: const Text('Confirmar'),
        content: const Text('Resumen de tu solicitud...'),
        isActive: currentStep >= 2,
      ),
    ];

    final current = ref.watch(_stepperIndexProvider);

    return Stepper(
      type: StepperType.horizontal,
      currentStep: current,
      steps: steps,
      onStepContinue: () {
        if (current < steps.length - 1) {
          ref.read(_stepperIndexProvider.notifier).state++;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Solicitud enviada')),
          );
        }
      },
      onStepCancel: () {
        if (current > 0) ref.read(_stepperIndexProvider.notifier).state--;
      },
      onStepTapped: (i) => ref.read(_stepperIndexProvider.notifier).state = i,
      controlsBuilder: (context, details) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: details.onStepContinue,
                child: Text(
                  current == steps.length - 1 ? 'Enviar' : 'Siguiente',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              if (current > 0) ...[
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: details.onStepCancel,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.secondary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Atrás'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
