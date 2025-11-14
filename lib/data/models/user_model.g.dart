// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['_id'] as String,
  email: json['email'] as String,
  fullName: json['full_name'] as String,
  token: json['access_token'] as String?,
  isVerified: json['isVerified'] as bool? ?? false,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'access_token': instance.token,
      'isVerified': instance.isVerified,
    };
