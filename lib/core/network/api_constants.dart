class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'https://fakestoreapi.com';

  // Endpoints
  static const String products = '/products';
  static const String productById = '/products/{id}';
  static const String productCategories = '/products/categories';
  static const String productsByCategory = '/products/category/{category}';
  static const String carts = '/carts';
  static const String cartById = '/carts/{id}';
  static const String users = '/users';
  static const String userById = '/users/{id}';
  static const String login = '/auth/login';

  // Query Params
  static const String limit = 'limit';
  static const String sort = 'sort';
  static const String sortAsc = 'asc';
  static const String sortDesc = 'desc';

  // Timeouts (in milliseconds)
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const int sendTimeout = 15000;

  // Headers
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}
