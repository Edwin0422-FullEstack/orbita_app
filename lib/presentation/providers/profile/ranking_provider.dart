import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranking_provider.g.dart';

// 1. Definimos los rangos
enum UserRank { ninguno, bronce, cobre, plata, oro, diamante }

// 2. Modelo para el estado del provider
class RankingState {
  final UserRank currentRank;
  final double progressPercent; // 0.0 a 1.0
  final String nextRankMessage;

  RankingState({
    required this.currentRank,
    required this.progressPercent,
    required this.nextRankMessage,
  });
}

@riverpod
class Ranking extends _$Ranking {

  @override
  RankingState build() {
    // 3. MOCK: Aquí iría la lógica para leer el `sessionProvider`
    // y calcular el rango. Por ahora, lo quemamos.
    return RankingState(
        currentRank: UserRank.bronce,
        progressPercent: 0.75, // 75%
        nextRankMessage: "¡Te faltan 2 pagos al día para Cobre!"
    );
  }

// (Aquí irían métodos para actualizar el ranking)
}

// 4. Helper para obtener los "colores" de cada rango
Color getColorForRank(UserRank rank) {
  switch (rank) {
    case UserRank.bronce:
      return const Color(0xFFCD7F32); // Bronce
    case UserRank.cobre:
      return const Color(0xFFB87333); // Cobre
    case UserRank.plata:
      return const Color(0xFFC0C0C0); // Plata
    case UserRank.oro:
      return const Color(0xFFFFD700); // Oro
    case UserRank.diamante:
      return const Color(0xFFB9F2FF); // Diamante
    default:
      return Colors.grey;
  }
}