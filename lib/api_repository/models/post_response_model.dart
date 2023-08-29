import 'package:ecom_web_flutter/api_repository/models/error_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_response_model.g.dart';

@JsonSerializable()
class PostResponseModel extends Equatable {
  const PostResponseModel({this.errors, this.data});

  final ErrorData? errors;
  final dynamic data;

  factory PostResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostResponseModelFromJson(json);

  @override
  List<Object?> get props => [data, errors];
}
