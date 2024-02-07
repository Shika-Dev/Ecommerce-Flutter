// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_by_id_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductByIdModel _$ProductByIdModelFromJson(Map<String, dynamic> json) =>
    ProductByIdModel(
      errors: json['errors'] == null
          ? null
          : ErrorData.fromJson(json['errors'] as Map<String, dynamic>),
      data: json['data'] == null
          ? null
          : ProductDataById.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductByIdModelToJson(ProductByIdModel instance) =>
    <String, dynamic>{
      'errors': instance.errors,
      'data': instance.data,
    };

ProductDataById _$ProductDataByIdFromJson(Map<String, dynamic> json) =>
    ProductDataById(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      priceOriginal: json['priceOriginal'] as int,
      priceSale: json['priceSale'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      isDeleted: json['isDeleted'] as bool,
      productDetail: json['productDetail'] as String,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$ProductDataByIdToJson(ProductDataById instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'productDetail': instance.productDetail,
      'category': instance.category,
      'priceOriginal': instance.priceOriginal,
      'priceSale': instance.priceSale,
      'imageUrl': instance.imageUrl,
      'isDeleted': instance.isDeleted,
      'unit': instance.unit,
    };
