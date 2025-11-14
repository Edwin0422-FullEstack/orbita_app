import 'dart:math' as math;
import 'dart:ui'; // 👈 ¡IMPORTANTE! Necesario para ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/presentation/providers/home/home_controller.dart';

final _isMenuVisibleProvider = StateProvider.autoDispose<bool>((_) => false);

class HomeScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

// 👇 CORRECCIÓN 1: Cambiado a 'TickerProviderStateMixin' (plural)
// para manejar múltiples controladores de animación.
class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller; // Para el menú FAB
  late AnimationController _auroraController; // 👈 NUEVO: Para la aurora

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // 👈 NUEVO: Controlador para la animación de fondo
    _auroraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // 20 segundos por ciclo
    )..repeat(reverse: true); // Loop infinito (ida y vuelta)
  }

  @override
  void dispose() {
    _controller?.dispose();
    _auroraController.dispose(); // 👈 NUEVO: Disponer el controlador
    super.dispose();
  }

  void _toggleMenu() {
    // ... (Tu código de _toggleMenu se queda igual)
    final notifier = ref.read(_isMenuVisibleProvider.notifier);
    final isOpen = ref.read(_isMenuVisibleProvider);

    if (isOpen) {
      _controller?.reverse();
    } else {
      _controller?.forward();
    }
    notifier.state = !isOpen;
  }

  void _confirmLogout(BuildContext context) {
    // ... (Tu código de _confirmLogout se queda igual)
    final isLoading = ref.read(homeControllerProvider).isLoading;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Cerrar sesión?"),
        content: const Text("¿Seguro que deseas cerrar tu sesión en Orbita?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          FilledButton(
            onPressed: isLoading
                ? null
                : () {
              Navigator.pop(context);
              ref.read(homeControllerProvider.notifier).logout();
            },
            child: const Text("Salir"),
          ),
        ],
      ),
    );
  }

  void _openNotifications(BuildContext context) {
    // ... (Tu código de _openNotifications se queda igual)
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        final colors = Theme.of(context).colorScheme;
        return SizedBox(
          height: 350,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Notificaciones",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text("Bienvenido a Orbita 💜"),
                      subtitle:
                      Text("Tu experiencia financiera comienza hoy"),
                    ),
                    ListTile(
                      leading: Icon(Icons.flash_on),
                      title: Text("Tu cupo está inactivo"),
                      subtitle: Text(
                          "Conecta tu cuenta bancaria para activarlo."),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller!;
    final homeState = ref.watch(homeControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final currentIndex = widget.navigationShell.currentIndex;
    final isMenuVisible = ref.watch(_isMenuVisibleProvider);

    return Scaffold(
      extendBody: true,

      // Tu AppBar premium se queda igual
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          // ... (Tu código de AppBar)
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Orbita',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
                Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: () => _openNotifications(context),
                          icon: Icon(
                            Icons.notifications_none_rounded,
                            size: 28,
                            color: colorScheme.primary,
                          ),
                        ),
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      tooltip: "Cerrar sesión",
                      onPressed: () => _confirmLogout(context),
                      icon: Icon(
                        Icons.logout_rounded,
                        color: colorScheme.error,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      // 👇 CORRECCIÓN 2: El 'body' ahora es un Stack
      body: Stack(
        children: [
          // --- CAPA 1: FONDO DE AURORA ANIMADO ---
          _buildAuroraBackground(colorScheme, _auroraController),

          // --- CAPA 2: TU CONTENIDO (EL NAVIGATION SHELL) ---
          ScrollConfiguration(
            behavior: const _BouncingScrollBehavior(),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) {
                final fade = FadeTransition(opacity: animation, child: child);
                final slide = SlideTransition(
                  position: Tween(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: fade,
                );
                return slide;
              },
              child: widget.navigationShell,
            ),
          ),
        ],
      ),

      // Tu FAB y BottomNav se quedan igual
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AnimatedBuilder(
        // ... (Tu código de FAB)
        animation: controller,
        builder: (context, _) {
          final t = controller.value;
          final rotation = math.pi / 4 * t;
          final borderRadius = BorderRadius.circular(24 - 16 * t);

          return Transform.rotate(
            angle: rotation,
            child: GestureDetector(
              onTap: _toggleMenu,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.4),
                      blurRadius: isMenuVisible ? 20 : 10,
                      spreadRadius: isMenuVisible ? 2 : 0,
                    ),
                  ],
                ),
                child: Icon(
                  isMenuVisible ? Icons.close_rounded : Icons.menu_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: AnimatedBuilder(
        // ... (Tu código de BottomNav)
        animation: controller,
        builder: (context, _) {
          final slide = 1 - controller.value;
          final opacity = controller.value;

          return Transform.translate(
            offset: Offset(0, 100 * slide),
            child: Opacity(
              opacity: opacity,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.95),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: _buildBottomNav(
                  context,
                  colorScheme,
                  currentIndex,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav(
      BuildContext context, ColorScheme colorScheme, int currentIndex) {
    // ... (Tu código de _buildBottomNav se queda igual)
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navButton(context, Icons.home_rounded, 'Inicio', 0, currentIndex),
            _navButton(context, Icons.attach_money_rounded, 'Prestamos', 1, currentIndex),
            const SizedBox(width: 56),
            _navButton(context, Icons.star_rounded, 'Mi Orbita', 2, currentIndex),
            _navButton(context, Icons.settings_rounded, 'Ajustes', 3, currentIndex),
          ],
        ),
      ),
    );
  }

  Widget _navButton(
      BuildContext context, IconData icon, String label, int index, int currentIndex) {
    // ... (Tu código de _navButton se queda igual)
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = index == currentIndex;
    final color = isActive ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: () => widget.navigationShell.goBranch(index),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 4),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isActive ? 1 : 0.6,
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BouncingScrollBehavior extends MaterialScrollBehavior {
  // ... (Tu código de _BouncingScrollBehavior se queda igual)
  const _BouncingScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

// ----------------------------------------------
// --- 💎 WIDGETS DE FONDO AURORA (NUEVOS) 💎 ---
// ----------------------------------------------

Widget _buildAuroraBackground(ColorScheme colors, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final value = animation.value;
      // Usamos senos y cosenos para un movimiento circular suave
      final sinValue = math.sin(value * 2 * math.pi); // -1 a 1
      final cosValue = math.cos(value * 2 * math.pi); // 1 a -1

      // Obtenemos el tamaño de la pantalla
      final size = MediaQuery.of(context).size;

      return Stack(
        fit: StackFit.expand,
        children: [
          // El fondo base (blanco/gris de tu tema)
          Container(color: colors.surface),

          // --- Glow 1 (Color Primario) ---
          Positioned(
            // Se mueve en un círculo grande
            top: size.height * 0.1 + (sinValue * size.height * 0.2),
            left: size.width * 0.2 + (cosValue * size.width * 0.3),
            child: _buildGlow(colors.primary, size.width * 1.5),
          ),

          // --- Glow 2 (Color Secundario) ---
          Positioned(
            // Se mueve en un círculo opuesto
            bottom: size.height * 0.05 + (cosValue * size.height * 0.2),
            right: size.width * 0.1 + (sinValue * size.width * 0.3),
            child: _buildGlow(colors.secondary, size.width * 1.2),
          ),

          // --- El Filtro de Blur (La Magia) ---
          // Esto difumina los círculos de color de arriba
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(color: Colors.transparent),
          ),
        ],
      );
    },
  );
}

// Un círculo de gradiente radial para simular un "glow"
Widget _buildGlow(Color color, double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [
          color.withOpacity(0.12), // 👈 Opacidad sutil
          color.withOpacity(0.0)   // Se difumina a transparente
        ],
        stops: const [0.0, 1.0],
      ),
    ),
  );
}