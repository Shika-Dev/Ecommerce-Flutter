import 'package:ecom_web_flutter/api_repository/models/error_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_in_model.g.dart';

@JsonSerializable()
class SignInModel extends Equatable {
  const SignInModel({this.errors, this.data});

  final ErrorData? errors;
  final SignInData? data;

  factory SignInModel.fromJson(Map<String, dynamic> json) =>
      _$SignInModelFromJson(json);

  @override
  List<Object?> get props => [data, errors];
}

@JsonSerializable()
class SignInData extends Equatable {
  const SignInData({required this.token});
  final TokenData token;

  factory SignInData.fromJson(Map<String, dynamic> json) =>
      _$SignInDataFromJson(json);

  @override
  List<Object?> get props => [token];
}

@JsonSerializable()
class TokenData extends Equatable {
  const TokenData({required this.token});

  final String token;

  factory TokenData.fromJson(Map<String, dynamic> json) =>
      _$TokenDataFromJson(json);

  @override
  List<Object?> get props => [token];
}
