import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, ProductEntity>> getProductById(int id);
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String category,
  );
  Future<Either<Failure, List<String>>> getCategories();
  Future<Either<Failure, Unit>> addProduct(ProductEntity product);
}
