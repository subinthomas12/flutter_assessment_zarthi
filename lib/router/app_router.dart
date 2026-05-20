import 'package:go_router/go_router.dart';
import 'package:product_management_app/features/auth/presentation/screens/login_screen.dart';
import 'package:product_management_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:product_management_app/features/products/presentation/screens/add_product_screen.dart';
import 'package:product_management_app/features/products/presentation/screens/product_detail_screen.dart';
import 'package:product_management_app/features/products/presentation/screens/product_list_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
    GoRoute(path: '/signup', builder: (_, __) => SignupScreen()),
    GoRoute(path: '/products', builder: (_, __) => ProductListScreen()),
    GoRoute(
      path: '/products/:id',
      builder: (_, state) =>
          ProductDetailScreen(id: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(path: '/add-product', builder: (_, __) => const AddProductScreen()),
  ],
);
