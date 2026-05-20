import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/api/dio_client.dart';
import '../models/product_model.dart';

part 'product_remote_datasource.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ProductApiService {
  factory ProductApiService(Dio dio, {String baseUrl}) =
      _ProductApiService;

  @GET('/products')
  Future<List<ProductModel>> getProducts();

  @GET('/products/{id}')
  Future<ProductModel> getProductById(@Path('id') int id);

  @GET('/products/category/{category}')
  Future<List<ProductModel>> getProductsByCategory(
      @Path('category') String category);

  @GET('/products/categories')
  Future<List<String>> getCategories();
}

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<List<String>> getCategories();
}

@LazySingleton(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ProductApiService _apiService;

  ProductRemoteDataSourceImpl(DioClient dioClient)
      : _apiService = ProductApiService(dioClient.dio);

  @override
  Future<List<ProductModel>> getProducts() => _apiService.getProducts();

  @override
  Future<ProductModel> getProductById(int id) =>
      _apiService.getProductById(id);

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) =>
      _apiService.getProductsByCategory(category);

  @override
  Future<List<String>> getCategories() => _apiService.getCategories();
}
