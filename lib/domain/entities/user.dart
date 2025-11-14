// lib/domain/entities/user.dart
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String fullName,
    String? token,
    required bool isVerified,
  }) = _User;
}
