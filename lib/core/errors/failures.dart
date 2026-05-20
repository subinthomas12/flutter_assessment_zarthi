import 'package:dio/dio.dart';
import 'package:product_management_app/core/network/api_interceptor.dart';

/// Base sealed class for all failures across the app.
/// Used with Either<Failure, T>.
sealed class Failure {
  const Failure({required this.message});

  final String message;

  @override
  String toString() => '$runtimeType: $message';

  /// Converts any exception into a [Failure].
  factory Failure.from(Object error) {
    // Handle Dio exceptions
    if (error is DioException) {
      final cause = error.error;

      // If our interceptor threw ApiException
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

      // Handle Dio exception types
      return switch (error.type) {
        DioExceptionType.connectionError => const NetworkFailure(),
        DioExceptionType.connectionTimeout => const TimeoutFailure(),
        DioExceptionType.receiveTimeout => const TimeoutFailure(),
        DioExceptionType.sendTimeout => const TimeoutFailure(),
        DioExceptionType.cancel => const CancelledFailure(),
        _ => ServerFailure(
            message: error.message ?? 'Unknown server error.',
          ),
      };
    }

    // Handle custom ApiException directly
    if (error is ApiException) {
      return ServerFailure(message: error.message);
    }

    // Fallback
    return UnknownFailure(message: error.toString());
  }
}

// =====================================================
// NETWORK FAILURES
// =====================================================

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'The request timed out. Please try again.',
  });
}

class CancelledFailure extends Failure {
  const CancelledFailure({
    super.message = 'Request was cancelled.',
  });
}

// =====================================================
// HTTP / SERVER FAILURES
// =====================================================

class BadRequestFailure extends Failure {
  const BadRequestFailure({
    super.message = 'Bad request.',
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized. Please log in again.',
  });
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'You do not have permission to perform this action.',
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'The requested resource was not found.',
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Validation failed.',
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'A server error occurred. Please try again later.',
  });
}

class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure({
    super.message = 'Service is temporarily unavailable.',
  });
}

// =====================================================
// LOCAL / MISC FAILURES
// =====================================================

class ParseFailure extends Failure {
  const ParseFailure({
    super.message = 'Failed to parse server response.',
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to read or write local cache.',
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred.',
  });
}