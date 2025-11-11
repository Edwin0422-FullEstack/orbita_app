// lib/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:orbita/domain/entities/user.dart'; // Importamos la entidad Pura

part 'user_model.freezed.dart'; // ¡Dará error hasta que corras el generador!
part 'user_model.g.dart';      // ¡Dará error hasta que corras el generador!

@freezed
class UserModel with _$UserModel {

  // Este es el DTO. Nota el 'implements User'
  // Esto es un "truco" para que Dart nos obligue a que el DTO
  // cumpla con la forma de la entidad, pero no es estrictamente necesario.
  const factory UserModel({
    @JsonKey(name: '_id') // Mapea el JSON de la API (ej: MongoDB ID)
    required String id,
    required String email,
    @JsonKey(name: 'full_name') // Mapea 'full_name' del JSON
    required String fullName,
    @JsonKey(name: 'access_token') // La API nos devuelve el token aquí
    String? token,
  }) = _UserModel;

  // El constructor que sabe leer JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// --- EXTENSIÓN DE MAPEO ---
// Aquí está la magia de Clean Architecture.
// Creamos un método 'mapper' para convertir este DTO (Datos)
// en nuestra Entidad (Dominio).
extension UserModelMapper on UserModel {
  User toEntity() {
    return User(
      id: id,
      email: email,
      fullName: fullName,
      token: token,
      isVerified: false,
    );
  }
}