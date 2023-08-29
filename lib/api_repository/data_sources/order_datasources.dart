import 'package:ecom_web_flutter/api_repository/api_request.dart';
import 'package:ecom_web_flutter/api_repository/models/models.dart';

Future<PostResponseModel> addOrder(Map<String, dynamic> body) async {
  PostResponseModel model = await apiRequest<PostResponseModel, void>(
      '/order/insert',
      useToken: true,
      body: body,
      method: HttpMethod.POST);
  return model;
}
