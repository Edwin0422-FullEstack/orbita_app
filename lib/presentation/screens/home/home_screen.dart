import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/presentation/providers/home/home_controller.dart';
import 'package:orbita/presentation/providers/session/session_provider.dart';
import 'package:orbita/core/router/app_router.dart';

final _isMenuVisibleProvider = StateProvider.autoDispose<bool>((_) => false);

class HomeScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    final notifier = ref.read(_isMenuVisibleProvider.notifier);
    final isOpen = ref.read(_isMenuVisibleProvider);
    if (isOpen) {
      _controller?.reverse();
    } else {
      _controller?.forward();
    }
    notifier.state = !isOpen;
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    final homeState = ref.watch(homeControllerProvider);
    final isLoading = homeState.isLoading;
    final colorScheme = Theme.of(context).colorScheme;
    final currentIndex = widget.navigationShell.currentIndex;
    final isMenuVisible = ref.watch(_isMenuVisibleProvider);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Orbita'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: isLoading
                ? null
                : () => ref.read(homeControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: widget.navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ✨ FAB animado (diamante)
      floatingActionButton: AnimatedBuilder(
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

      // ✨ Menú inferior oculto → aparece con animación
      bottomNavigationBar: AnimatedBuilder(
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
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.95),
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: _buildBottomNav(context, colorScheme, currentIndex),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- 🧭 Menú inferior para cliente ---
  Widget _buildBottomNav(
      BuildContext context, ColorScheme colorScheme, int currentIndex) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navButton(context, Icons.home_rounded, 'Inicio', 0, currentIndex),
            _navButton(context, Icons.attach_money_rounded, 'Mis Préstamos', 1, currentIndex),
            const SizedBox(width: 56),
            _navButton(context, Icons.star_rounded, 'Ranking', 2, currentIndex),
            _navButton(context, Icons.settings_rounded, 'Ajustes', 3, currentIndex),
          ],
        ),
      ),
    );
  }

  Widget _navButton(
      BuildContext context, IconData icon, String label, int index, int currentIndex) {
    final isActive = index == currentIndex;
    final colorScheme = Theme.of(context).colorScheme;
    final color = isActive ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: () => widget.navigationShell.goBranch(index),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 4),
              AnimatedOpacity(
                opacity: isActive ? 1.0 : 0.6,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight:
                    isActive ? FontWeight.bold : FontWeight.normal,
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
