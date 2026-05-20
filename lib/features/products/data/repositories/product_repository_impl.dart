import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:product_management_app/core/api/network_info.dart';
import 'package:product_management_app/core/errors/exceptions.dart';
import 'package:product_management_app/core/errors/failures.dart';
import 'package:product_management_app/features/products/data/datasource/product_local_datasource.dart';
import 'package:product_management_app/features/products/data/datasource/product_remote_datasource.dart';
import 'package:product_management_app/features/products/data/models/product_model.dart';
import 'package:product_management_app/features/products/domain/entities/product_entity.dart';
import 'package:product_management_app/features/products/domain/repositories/product_repository.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      // Get locally added products
      final localProducts = await localDataSource.getProducts();

      // Get API products if internet is available
      List<ProductModel> remoteProducts = [];
      if (await networkInfo.isConnected) {
        remoteProducts = await remoteDataSource.getProducts();
      }

      // Merge API + local products
      final allProducts = [
        ...remoteProducts,
        ...localProducts,
      ];

      // Remove duplicates by id
      final uniqueProducts = <int, ProductModel>{};
      for (final product in allProducts) {
        uniqueProducts[product.id] = product;
      }

      final entities = uniqueProducts.values
          .map((model) => model.toEntity())
          .toList();

      return Right(entities);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Server error',
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
        ),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    try {
      // Check local products first
      final localProducts = await localDataSource.getProducts();

      try {
        final localProduct =
            localProducts.firstWhere((product) => product.id == id);
        return Right(localProduct.toEntity());
      } catch (_) {
        // Not found locally, continue to remote
      }

      // If offline and product not found locally
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      // Fetch from API
      final remoteProduct = await remoteDataSource.getProductById(id);
      return Right(remoteProduct.toEntity());
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Server error',
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
        ),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final productsResult = await getProducts();

      return productsResult.fold(
        (failure) => Left(failure),
        (products) {
          final filteredProducts = products
              .where((product) => product.category == category)
              .toList();

          return Right(filteredProducts);
        },
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      List<String> remoteCategories = [];
      List<String> localCategories = [];

      // Fetch API categories if internet is available
      if (await networkInfo.isConnected) {
        remoteCategories = await remoteDataSource.getCategories();
      }

      // Fetch categories from local products
      final localProducts = await localDataSource.getProducts();
      localCategories = localProducts
          .map((product) => product.category)
          .toSet()
          .toList();

      // Merge and remove duplicates
      final categories = {
        ...remoteCategories,
        ...localCategories,
      }.toList();

      // Sort alphabetically
      categories.sort();

      return Right(categories);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Server error',
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
        ),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> addProduct(
    ProductEntity product,
  ) async {
    try {
      final model = ProductModel.fromEntity(product);
      await localDataSource.addProduct(model);
      return const Right(unit);
    } catch (e) {
      return Left(
        UnknownFailure(
          message: e.toString(),
        ),
      );
    }
  }
}