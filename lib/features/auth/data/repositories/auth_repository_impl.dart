import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email.trim() == 'user@gmail.com' &&
        password.trim() == '123456') {
      return const Right(
        UserModel(
          id: 1,
          name: 'User',
          email: 'user@gmail.com',
        ),
      );
    }

    return const Left(
      UnauthorizedFailure(
        message: 'Invalid email or password',
      ),
    );
  }
}