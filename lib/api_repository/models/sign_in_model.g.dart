// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInModel _$SignInModelFromJson(Map<String, dynamic> json) => SignInModel(
      errors: json['errors'] == null
          ? null
          : ErrorData.fromJson(json['errors'] as Map<String, dynamic>),
      data: json['data'] == null
          ? null
          : SignInData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignInModelToJson(SignInModel instance) =>
    <String, dynamic>{
      'errors': instance.errors,
      'data': instance.data,
    };

SignInData _$SignInDataFromJson(Map<String, dynamic> json) => SignInData(
      token: TokenData.fromJson(json['token'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignInDataToJson(SignInData instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

TokenData _$TokenDataFromJson(Map<String, dynamic> json) => TokenData(
      token: json['token'] as String,
    );

Map<String, dynamic> _$TokenDataToJson(TokenData instance) => <String, dynamic>{
      'token': instance.token,
    };
