// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:product_management_app/core/api/dio_client.dart' as _i368;
import 'package:product_management_app/core/api/network_info.dart' as _i908;
import 'package:product_management_app/core/di/register_module.dart' as _i72;
import 'package:product_management_app/features/products/data/datasource/product_local_datasource.dart'
    as _i378;
import 'package:product_management_app/features/products/data/datasource/product_remote_datasource.dart'
    as _i404;
import 'package:product_management_app/features/products/data/repositories/product_repository_impl.dart'
    as _i450;
import 'package:product_management_app/features/products/domain/repositories/product_repository.dart'
    as _i197;
import 'package:product_management_app/features/products/domain/usecases/add_product_usecase.dart'
    as _i176;
import 'package:product_management_app/features/products/domain/usecases/product_usecases.dart'
    as _i566;
import 'package:product_management_app/features/products/presentation/bloc/add_product/add_product_bloc.dart'
    as _i707;
import 'package:product_management_app/features/products/presentation/bloc/product_detail/product_detail_bloc.dart'
    as _i861;
import 'package:product_management_app/features/products/presentation/bloc/product_list/product_list_bloc.dart'
    as _i501;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i368.DioClient>(() => _i368.DioClient());
    gh.lazySingleton<_i161.InternetConnection>(
      () => registerModule.internetConnection,
    );
    gh.lazySingleton<_i908.NetworkInfo>(
      () => _i908.NetworkInfoImpl(gh<_i161.InternetConnection>()),
    );
    gh.lazySingleton<_i404.ProductRemoteDataSource>(
      () => _i404.ProductRemoteDataSourceImpl(gh<_i368.DioClient>()),
    );
    gh.lazySingleton<_i378.ProductLocalDataSource>(
      () => _i378.ProductLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i197.ProductRepository>(
      () => _i450.ProductRepositoryImpl(
        remoteDataSource: gh<_i404.ProductRemoteDataSource>(),
        networkInfo: gh<_i908.NetworkInfo>(),
        localDataSource: gh<_i378.ProductLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i176.AddProductUseCase>(
      () => _i176.AddProductUseCase(gh<_i197.ProductRepository>()),
    );
    gh.lazySingleton<_i566.GetProductsUseCase>(
      () => _i566.GetProductsUseCase(gh<_i197.ProductRepository>()),
    );
    gh.lazySingleton<_i566.GetProductByIdUseCase>(
      () => _i566.GetProductByIdUseCase(gh<_i197.ProductRepository>()),
    );
    gh.lazySingleton<_i566.GetProductsByCategoryUseCase>(
      () => _i566.GetProductsByCategoryUseCase(gh<_i197.ProductRepository>()),
    );
    gh.lazySingleton<_i566.GetCategoriesUseCase>(
      () => _i566.GetCategoriesUseCase(gh<_i197.ProductRepository>()),
    );
    gh.factory<_i501.ProductListBloc>(
      () => _i501.ProductListBloc(
        getProductsUseCase: gh<_i566.GetProductsUseCase>(),
        getCategoriesUseCase: gh<_i566.GetCategoriesUseCase>(),
      ),
    );
    gh.factory<_i707.AddProductBloc>(
      () => _i707.AddProductBloc(
        addProductUseCase: gh<_i176.AddProductUseCase>(),
      ),
    );
    gh.factory<_i861.ProductDetailBloc>(
      () => _i861.ProductDetailBloc(
        getProductByIdUseCase: gh<_i566.GetProductByIdUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i72.RegisterModule {}
