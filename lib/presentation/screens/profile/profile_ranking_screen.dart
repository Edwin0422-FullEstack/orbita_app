import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/presentation/providers/profile/ranking_provider.dart';
import 'package:orbita/presentation/providers/session/session_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ProfileRankingScreen extends ConsumerWidget {
  const ProfileRankingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final user = ref.watch(sessionProvider);
    final rankingState = ref.watch(rankingProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final rankColor = getColorForRank(rankingState.currentRank);
    final progressValue = rankingState.progressPercent * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Nivel Orbita'),
        centerTitle: true,
        elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colors.primary),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.go('/clients'); // ruta donde quieres volver
              }
            },
          ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ===============================
            // ⭐ TARJETA DE USUARIO PREMIUM
            // ===============================
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    rankColor.withOpacity(0.85),
                    rankColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: rankColor.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 38,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Nombre del usuario
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // ⭐ Categoría con BRONCE en cursiva y color
                        RichText(
                          text: TextSpan(
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                            ),
                            children: const [
                              TextSpan(text: "Categoría: "),
                              TextSpan(
                                text: "BRONCE",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF522901), // Bronce
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

            const SizedBox(height: 32),

            // ===============================
            // ⭐ GAUGE DE PROGRESO
            // ===============================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Text(
                    "Progreso hacia el siguiente nivel",
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    height: 260,
                    child: SfRadialGauge(
                      axes: [
                        RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          showLabels: false,
                          showTicks: false,
                          startAngle: 180,
                          endAngle: 0,
                          axisLineStyle: const AxisLineStyle(
                            thickness: 0.20,
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          pointers: [
                            RangePointer(
                              value: progressValue,
                              color: rankColor,
                              width: 0.20,
                              sizeUnit: GaugeSizeUnit.factor,
                              enableAnimation: true,
                              animationDuration: 1000,
                            ),
                          ],
                          annotations: [
                            GaugeAnnotation(
                              widget: Text(
                                "${progressValue.toStringAsFixed(0)}%",
                                style: textTheme.displaySmall?.copyWith(
                                  color: rankColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              angle: 90,
                              positionFactor: 0.7,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    rankingState.nextRankMessage,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ===============================
            // ⭐ LISTA DE RANGOS
            // ===============================
            _buildRankList(
              currentRank: rankingState.currentRank,
              colors: colors,
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // ⭐ LISTA DE RANGOS CON TEXTO BLANCO PARA NO ACTIVOS
  // =====================================================
  Widget _buildRankList({
    required UserRank currentRank,
    required ColorScheme colors,
  }) {
    final allRanks = UserRank.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Progresión de niveles",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),

        ...allRanks.map((rank) {
          final rankColor = getColorForRank(rank);
          final isActive = rank == currentRank;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isActive
                  ? rankColor.withOpacity(0.22)
                  : colors.surfaceContainerHighest,
              border: Border.all(
                color: isActive ? rankColor : Colors.transparent,
                width: 1.7,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isActive ? Icons.verified_rounded : Icons.circle_outlined,
                  color: rankColor,
                  size: 28,
                ),
                const SizedBox(width: 14),
                Text(
                  rank.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    color: isActive ? rankColor : Colors.white,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
