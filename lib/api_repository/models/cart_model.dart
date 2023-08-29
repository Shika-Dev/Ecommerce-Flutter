import 'package:ecom_web_flutter/api_repository/models/error_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel extends Equatable {
  const CartModel({this.errors, this.data});

  final ErrorData? errors;
  final List<CartData>? data;

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  @override
  List<Object?> get props => [data, errors];
}

@JsonSerializable()
class CartData extends Equatable {
  const CartData({
    required this.productName,
    required this.productUnit,
    required this.totalPrice,
    required this.productId,
    required this.productQty,
    this.additionalNote,
    required this.priceOriginal,
    this.priceSale = 0,
    required this.imageUrl,
    required this.isDeleted,
  });

  final String productName;
  final String productUnit;
  final int totalPrice;
  final int productId;
  final int productQty;
  final String? additionalNote;
  final int priceOriginal;
  final int priceSale;
  final String imageUrl;
  final bool isDeleted;

  factory CartData.fromJson(Map<String, dynamic> json) =>
      _$CartDataFromJson(json);

  @override
  List<Object?> get props => [
        productId,
        productQty,
        additionalNote,
        priceOriginal,
        priceSale,
        imageUrl,
        isDeleted,
      ];
}
