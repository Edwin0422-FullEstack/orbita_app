// lib/presentation/screens/home/home_screen.dart
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/presentation/providers/home/home_controller.dart';
// ¡YA NO NECESITAMOS IMPORTAR LAS VISTAS AQUÍ!
// ¡YA NO NECESITAMOS EL SESSION_PROVIDER AQUÍ!

// Provider de estado del menú (sin cambios)
final _isFabMenuOpenProvider = StateProvider.autoDispose<bool>((_) => false);
// ¡ELIMINADO! Ya no necesitamos _currentPageIndexProvider

class HomeScreen extends ConsumerStatefulWidget {
  // 1. ¡EL GRAN CAMBIO!
  //    Acepta el 'Shell' que GoRouter nos provee.
  final StatefulNavigationShell navigationShell;

  const HomeScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {

  // ... (Toda la lógica de initState, dispose, _toggleFabMenu,
  //      y las animaciones se mantiene 100% IGUAL)

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _button1Anim;
  late Animation<double> _button2Anim;
  late Animation<double> _button3Anim;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.375).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _button1Anim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));
    _button2Anim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.15, 0.85, curve: Curves.easeOutCubic),
    ));
    _button3Anim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFabMenu() {
    final isMenuOpen = ref.read(_isFabMenuOpenProvider);
    if (isMenuOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    ref.read(_isFabMenuOpenProvider.notifier).state = !isMenuOpen;
  }

  // --- FIN LÓGICA DE ANIMACIÓN ---

  @override
  Widget build(BuildContext context) {
    // Lógica de Logout (sin cambios)
    final homeState = ref.watch(homeControllerProvider);
    final isLoading = homeState.isLoading;
    ref.listen(homeControllerProvider, (previous, next) {
      if (next is AsyncData<void> && !(next.isLoading)) {
        ref.read(_isFabMenuOpenProvider.notifier).state = false;
        context.go('/login');
      }
      if (next is AsyncError) { /* ... (manejo de error) */ }
    });

    // --- ¡AQUÍ ESTÁ LA CORRECCIÓN! ---
    // Añadimos el guion bajo que faltaba
    final isFabMenuOpen = ref.watch(_isFabMenuOpenProvider);
    // ----------------------------------

    final colorScheme = Theme.of(context).colorScheme;

    // 2. ¡EL GRAN CAMBIO!
    //    El índice actual ahora viene del 'Shell'
    final currentPageIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orbita'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: isLoading ? null : () {
              ref.read(homeControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFabMenu,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: Icon(isFabMenuOpen ? Icons.close : Icons.add),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: colorScheme.surfaceVariant.withOpacity(0.8),
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 3. ¡EL GRAN CAMBIO!
              //    El onPressed ahora llama a 'goBranch'
              _buildNavButton(
                context: context,
                icon: Icons.dashboard,
                label: 'Inicio',
                index: 0,
                currentIndex: currentPageIndex,
                onPressed: () => widget.navigationShell.goBranch(0),
              ),
              _buildNavButton(
                context: context,
                icon: Icons.monetization_on,
                label: 'Préstamos',
                index: 1,
                currentIndex: currentPageIndex,
                onPressed: () => widget.navigationShell.goBranch(1),
              ),
              const SizedBox(width: 48),
              _buildNavButton(
                context: context,
                icon: Icons.people,
                label: 'Clientes',
                index: 2,
                currentIndex: currentPageIndex,
                onPressed: () => widget.navigationShell.goBranch(2),
              ),
              _buildNavButton(
                context: context,
                icon: Icons.bar_chart,
                label: 'Reportes',
                index: 3,
                currentIndex: currentPageIndex,
                onPressed: () => widget.navigationShell.goBranch(3),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // --- CAPA 1: Contenido Principal (AHORA LIMPIO) ---
          // 4. ¡EL GRAN CAMBIO!
          //    El 'body' es simplemente el 'navigationShell'
          //    GoRouter se encarga de poner la vista correcta aquí.
          widget.navigationShell,

          // --- CAPA 2: Desenfoque (sin cambios) ---
          if (isFabMenuOpen)
            GestureDetector(
              onTap: _toggleFabMenu,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),

          // --- CAPA 3: Órbita (sin cambios) ---
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                // ... (toda la lógica de la órbita se mantiene igual) ...
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    _buildOrbitButton(
                      animation: _button1Anim,
                      angle: math.pi * 5 / 6,
                      icon: Icons.post_add,
                      label: 'Nuevo Préstamo',
                      // --- ¡AQUÍ ESTÁ EL CAMBIO! ---
                      onPressed: () {
                        // 1. Cierra el menú
                        _toggleFabMenu();
                        // 2. Navega a la sub-ruta.
                        //    GoRouter es lo bastante listo para
                        //    saber que es una sub-ruta de /loans.
                        context.go('/loans/new');
                      },
                    ),
                    _buildOrbitButton(
                      animation: _button2Anim,
                      angle: math.pi / 2,
                      icon: Icons.person_add,
                      label: 'Nuevo Cliente',
                      onPressed: () => _toggleFabMenu(),
                    ),
                    _buildOrbitButton(
                      animation: _button3Anim,
                      angle: math.pi / 6,
                      icon: Icons.payment,
                      label: 'Registrar Pago',
                      onPressed: () => _toggleFabMenu(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 5. ¡ELIMINADO!
  //    Ya no necesitamos _buildCurrentPage. GoRouter lo hace por nosotros.
  // Widget _buildCurrentPage(int index, bool isLoading, User? sessionUser) { ... }

  // --- Helper de Nav (sin cambios) ---
  Widget _buildNavButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onPressed,
  }) {
    // ... (código sin cambios)
    final colorScheme = Theme.of(context).colorScheme;
    final bool isActive = index == currentIndex;
    final color = isActive ? colorScheme.primary : colorScheme.onSurfaceVariant;
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 2),
              AnimatedOpacity(
                opacity: isActive ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  label,
                  style: TextStyle(color: color, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper de Órbita (sin cambios) ---
  Widget _buildOrbitButton({
    required Animation<double> animation,
    required double angle,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    // ... (código sin cambios)
    final animValue = animation.value;
    final radius = 120.0 * animValue;
    final offset = Offset(
      math.cos(angle) * radius,
      -math.sin(angle) * radius,
    );
    return Opacity(
      opacity: animValue,
      child: Transform.scale(
        scale: animValue,
        child: Transform.translate(
          offset: offset,
          child: Column(
            children: [
              FloatingActionButton.small(
                onPressed: onPressed,
                child: Icon(icon),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}