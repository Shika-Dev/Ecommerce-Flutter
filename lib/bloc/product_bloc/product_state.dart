part of 'product_bloc.dart';

enum ProductStatus {
  initial,
  loading,
  success,
  failure,
  byIdSuccess,
  categorySuccess
}

class ProductState extends Equatable {
  const ProductState.__({
    this.product,
    this.productList,
    this.errorMessage,
    this.categoryList,
    required this.status,
  });

  const ProductState.initial() : this.__(status: ProductStatus.initial);

  const ProductState.loading() : this.__(status: ProductStatus.loading);

  const ProductState.byIdSuccess(
    ProductDataById item,
  ) : this.__(
          status: ProductStatus.byIdSuccess,
          product: item,
        );

  const ProductState.success(
    List<ProductData> listProduct,
  ) : this.__(
          status: ProductStatus.success,
          productList: listProduct,
        );

  const ProductState.categorySuccess(
      List<String> listCategory, List<ProductData>? listProduct)
      : this.__(
            status: ProductStatus.categorySuccess,
            categoryList: listCategory,
            productList: listProduct);

  const ProductState.failure(
    String errorMessage,
  ) : this.__(
          status: ProductStatus.failure,
          errorMessage: errorMessage,
        );

  final List<ProductData>? productList;
  final List<String>? categoryList;
  final ProductDataById? product;
  final String? errorMessage;
  final ProductStatus status;

  @override
  List<Object?> get props =>
      [productList, product, errorMessage, status, categoryList];
}
