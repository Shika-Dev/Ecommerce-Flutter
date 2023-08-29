// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostResponseModel _$PostResponseModelFromJson(Map<String, dynamic> json) =>
    PostResponseModel(
      errors: json['errors'] == null
          ? null
          : ErrorData.fromJson(json['errors'] as Map<String, dynamic>),
      data: json['data'],
    );

Map<String, dynamic> _$PostResponseModelToJson(PostResponseModel instance) =>
    <String, dynamic>{
      'errors': instance.errors,
      'data': instance.data,
    };
