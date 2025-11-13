import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:orbita/presentation/providers/session/session_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _orbitController;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25), // velocidad orbital
    )..repeat(); // 🔄 rotación infinita
  }

  @override
  void dispose() {
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionUser = ref.watch(sessionProvider);
    final colors = Theme.of(context).colorScheme;

    if (sessionUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Datos simulados
    final payments = [
      {"date": DateTime.now().add(const Duration(days: 5)), "amount": 15000},
      {"date": DateTime.now().add(const Duration(days: 12)), "amount": 20000},
      {"date": DateTime.now().add(const Duration(days: 20)), "amount": 15000},
    ];

    const rank = "Bronce";
    const nextLevel = "Plata";
    const progress = 0.25; // 25%
    const cupo = 50000;

    const rankColor = Color(0xFFCD7F32); // color bronce elegante

    return AnimatedBuilder(
      animation: _orbitController,
      builder: (context, _) {
        return Stack(
          children: [
            // 🌌 Fondo animado dinámico
            Positioned.fill(
              child: CustomPaint(
                painter: _OrbitalBackgroundPainter(
                  colors: colors,
                  rotation: _orbitController.value * 2 * math.pi,
                ),
              ),
            ),

            // 🪐 Contenido principal
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(sessionUser.fullName, sessionUser.email, colors),
                  const SizedBox(height: 35),
                  _buildFinancialSummary(colors, cupo),
                  const SizedBox(height: 30),
                  _buildRankingChart(rank, nextLevel, progress, rankColor, colors),
                  const SizedBox(height: 40),
                  _buildUpcomingPayments(payments, colors),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // 🌙 Header centrado
  Widget _buildHeader(String name, String email, ColorScheme colors) {
    final firstName = name.split(' ').first;
    return Column(
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor: colors.primaryContainer.withOpacity(0.3),
          child: Icon(Icons.person_rounded, size: 45, color: colors.primary),
        ),
        const SizedBox(height: 12),
        Text(
          "¡Hola, $firstName!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        Text(email, style: TextStyle(color: colors.onSurfaceVariant)),
      ],
    );
  }

  // 💳 Tarjeta con cupo actual
  Widget _buildFinancialSummary(ColorScheme colors, int cupo) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            colors.primary.withOpacity(0.9),
            colors.secondaryContainer.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Text(
            "Tu cupo disponible",
            style: TextStyle(
              color: colors.onPrimary.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "\$${cupo.toStringAsFixed(0)} COP",
            style: TextStyle(
              color: colors.onPrimary,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Chip(
            label: const Text("Nivel actual: BRONCE 🪙",
                style: TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFFCD7F32),
          ),
        ],
      ),
    );
  }

  // 🏆 Ranking Orbita circular
  Widget _buildRankingChart(
      String rank,
      String nextLevel,
      double progress,
      Color rankColor,
      ColorScheme colors,
      ) {
    final data = [
      {"label": "Progreso", "value": progress * 100},
      {"label": "Restante", "value": (1 - progress) * 100},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text("Tu Ranking Orbita",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: SfCircularChart(
              annotations: [
                CircularChartAnnotation(
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(rank,
                          style: TextStyle(
                              color: rankColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      Text("→ Próximo: $nextLevel",
                          style: TextStyle(
                              color: colors.onSurfaceVariant, fontSize: 12)),
                    ],
                  ),
                ),
              ],
              series: <CircularSeries>[
                DoughnutSeries<Map<String, dynamic>, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d["label"],
                  yValueMapper: (d, _) => d["value"],
                  innerRadius: "70%",
                  radius: "100%",
                  pointColorMapper: (d, _) =>
                  d["label"] == "Progreso" ? rankColor : colors.surfaceVariant,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 📅 Próximos pagos
  Widget _buildUpcomingPayments(
      List<Map<String, dynamic>> payments, ColorScheme colors) {
    final formatter = DateFormat('EEE d MMM', 'es_CO');
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Próximos Pagos",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          ...payments.map((p) {
            return ListTile(
              leading: const Icon(Icons.calendar_month_rounded),
              title: Text(
                formatter.format(p["date"]).toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text("Monto: \$${p["amount"].toStringAsFixed(0)} COP"),
              trailing: Chip(
                label: const Text("Pendiente", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.orange.shade400,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// 🌌 Fondo orbital animado con anillos dinámicos tipo Saturno
class _OrbitalBackgroundPainter extends CustomPainter {
  final ColorScheme colors;
  final double rotation;

  _OrbitalBackgroundPainter({required this.colors, required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.38);

    // 🎨 Anillos orbitales
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = SweepGradient(
        startAngle: rotation,
        endAngle: rotation + 2 * math.pi,
        colors: [
          colors.primary.withOpacity(0.3),
          colors.secondary.withOpacity(0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 250));

    for (int i = 0; i < 3; i++) {
      final radius = 150.0 + i * 50;
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: radius * 1.4,
          height: radius * 0.9,
        ),
        paint,
      );
    }

    // 🌠 Pequeños planetas que orbitan
    final glow = Paint()
      ..color = colors.primary.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    final orbit1 = Offset(
      center.dx + 120 * math.cos(rotation),
      center.dy + 60 * math.sin(rotation),
    );
    final orbit2 = Offset(
      center.dx - 90 * math.cos(rotation + math.pi / 2),
      center.dy - 40 * math.sin(rotation + math.pi / 2),
    );

    canvas.drawCircle(orbit1, 12, glow);
    canvas.drawCircle(orbit2, 8, glow);
  }

  @override
  bool shouldRepaint(covariant _OrbitalBackgroundPainter oldDelegate) => true;
}
