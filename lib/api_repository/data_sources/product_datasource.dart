import 'package:ecom_web_flutter/api_repository/api_request.dart';
import 'package:ecom_web_flutter/api_repository/models/models.dart';

Future<ProductModel> fetchAllProduct() async {
  ProductModel model = await apiRequest<ProductModel, void>(
      '/product?limit=500&offset=0',
      method: HttpMethod.GET);
  return model;
}

Future<ProductModel> fetchFeaturedProduct() async {
  ProductModel model = await apiRequest<ProductModel, void>(
      '/product/getfeaturedproducts',
      method: HttpMethod.GET);
  return model;
}

Future<CategoryModel> fetchAllCategory() async {
  CategoryModel model = await apiRequest<CategoryModel, void>(
      '/category/getall',
      method: HttpMethod.GET);
  return model;
}

Future<ProductModel> fetchProductByCategory(String category) async {
  ProductModel model = await apiRequest<ProductModel, void>(
      '/product/getbycategory/$category?limit=500&offset=0',
      method: HttpMethod.GET);
  return model;
}

Future<PostResponseModel> addToCart(Map<String, dynamic> body) async {
  PostResponseModel model = await apiRequest<PostResponseModel, void>(
      '/cart/upsert',
      useToken: true,
      body: body,
      method: HttpMethod.POST);
  return model;
}

Future<PostResponseModel> deleteFromCart(Map<String, dynamic> body) async {
  PostResponseModel model = await apiRequest<PostResponseModel, void>(
      '/cart/deleteone',
      useToken: true,
      body: body,
      method: HttpMethod.POST);
  return model;
}

Future<CartModel> fetchUserCart() async {
  CartModel model = await apiRequest<CartModel, void>('/cart/getbyuserid',
      useToken: true, method: HttpMethod.GET);
  return model;
}
