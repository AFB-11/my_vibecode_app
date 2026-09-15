import 'package:fpdart/fpdart.dart';
import 'package:my_vibecode_app/core/error/failures.dart';
import 'package:my_vibecode_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:my_vibecode_app/features/auth/domain/entities/user_entity.dart';
import 'package:my_vibecode_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this.remoteDataSource});

  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right<Failure, UserEntity>(user);
    } on InvalidCredentialsException {
      return const Left<Failure, UserEntity>(InvalidCredentialsFailure());
    } on Exception {
      return const Left<Failure, UserEntity>(ServerFailure());
    }
  }
}
