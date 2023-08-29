import 'package:ecom_web_flutter/api_repository/models/error_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel extends Equatable {
  const CategoryModel({this.errors, this.data});

  final ErrorData? errors;
  final CategoryData? data;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  @override
  List<Object?> get props => [data, errors];
}

@JsonSerializable()
class CategoryData extends Equatable {
  const CategoryData({required this.categories});
  final List<Category> categories;

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);

  @override
  List<Object?> get props => [categories];
}

@JsonSerializable()
class Category extends Equatable {
  const Category({
    required this.id,
    required this.category,
  });

  final int id;
  final String category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  @override
  List<Object?> get props => [
        id,
        category,
      ];
}
