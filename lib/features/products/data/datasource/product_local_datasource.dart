import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> addProduct(ProductModel product);
  Future<List<ProductModel>> getProducts();
  Future<List<String>> getCategories();
}

@LazySingleton(as: ProductLocalDataSource)
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String keyProducts = 'local_products';

  final SharedPreferences prefs;

  ProductLocalDataSourceImpl(this.prefs);

  @override
  Future<void> addProduct(ProductModel product) async {
    final products = await getProducts();

    products.add(product);

    final jsonList = products.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList(keyProducts, jsonList);
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final jsonList = prefs.getStringList(keyProducts) ?? [];

    return jsonList
        .map(
          (e) => ProductModel.fromJson(jsonDecode(e) as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final products = await getProducts();

    final categories = products.map((e) => e.category).toSet().toList();

    return categories;
  }
}
