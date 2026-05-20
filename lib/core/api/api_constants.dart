class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://fakestoreapi.com';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Endpoints
  static const String products = '/products';
  static const String productById = '/products/{id}';
  static const String productsByCategory = '/products/category/{category}';
  static const String categories = '/products/categories';

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}
