import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/presentation/providers/login/login_controller.dart';
import '../../../core/theme/app_theme.dart';

class LoginPinScreen extends ConsumerStatefulWidget {
  final Map<String, String> extra;

  const LoginPinScreen({super.key, required this.extra});

  @override
  ConsumerState<LoginPinScreen> createState() => _LoginPinScreenState();
}

class _LoginPinScreenState extends ConsumerState<LoginPinScreen>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handleDigit(String digit) {
    if (_pin.length < 6) {
      HapticFeedback.lightImpact();
      setState(() => _pin += digit);

      // if (_pin.length == 4) _submitPin(); // 👈 CORRECCIÓN 1: Auto-submit desactivado.
    }
  }

  void _deleteLast() {
    if (_pin.isNotEmpty) {
      HapticFeedback.selectionClick();
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  void _submitPin() {
    FocusScope.of(context).unfocus();

    // 👇 CORRECCIÓN 2: Se envía solo si el PIN tiene 6 dígitos.
    if (_pin.length == 6) {
      ref.read(loginControllerProvider.notifier).login(
        widget.extra['numero']!,
        _pin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;
    final tipo = widget.extra['tipo'];
    final numero = widget.extra['numero'];

    // 👉 ref.listen DEBE ESTAR DENTRO DE BUILD (CORRECTO)
    ref.listen<AsyncValue<void>>(
      loginControllerProvider,
          (previous, next) {
        if (next is AsyncData && !next.isLoading) {
          // No navegamos desde aquí, esperamos al GoRouter
          // context.go('/dashboard');
        }

        if (next is AsyncError) {
          _shakeController.forward(from: 0);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PIN incorrecto'),
              backgroundColor: Colors.red,
            ),
          );

          setState(() => _pin = '');
        }
      },
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                "Ingresa tu PIN",
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$tipo: $numero",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 35),

              /// 🔵 ANIMACIÓN SHAKE DEL PIN
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final offset =
                      math.sin(_shakeController.value * math.pi * 10) * 10;
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: child,
                  );
                },
                child: _buildPinCircles(theme),
              ),

              const SizedBox(height: 40),

              // 👈 CORRECCIÓN 3: Se quitó el 'Expanded' para que el numpad no ocupe todo el espacio
              _buildNumberPad(),

              const Spacer(), // 👈 CORRECCIÓN 3.1: Se añadió un Spacer para empujar el botón hacia arriba

              const SizedBox(height: 25),

              isLoading
                  ? const SpinKitFoldingCube(
                color: AppTheme.primaryColor,
                size: 48,
              )
                  : FilledButton(
                // 👇 CORRECCIÓN 4: El botón se activa solo si el PIN tiene 6 dígitos.
                onPressed: (_pin.length == 6) ? _submitPin : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Entrar",
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🔵 PIN CIRCLES
  Widget _buildPinCircles(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final filled = index < _pin.length;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          // Se ve un poco mejor si el círculo lleno es más grande
          width: filled ? 18 : 16,
          height: filled ? 18 : 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        );
      }),
    );
  }

  // 🔢 NUMPAD
  Widget _buildNumberPad() {
    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map(_buildDigitButton).toList(),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 72),
            _buildDigitButton('0'),
            _buildIconButton(Icons.backspace_outlined, _deleteLast), // Ícono actualizado
          ],
        ),
      ],
    );
  }

  Widget _buildDigitButton(String digit) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _handleDigit(digit),
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surfaceVariant.withOpacity(0.7), // Color más sutil
        ),
        child: Text(
          digit,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600, // Un poco más grueso
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent, // El botón de borrar es mejor sin fondo
        ),
        child: Icon(icon, size: 28, color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}