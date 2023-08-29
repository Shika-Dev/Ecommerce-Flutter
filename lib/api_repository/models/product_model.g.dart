// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      errors: json['errors'] == null
          ? null
          : ErrorData.fromJson(json['errors'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ProductData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'errors': instance.errors,
      'data': instance.data,
    };

ProductData _$ProductDataFromJson(Map<String, dynamic> json) => ProductData(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      priceOriginal: json['priceOriginal'] as int,
      priceSale: json['priceSale'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String,
      isDeleted: json['isDeleted'] as bool,
      productDetail: json['productDetail'] as String,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$ProductDataToJson(ProductData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'productDetail': instance.productDetail,
      'priceOriginal': instance.priceOriginal,
      'priceSale': instance.priceSale,
      'imageUrl': instance.imageUrl,
      'isDeleted': instance.isDeleted,
      'unit': instance.unit,
    };
