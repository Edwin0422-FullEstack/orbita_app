import 'dart:math' as math;
import 'package:flutter/material.dart';

class HomeMainView extends StatefulWidget {
  const HomeMainView({super.key});

  @override
  State<HomeMainView> createState() => _HomeMainViewState();
}

class _HomeMainViewState extends State<HomeMainView> {
  double amount = 500000;
  int months = 6;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Cálculo de cuotas
    final interest = 0.03; // 3%
    final cuota = (amount * interest) / (1 - (1 / (1 + interest)).pow(months));

    return SafeArea(
      child: ScrollConfiguration(
        behavior: const _BouncingScrollBehavior(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),

              // ========= TARJETA: CONECTA TU CUENTA =========
              _buildConnectBankCard(colors),

              const SizedBox(height: 30),

              // ========= TARJETA: CUPO INACTIVO =========
              _buildInactiveCreditCard(colors),

              const SizedBox(height: 35),

              // ========= HORIZONTAL PROMOS =========
              _buildHorizontalPromos(colors),

              const SizedBox(height: 40),

              // ========= CONSEJO DEL DÍA =========
              _buildDailyTip(colors),

              const SizedBox(height: 40),

              // ========= SIMULADOR DE PRÉSTAMO =========
              _buildLoanSimulator(colors, cuota),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  // =======================
  //    TARJETAS Y SECCIONES
  // =======================

  Widget _buildConnectBankCard(ColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withAlpha(30),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet_rounded, color: colors.primary),
              const SizedBox(width: 12),
              Text(
                'Conecta tu cuenta bancaria',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Vincula tu cuenta bancaria para activar tu cupo.',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              minimumSize: const Size(180, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: const Text('Conectar cuenta'),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveCreditCard(ColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withAlpha(30),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calculate_rounded, color: colors.primary, size: 28),
              const SizedBox(width: 12),
              Text(
                'Cupo inactivo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '\$0',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalPromos(ColorScheme colors) {
    return SizedBox(
      height: 125,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          _promoCard(
            colors: colors,
            text: '¿Tienes un negocio?\nImpulsa tu crecimiento este 2025',
          ),
          const SizedBox(width: 12),
          _promoCard(
            colors: colors,
            text: '¿Buscas liquidez rápida?\nSolicita tu cupo en minutos',
          ),
          const SizedBox(width: 12),
          _promoCard(
            colors: colors,
            text: '¿Quieres mejorar tus finanzas?\nObtén tips y beneficios',
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTip(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withAlpha(40),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consejo del día',
            style: TextStyle(
              color: colors.onPrimaryContainer,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mantén tus pagos al día para mejorar tu historial y obtener mejores cupos en el futuro.',
            style: TextStyle(
              color: colors.onPrimaryContainer.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // =======================
  //   SIMULADOR DIRECTO
  // =======================

  Widget _buildLoanSimulator(ColorScheme colors, double cuota) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Simulador de préstamo",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 20),

          Text("Monto: \$${amount.toStringAsFixed(0)}"),
          Slider(
            min: 100000,
            max: 5000000,
            value: amount,
            divisions: 50,
            label: amount.toStringAsFixed(0),
            onChanged: (v) => setState(() => amount = v),
          ),

          const SizedBox(height: 10),

          Text("Meses: $months"),
          Slider(
            min: 3,
            max: 36,
            divisions: 33,
            value: months.toDouble(),
            label: months.toString(),
            onChanged: (v) => setState(() => months = v.toInt()),
          ),

          const SizedBox(height: 20),

          Text(
            "Cuota estimada:",
            style: TextStyle(color: colors.onSurfaceVariant),
          ),

          const SizedBox(height: 6),

          Text(
            "\$${cuota.toStringAsFixed(0)} / mes",
            style: TextStyle(
              color: colors.primary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoCard({
    required ColorScheme colors,
    required String text,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withAlpha(40),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colors.onPrimaryContainer,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

extension on double {
  double pow(int exponent) => math.pow(this, exponent).toDouble();
}

class _BouncingScrollBehavior extends MaterialScrollBehavior {
  const _BouncingScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
