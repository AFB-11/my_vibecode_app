import 'package:fpdart/fpdart.dart';
import 'package:my_vibecode_app/core/error/failures.dart';
import 'package:my_vibecode_app/features/auth/domain/entities/user_entity.dart';
import 'package:my_vibecode_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
