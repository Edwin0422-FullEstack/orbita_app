// lib/domain/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart'; // ¡Dará error hasta que corras el generador!

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String fullName,
    String? token,
    required bool isVerified, // <-- AÑADIR ESTA LÍNEA
  }) = _User;
}