import 'package:dio/dio.dart';
import 'package:product_management_app/core/network/api_interceptor.dart';

/// Base sealed class for all failures across the app.
/// Use this in your repository / use-case return types (e.g. with `Either`).
sealed class Failure {
  const Failure({required this.message});

  final String message;

  @override
  String toString() => '$runtimeType: $message';

  /// Convenience factory — converts a raw exception into the correct [Failure].
  factory Failure.from(Object error) {
    if (error is DioException) {
      final cause = error.error;
      if (cause is ApiException) {
        return switch (cause.statusCode) {
          400 => BadRequestFailure(message: cause.message),
          401 => UnauthorizedFailure(message: cause.message),
          403 => ForbiddenFailure(message: cause.message),
          404 => NotFoundFailure(message: cause.message),
          408 => TimeoutFailure(message: cause.message),
          422 => ValidationFailure(message: cause.message),
          500 => ServerFailure(message: cause.message),
          503 => ServiceUnavailableFailure(message: cause.message),
          0 => NetworkFailure(message: cause.message),
          _ => ServerFailure(message: cause.message),
        };
      }

      return switch (error.type) {
        DioExceptionType.connectionError => const NetworkFailure(),
        DioExceptionType.connectionTimeout => const TimeoutFailure(),
        DioExceptionType.receiveTimeout => const TimeoutFailure(),
        DioExceptionType.sendTimeout => const TimeoutFailure(),
        DioExceptionType.cancel => const CancelledFailure(),
        _ => ServerFailure(message: error.message ?? 'Unknown server error.'),
      };
    }

    return UnknownFailure(message: error.toString());
  }
}

// ─────────────────────────────────────────────
// NETWORK FAILURES
// ─────────────────────────────────────────────

/// No internet / host unreachable
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
  });
}

/// Any request or response timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'The request timed out. Please try again.',
  });
}

/// Request was explicitly cancelled (e.g. CancelToken)
class CancelledFailure extends Failure {
  const CancelledFailure({super.message = 'Request was cancelled.'});
}

// ─────────────────────────────────────────────
// HTTP / SERVER FAILURES
// ─────────────────────────────────────────────

/// HTTP 400 — malformed request
class BadRequestFailure extends Failure {
  const BadRequestFailure({super.message = 'Bad request.'});
}

/// HTTP 401 — missing or invalid credentials
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized. Please log in again.',
  });
}

/// HTTP 403 — authenticated but not allowed
class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'You don\'t have permission to do that.',
  });
}

/// HTTP 404 — resource not found
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'The requested resource was not found.',
  });
}

/// HTTP 422 — validation / unprocessable entity
class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation failed.'});
}

/// HTTP 500 — internal server error
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'A server error occurred. Try again later.',
  });
}

/// HTTP 503 — service temporarily down
class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure({
    super.message = 'Service is temporarily unavailable.',
  });
}

// ─────────────────────────────────────────────
// LOCAL / MISC FAILURES
// ─────────────────────────────────────────────

/// JSON decode / serialisation error
class ParseFailure extends Failure {
  const ParseFailure({super.message = 'Failed to parse server response.'});
}

/// Local cache / database error
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Failed to read or write local cache.'});
}

/// Fallback for anything not specifically handled
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unexpected error occurred.'});
}

