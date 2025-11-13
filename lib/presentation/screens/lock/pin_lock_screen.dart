// lib/presentation/screens/lock/pin_lock_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbita/core/providers/local_auth_provider.dart';
import 'package:orbita/presentation/providers/app_lock/app_lock_provider.dart'; // 👈 Tu nuevo provider
import 'package:local_auth/local_auth.dart';

class PinLockScreen extends ConsumerStatefulWidget {
  const PinLockScreen({super.key});

  @override
  ConsumerState<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends ConsumerState<PinLockScreen> {
  String _pin = ""; // Almacena los dígitos ingresados

  @override
  void initState() {
    super.initState();
    // Intenta biometría (Huella/FaceID) apenas abre la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticateWithBiometrics();
    });
  }

  /// Lógica de Biometría
  Future<void> _authenticateWithBiometrics() async {
    final localAuth = ref.read(localAuthProvider);

    // Verificamos si el dispositivo tiene hardware biométrico
    final canCheck = await localAuth.canCheckBiometrics;
    if (!canCheck) return;

    try {
      final didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Desbloquea para entrar a Orbita',
      );

      if (didAuthenticate) {
        // ✅ ¡Éxito! Desbloqueamos la app
        ref.read(appLockProvider.notifier).unlock();
      }
    } catch (e) {
      // Si falla o cancela, se queda en la pantalla de PIN
      debugPrint("Error biométrico: $e");
    }
  }

  /// Lógica del PIN numérico
  void _onNumberPress(String number) {
    if (_pin.length < 4) {
      setState(() {
        _pin += number;
      });
    }

    // Simulación: Si el PIN llega a 4 dígitos
    if (_pin.length == 4) {
      _validatePin();
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _validatePin() async {
    // TODO: Aquí deberías validar contra un PIN guardado en SecureStorage
    // Por ahora, simulamos que cualquier PIN de 4 dígitos sirve o uno fijo '1234'
    if (_pin == "1234") {
      ref.read(appLockProvider.notifier).unlock();
    } else {
      // Vibrar o mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN Incorrecto'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      setState(() => _pin = ""); // Limpiar
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            // 1. Icono y Título
            Icon(Icons.lock_outline_rounded, size: 40, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              "Ingresa tu PIN",
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // 2. Indicadores de PIN (bolitas)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                    border: isFilled ? null : Border.all(color: colorScheme.outline),
                  ),
                );
              }),
            ),

            const Spacer(flex: 2),

            // 3. Teclado Numérico
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  // Teclas especiales
                  if (index == 9) {
                    // Botón Huella
                    return IconButton(
                      onPressed: _authenticateWithBiometrics,
                      icon: Icon(Icons.fingerprint, size: 32, color: colorScheme.primary),
                    );
                  }
                  if (index == 11) {
                    // Botón Borrar
                    return IconButton(
                      onPressed: _onBackspace,
                      icon: const Icon(Icons.backspace_outlined, size: 24),
                    );
                  }

                  // Números 0-9
                  // Mapeo: index 0->1, 1->2... index 10->0
                  final number = index == 10 ? "0" : "${index + 1}";

                  return InkWell(
                    onTap: () => _onNumberPress(number),
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      ),
                      child: Text(
                        number,
                        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            TextButton(
                onPressed: () {
                  // TODO: Lógica de "¿Olvidaste tu PIN?" -> Cerrar sesión
                },
                child: const Text("¿Olvidaste tu PIN?")
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}