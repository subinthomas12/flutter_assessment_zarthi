// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:product_management_app/core/di/injection.dart';
import 'package:product_management_app/features/products/presentation/bloc/add_product/add_product_bloc.dart';
import 'package:product_management_app/features/products/presentation/bloc/product_detail/product_detail_bloc.dart';
import 'package:product_management_app/features/products/presentation/bloc/product_list/product_list_bloc.dart';
import 'package:product_management_app/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetIt + Injectable
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Product List Bloc
        BlocProvider<ProductListBloc>(
          create: (_) => getIt<ProductListBloc>(),
        ),

        // Product Detail Bloc
        BlocProvider<ProductDetailBloc>(
          create: (_) => getIt<ProductDetailBloc>(),
        ),

        // Add Product Bloc
        BlocProvider<AddProductBloc>(
          create: (_) => getIt<AddProductBloc>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Product Management App',
            routerConfig: appRouter,
            theme: ThemeData(
              useMaterial3: true,
            ),
          );
        },
      ),
    );
  }
}