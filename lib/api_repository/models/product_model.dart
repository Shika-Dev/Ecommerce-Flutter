import 'package:ecom_web_flutter/api_repository/models/error_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends Equatable {
  const ProductModel({this.errors, this.data});

  final ErrorData? errors;
  final List<ProductData>? data;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  @override
  List<Object?> get props => [data, errors];
}

@JsonSerializable()
class ProductData extends Equatable {
  const ProductData(
      {required this.id,
      required this.name,
      this.description,
      required this.priceOriginal,
      this.priceSale = 0,
      required this.imageUrl,
      required this.isDeleted,
      required this.productDetail,
      this.unit});

  final int id;
  final String name;
  final String? description;
  final String productDetail;
  final int priceOriginal;
  final int priceSale;
  final String imageUrl;
  final bool isDeleted;
  final String? unit;

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        priceOriginal,
        priceSale,
        imageUrl,
        isDeleted,
        unit
      ];
}
