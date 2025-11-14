// lib/presentation/screens/home/views/clients_view.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/presentation/providers/session/session_provider.dart';

class ClientsView extends ConsumerWidget {
  const ClientsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final sessionUser = ref.watch(sessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mi Orbita",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ScrollConfiguration(
        behavior: const _BouncingScrollBehavior(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👉 Card de usuario clickeable que lleva al ranking
              GestureDetector(
                onTap: () {
                  context.go('/profile/ranking');
                },
                child: _buildUserCard(
                  context,
                  colors,
                  textTheme,
                  sessionUser?.fullName ?? "Usuario Orbita",
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Opciones rápidas",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 USER CARD PREMIUM (con icono BRONCE y categoría BRONCE)
  Widget _buildUserCard(
      BuildContext context,
      ColorScheme colors,
      TextTheme textTheme,
      String userName,
      ) {
    // Color bronce consistente
    const bronzeColor = Color(0xFFCD7F32);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 30, end: 0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: Opacity(opacity: 1 - (value / 30), child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.primary.withOpacity(0.85),
              colors.primary.withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white.withOpacity(0.15),
              child: const Icon(
                Icons.person_rounded,
                size: 34,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre + icono de verificado BRONCE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          userName,
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.verified_rounded,
                        color: bronzeColor,
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Categoría: BRONCE (solo BRONCE en bronce y cursiva)
                  RichText(
                    text: TextSpan(
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                      children: const [
                        TextSpan(text: "Categoría: "),
                        TextSpan(
                          text: "BRONCE",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: bronzeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 GRID PREMIUM
  Widget _buildGrid(BuildContext context) {
    final items = [
      _GridItem(
        icon: Icons.person_outline,
        label: "Información personal",
        color: const Color(0xFF007BFF),
      ),
      _GridItem(
        icon: Icons.account_balance_rounded,
        label: "Cuenta Bancaria",
        color: const Color(0xFF343A40),
      ),
      _GridItem(
        icon: Icons.group_add_outlined,
        label: "Referidos",
        color: const Color(0xFF17A2B8),
      ),
      _GridItem(
        icon: Icons.forum_rounded,
        label: "Comunidad",
        color: const Color(0xFF0056B3),
      ),
      _GridItem(
        icon: Icons.help_outline_rounded,
        label: "Ayuda",
        color: const Color(0xFF495057),
      ),
      _GridItem(
        icon: Icons.settings_rounded,
        label: "Ajustes Generales",
        color: const Color(0xFF495057),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (_, index) => _AnimatedGridButton(item: items[index]),
    );
  }
}

/// 🔥 GRID ITEM ANIMADO PREMIUM
class _AnimatedGridButton extends StatefulWidget {
  final _GridItem item;

  const _AnimatedGridButton({required this.item});

  @override
  State<_AnimatedGridButton> createState() => _AnimatedGridButtonState();
}

class _AnimatedGridButtonState extends State<_AnimatedGridButton> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.94);
  void _onTapUp(_) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: item.onTap ?? () {},
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: item.color.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(item.icon, size: 36, color: Colors.white),
              Text(
                item.label,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  _GridItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });
}

/// Rebote tipo iOS
class _BouncingScrollBehavior extends MaterialScrollBehavior {
  const _BouncingScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
