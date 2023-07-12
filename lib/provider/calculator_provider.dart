import 'package:flutter/material.dart';

class ProductModel {
  int index;
  String nama;
  int harga;
  int qty;

  ProductModel(
      {required this.nama,
      required this.harga,
      this.qty = 1,
      required this.index});
}

class CalculatorNotifier extends ChangeNotifier {
  static List<ProductModel> products = List<ProductModel>.empty(growable: true);

  List<ProductModel> get getProduct => products;

  void addProduct(ProductModel product) {
    products.add(product);
    notifyListeners();
  }

  void removeProduct(ProductModel product) {
    products.remove(product);
    notifyListeners();
  }

  void updateProduct({required int index, required ProductModel product}) {
    products[index].nama = product.nama;
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
