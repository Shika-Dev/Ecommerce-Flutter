import 'package:ecom_web_flutter/api_repository/data_sources/product_datasource.dart';
import 'package:ecom_web_flutter/api_repository/models/models.dart';
import 'package:ecom_web_flutter/api_repository/models/product_by_id_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductState.initial()) {
    on<GetProduct>((event, emit) => _getPaketInternet(emit, event));
    on<GetProductById>((event, emit) => _getProductById(emit, event));
  }

  Future<void> _getPaketInternet(
    Emitter<ProductState> emit,
    GetProduct event,
  ) async {
    emit(const ProductState.loading());
    // try {
    //   String category = '';
    //   if (event.category == 'View All') {
    //     category = '';
    //   } else
    //     category = event.category ?? '';
    //   GetArticleModel response = await getMultipleArticle(
    //       category: category, endCursor: event.endCursor);
    //   emit(ProductState.success(response));
    // } catch (e) {
    //   emit(ProductState.failure(e.toString()));
    // }
  }

  Future<void> _getProductById(
    Emitter<ProductState> emit,
    GetProductById event,
  ) async {
    emit(const ProductState.loading());
    try {
      ProductByIdModel response = await fetchProductById(event.id);
      emit(ProductState.byIdSuccess(response.data!));
    } catch (e) {
      emit(ProductState.failure(e.toString()));
    }
  }
}
