// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartModel _$CartModelFromJson(Map<String, dynamic> json) => CartModel(
      errors: json['errors'] == null
          ? null
          : ErrorData.fromJson(json['errors'] as Map<String, dynamic>),
      data: json['data'] == null
          ? null
          : CartData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartModelToJson(CartModel instance) => <String, dynamic>{
      'errors': instance.errors,
      'data': instance.data,
    };

CartData _$CartDataFromJson(Map<String, dynamic> json) => CartData(
      cartData: (json['cartData'] as List<dynamic>)
          .map((e) => Cart.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCartPrice: json['totalCartPrice'] as int,
    );

Map<String, dynamic> _$CartDataToJson(CartData instance) => <String, dynamic>{
      'cartData': instance.cartData,
      'totalCartPrice': instance.totalCartPrice,
    };

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
      productName: json['productName'] as String,
      productUnit: json['productUnit'] as String,
      totalPrice: json['totalPrice'] as int,
      productId: json['productId'] as int,
      productQty: json['productQty'] as int,
      additionalNote: json['additionalNote'] as String?,
      priceOriginal: json['priceOriginal'] as int,
      priceSale: json['priceSale'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String,
      isDeleted: json['isDeleted'] as bool,
    );

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'productName': instance.productName,
      'productUnit': instance.productUnit,
      'totalPrice': instance.totalPrice,
      'productId': instance.productId,
      'productQty': instance.productQty,
      'additionalNote': instance.additionalNote,
      'priceOriginal': instance.priceOriginal,
      'priceSale': instance.priceSale,
      'imageUrl': instance.imageUrl,
      'isDeleted': instance.isDeleted,
    };
