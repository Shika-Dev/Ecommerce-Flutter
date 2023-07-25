import 'package:ecom_web_flutter/api_repository/api_request.dart';
import 'package:ecom_web_flutter/api_repository/models/models.dart';

Future<ProductModel> fetchAllProduct() async {
  ProductModel model =
      await apiRequest<ProductModel, void>('/1', method: HttpMethod.GET);
  return model;
}
