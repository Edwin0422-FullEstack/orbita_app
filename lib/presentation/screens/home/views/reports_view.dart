// lib/presentation/screens/home/views/reports_view.dart
import 'package:flutter/material.dart';

// 👈 Renombramos la clase para que sea semántica
class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface, // Fondo limpio
      appBar: AppBar(
        title: const Text(
          'Centro de ayuda', // 👈 Título de la captura
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. Lista con efecto de rebote
          ScrollConfiguration(
            behavior: const _BouncingScrollBehavior(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              children: [
                // Tarjeta 1: Preguntas frecuentes
                _buildHelpCard(
                  context: context,
                  icon: Icons.help_outline_rounded,
                  iconBgColor: colors.primary.withOpacity(0.1),
                  iconColor: colors.primary,
                  title: 'Preguntas frecuentes',
                  subtitle:
                  'Aquí encontrarás una serie de respuestas que hemos preparado para las dudas que puedas tener sobre Orbita.',
                  onTap: () {},
                ),

                const SizedBox(height: 16),

                // Tarjeta 2: Información legal
                _buildHelpCard(
                  context: context,
                  icon: Icons.shield_outlined,
                  iconBgColor: colors.secondary.withOpacity(0.1),
                  iconColor: colors.secondary,
                  title: 'Información legal',
                  subtitle:
                  'Conoce toda la información legal sobre tu cuenta en Orbita.',
                  onTap: () {},
                ),

                const SizedBox(height: 16),

                // Tarjeta 3: Tarifas
                _buildHelpCard(
                  context: context,
                  icon: Icons.receipt_long_outlined,
                  iconBgColor: colors.tertiary.withOpacity(0.1),
                  iconColor: colors.tertiary,
                  title: 'Tarifas y métodos de pago',
                  subtitle:
                  'Aquí encontrarás toda la información sobre las tarifas y métodos de pago de Orbita.',
                  onTap: () {},
                ),

                const SizedBox(height: 100), // Espacio para el botón flotante
              ],
            ),
          ),

          // 2. Botón flotante de Chat (como en la captura)
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: () {
                // TODO: Abrir el chat de soporte
              },
              icon: const Icon(Icons.chat_bubble_rounded),
              label: const Text('Chat', style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget auxiliar para las tarjetas de ayuda (basado en la captura)
  Widget _buildHelpCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colors.surfaceContainerHighest, // Color de tarjeta sutil
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, // Para que el InkWell respete el borde
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Círculo del Ícono
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),

              const SizedBox(width: 16),

              // Textos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Clase auxiliar para el efecto de rebote (Bouncing Scroll)
class _BouncingScrollBehavior extends MaterialScrollBehavior {
  const _BouncingScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Forzamos la física de rebote de iOS en todas las plataformas
    return const BouncingScrollPhysics();
  }
}