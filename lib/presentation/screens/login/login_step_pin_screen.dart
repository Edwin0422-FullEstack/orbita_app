import 'package:flutter/material.dart';
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

class _LoginPinScreenState extends ConsumerState<LoginPinScreen> {
  String _pin = '';

  void _handleDigit(String digit) {
    if (_pin.length < 6) {
      setState(() {
        _pin += digit;
      });
    }
  }

  void _deleteLast() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _submitPin() {
    if (_pin.length >= 4) {
      FocusScope.of(context).unfocus();
      ref.read(loginControllerProvider.notifier).login(
        widget.extra['numero']!,
        _pin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(loginControllerProvider).isLoading;
    final tipo = widget.extra['tipo'];
    final numero = widget.extra['numero'];

    ref.listen(loginControllerProvider, (previous, next) {
      if (next is AsyncData<void> && !next.isLoading) {
        context.go('/dashboard');
      }
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}'), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingresa tu clave"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text("Tipo: $tipo\nDocumento: $numero", style: theme.textTheme.bodyMedium),
              const SizedBox(height: 32),

              // PIN CIRCLES
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  final filled = index < _pin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? theme.colorScheme.primary : Colors.grey.shade300,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 48),

              // TECLADO NUMÉRICO
              _buildNumberPad(),

              const SizedBox(height: 32),

              // BOTÓN O SPINNER
              isLoading
                  ? const SpinKitFoldingCube(
                color: AppTheme.primaryColor,
                size: 48,
              )
                  : FilledButton(
                onPressed: (_pin.length < 4) ? null : _submitPin,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text("Entrar", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            const SizedBox(width: 72), // Espacio vacíos
            _buildDigitButton('0'),
            _buildIconButton(Icons.backspace, _deleteLast),
          ],
        ),
      ],
    );
  }

  Widget _buildDigitButton(String digit) {
    return GestureDetector(
      onTap: () => _handleDigit(digit),
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        child: Text(
          digit,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        child: Icon(icon, size: 28),
      ),
    );
  }
}
