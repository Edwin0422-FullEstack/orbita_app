// lib/presentation/providers/kyc/kyc_location_provider.dart
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'kyc_location_provider.g.dart'; // Corre el build_runner después

// 1. Un provider que maneja el estado asíncrono de obtener la ubicación
@riverpod
class KycLocation extends _$KycLocation {

  @override
  AsyncValue<Position?> build() {
    // Estado inicial: sin datos
    return const AsyncValue.data(null);
  }

  /// Pide permisos y obtiene la ubicación actual
  Future<void> getLocation() async {
    state = const AsyncValue.loading();
    try {
      // 2. Llama a la lógica de negocio (separada abajo)
      final position = await _determinePosition();
      state = AsyncValue.data(position);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  /// Lógica de negocio para Geolocator
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Revisa si el servicio de GPS está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Los servicios de ubicación están deshabilitados.');
    }

    // 2. Revisa los permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de ubicación fueron denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // El usuario bloqueó la app permanentemente
      throw Exception('Los permisos de ubicación están denegados permanentemente.');
    }

    // 3. Obtiene la ubicación (con precisión alta - fintech)
    return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        )
    );
  }
}