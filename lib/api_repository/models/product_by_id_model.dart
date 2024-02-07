import 'package:ecom_web_flutter/api_repository/models/error_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_by_id_model.g.dart';

@JsonSerializable()
class ProductByIdModel extends Equatable {
  const ProductByIdModel({this.errors, this.data});

  final ErrorData? errors;
  final ProductDataById? data;

  factory ProductByIdModel.fromJson(Map<String, dynamic> json) =>
      _$ProductByIdModelFromJson(json);

  @override
  List<Object?> get props => [data, errors];
}

@JsonSerializable()
class ProductDataById extends Equatable {
  const ProductDataById(
      {required this.id,
      required this.name,
      this.description,
      required this.priceOriginal,
      this.priceSale = 0,
      required this.imageUrl,
      required this.category,
      required this.isDeleted,
      required this.productDetail,
      this.unit});

  final int id;
  final String name;
  final String? description;
  final String productDetail;
  final String category;
  final int priceOriginal;
  final int priceSale;
  final String imageUrl;
  final bool isDeleted;
  final String? unit;

  factory ProductDataById.fromJson(Map<String, dynamic> json) =>
      _$ProductDataByIdFromJson(json);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        priceOriginal,
        priceSale,
        imageUrl,
        isDeleted,
        unit,
        category
      ];
}
