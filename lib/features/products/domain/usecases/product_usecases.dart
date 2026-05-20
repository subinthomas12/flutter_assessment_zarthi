import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

@lazySingleton
class GetProductsUseCase {
  final ProductRepository repository;
  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call() {
    return repository.getProducts();
  }
}

@lazySingleton
class GetProductByIdUseCase {
  final ProductRepository repository;
  GetProductByIdUseCase(this.repository);

  Future<Either<Failure, ProductEntity>> call(int id) {
    return repository.getProductById(id);
  }
}

@lazySingleton
class GetProductsByCategoryUseCase {
  final ProductRepository repository;
  GetProductsByCategoryUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(String category) {
    return repository.getProductsByCategory(category);
  }
}

@lazySingleton
class GetCategoriesUseCase {
  final ProductRepository repository;
  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() {
    return repository.getCategories();
  }
}
