part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class GetProduct extends ProductEvent {
  final String? category;
  final String? endCursor;
  const GetProduct({this.category, this.endCursor});

  @override
  List<Object?> get props => [];
}

class GetProductById extends ProductEvent {
  final String id;

  const GetProductById({required this.id});

  @override
  List<Object?> get props => [];
}
