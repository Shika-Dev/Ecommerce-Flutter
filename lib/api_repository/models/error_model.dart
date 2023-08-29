import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_model.g.dart';

@JsonSerializable()
class ErrorData extends Equatable {
  const ErrorData({
    this.errorCode,
    this.errorMessage,
  });

  final String? errorCode;
  final String? errorMessage;

  factory ErrorData.fromJson(Map<String, dynamic> json) =>
      _$ErrorDataFromJson(json);

  @override
  List<Object?> get props => [errorCode, errorMessage];
}
