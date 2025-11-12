// lib/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:orbita/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '_id') required String id,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'access_token') String? token,
    // ¡AÑADIDO!
    required bool isVerified,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelMapper on UserModel {
  User toEntity() {
    return User(
      id: id,
      email: email,
      fullName: fullName,
      token: token,
      // ¡CORREGIDO!
      isVerified: isVerified,
    );
  }
}