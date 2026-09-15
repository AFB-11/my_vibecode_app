import 'package:fpdart/fpdart.dart';
import 'package:my_vibecode_app/core/error/failures.dart';
import 'package:my_vibecode_app/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });
}
