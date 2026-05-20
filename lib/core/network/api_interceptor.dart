import 'package:dio/dio.dart';
import 'package:product_management_app/core/api/api_constants.dart';

// ─────────────────────────────────────────────
// AUTH INTERCEPTOR
// Attaches Bearer token to every request header
// ─────────────────────────────────────────────
class AuthInterceptor extends Interceptor {
  // Replace with your token storage (e.g. SharedPreferences / SecureStorage)
  String? _accessToken;

  void setToken(String token) => _accessToken = token;
  void clearToken() => _accessToken = null;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_accessToken != null && _accessToken!.isNotEmpty) {
      options.headers[ApiConstants.authorization] =
          '${ApiConstants.bearer} $_accessToken';
    }
    handler.next(options);
  }
}

// ─────────────────────────────────────────────
// LOGGING INTERCEPTOR
// Logs request / response / error details
// ─────────────────────────────────────────────
class LoggingInterceptor extends Interceptor {
  static const String _divider = '──────────────────────────────────';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log('REQUEST', [
      'Method  : ${options.method}',
      'URL     : ${options.uri}',
      if (options.queryParameters.isNotEmpty)
        'Params  : ${options.queryParameters}',
      if (options.data != null) 'Body    : ${options.data}',
      'Headers : ${options.headers}',
    ]);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log('RESPONSE', [
      'Status  : ${response.statusCode}',
      'URL     : ${response.requestOptions.uri}',
      'Data    : ${response.data}',
    ]);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log('ERROR', [
      'Type    : ${err.type}',
      'URL     : ${err.requestOptions.uri}',
      'Message : ${err.message}',
      if (err.response != null) 'Status  : ${err.response?.statusCode}',
      if (err.response?.data != null) 'Body    : ${err.response?.data}',
    ]);
    handler.next(err);
  }

  void _log(String tag, List<String> lines) {
    // ignore: avoid_print
    print('\n$_divider\n[$tag]\n${lines.join('\n')}\n$_divider');
  }
}

// ─────────────────────────────────────────────
// ERROR INTERCEPTOR
// Normalises DioExceptions into ApiException
// ─────────────────────────────────────────────
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiException = _handleError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: apiException,
        type: err.type,
        response: err.response,
      ),
    );
  }

  ApiException _handleError(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: 'Connection timed out. Please try again.',
          statusCode: 408,
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Request send timed out.',
          statusCode: 408,
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Server took too long to respond.',
          statusCode: 504,
        );
      case DioExceptionType.badResponse:
        return _handleStatusCode(err.response?.statusCode, err.response?.data);
      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled.', statusCode: 0);
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection. Please check your network.',
          statusCode: 0,
        );
      default:
        return ApiException(
          message: err.message ?? 'An unexpected error occurred.',
          statusCode: 0,
        );
    }
  }

  ApiException _handleStatusCode(int? statusCode, dynamic data) {
    final serverMessage =
        (data is Map<String, dynamic>) ? data['message'] as String? : null;

    switch (statusCode) {
      case 400:
        return ApiException(
          message: serverMessage ?? 'Bad request.',
          statusCode: 400,
        );
      case 401:
        return ApiException(
          message: serverMessage ?? 'Unauthorized. Please log in again.',
          statusCode: 401,
        );
      case 403:
        return ApiException(
          message: serverMessage ?? 'Access forbidden.',
          statusCode: 403,
        );
      case 404:
        return ApiException(
          message: serverMessage ?? 'Resource not found.',
          statusCode: 404,
        );
      case 422:
        return ApiException(
          message: serverMessage ?? 'Unprocessable entity.',
          statusCode: 422,
        );
      case 500:
        return ApiException(
          message: serverMessage ?? 'Internal server error. Try again later.',
          statusCode: 500,
        );
      case 503:
        return ApiException(
          message: serverMessage ?? 'Service unavailable.',
          statusCode: 503,
        );
      default:
        return ApiException(
          message: serverMessage ?? 'Something went wrong (HTTP $statusCode).',
          statusCode: statusCode ?? 0,
        );
    }
  }
}

// ─────────────────────────────────────────────
// API EXCEPTION MODEL
// ─────────────────────────────────────────────
class ApiException implements Exception {
  const ApiException({
    required this.message,
    required this.statusCode,
  });

  final String message;
  final int statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}