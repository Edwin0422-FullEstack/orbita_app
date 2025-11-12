// lib/presentation/screens/login/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/core/providers/local_auth_provider.dart'; // <-- 1. Biometría
import 'package:orbita/presentation/providers/login/login_controller.dart';

// --- Provider de estado local (visibilidad de contraseña) ---
final _passwordVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);

// --- 2. Añadimos 'SingleTickerProviderStateMixin' para animación ---
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin { // <-- 2.
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // --- 3. Controladores de Animación ---
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Configuración del controlador de animación
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Duración total
    );

    // Animación de Fade (opacidad)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Animación de Slide (deslizamiento)
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    // Iniciar la animación
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose(); // <-- 3.
    super.dispose();
  }

  /// --- 4. Método de Lógica Biométrica ---
  Future<void> _authenticateWithBiometrics() async {
    final localAuth = ref.read(localAuthProvider);
    final canCheck = await localAuth.canCheckBiometrics;

    if (!canCheck) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometría no disponible')),
        );
      }
      return;
    }

    try {
      final didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Por favor, autentu00edcate para iniciar sesiu00f3n en Orbita',
      );

      if (didAuthenticate) {
        // ¡ÉXITO!
        // En un flujo real, aquí leeríamos credenciales guardadas.
        // Como estamos en MOCK, llamamos al login con los datos quemados.
        ref.read(loginControllerProvider.notifier).login(
          'eduin.abello7@gmail.com',
          '123456',
        );
      }
    } catch (e) {
      // (Manejar error, ej. usuario canceló)
    }
  }

  /// Método de ayuda para manejar el submit
  void _submitLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      ref.read(loginControllerProvider.notifier).login(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;

    // --- El 'listener' se mantiene igual, es perfecto ---
    ref.listen(loginControllerProvider, (previous, next) {
      if (next is AsyncData<void> && !(next.isLoading)) {
        context.go('/dashboard');
      }
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar sesión: ${next.error}'),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    });

    // --- 5. Borde Redondeado Personalizado ---
    final roundedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0), // <-- 5.
      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
    );
    final enabledBorder = roundedBorder.copyWith(
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5)
    );

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Form(
                key: _formKey,
                // --- 6. Aplicamos Animación de Entrada ---
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- Logo ---
                        const Icon(
                          Icons.public,
                          size: 80,
                          color: Color(0xFF0052D4),
                        ),
                        const SizedBox(height: 16),

                        // --- Títulos ---
                        Text(
                          'Bienvenido a Orbita',
                          textAlign: TextAlign.center,
                          style: textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Inicia sesión para continuar',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 40),

                        // --- Email Field (con bordes M3) ---
                        TextFormField(
                          controller: _emailController,
                          enabled: !isLoading,
                          decoration: InputDecoration(
                            labelText: 'Correo Electrónico',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: roundedBorder,
                            enabledBorder: roundedBorder,
                            focusedBorder: enabledBorder,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 20),

                        // --- Password Field ---
                        Consumer(
                          builder: (context, ref, child) {
                            final isVisible = ref.watch(_passwordVisibleProvider);
                            return TextFormField(
                              controller: _passwordController,
                              enabled: !isLoading,
                              obscureText: !isVisible,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: roundedBorder,
                                enabledBorder: roundedBorder,
                                focusedBorder: enabledBorder,
                                suffixIcon: IconButton(
                                  icon: Icon(isVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () => ref
                                      .read(_passwordVisibleProvider.notifier)
                                      .state = !isVisible,
                                ),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: _validatePassword,
                            );
                          },
                        ),
                        const SizedBox(height: 40),

                        // --- 7. Botón de Login (con forma de píldora) ---
                        SizedBox(
                          height: 50,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0), // <-- 7.
                              ),
                            ),
                            onPressed: isLoading ? null : _submitLogin,
                            // --- 8. Animación de Switch MEJORADA ---
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                // Fade in/out
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: isLoading
                                  ? const SizedBox(
                                key: ValueKey('loader'), // Key es vital
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text(
                                'Ingresar',
                                key: ValueKey('text'), // Key es vital
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // --- 9. Botón de Biometría ---
                        IconButton(
                          onPressed: isLoading ? null : _authenticateWithBiometrics,
                          icon: Icon(
                            Icons.fingerprint,
                            size: 48,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Lógica de Validación (se mantiene igual) ---
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, ingresa tu correo';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Formato de correo no válido';
    return null;
  }
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, ingresa tu contraseña';
    if (value.length < 6) return 'Debe tener al menos 6 caracteres';
    return null;
  }
}