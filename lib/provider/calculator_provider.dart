import 'package:flutter/material.dart';

class ProductCalculatorModel {
  int index;
  int harga;
  int qty;

  ProductCalculatorModel(
      {required this.harga, this.qty = 1, required this.index});
}

class CalculatorNotifier extends ChangeNotifier {
  static List<ProductCalculatorModel> products =
      List<ProductCalculatorModel>.empty(growable: true);

  List<ProductCalculatorModel> get getProduct => products;

  void addProduct(ProductCalculatorModel product) {
    products.add(product);
    notifyListeners();
  }

  void removeProduct(ProductCalculatorModel product) {
    products.remove(product);
    notifyListeners();
  }

  void updateProduct(
      {required int index, required ProductCalculatorModel product}) {
    products[index].harga = product.harga;
    notifyListeners();
  }

  void updateProductQty({required int index, required String qty}) {
    products[index].qty = int.parse(qty);
    notifyListeners();
  }

  int getTotalPrice() {
    int price = 0;
    products.forEach((element) {
      price += element.harga * element.qty;
    });
    return price;
  }
}
