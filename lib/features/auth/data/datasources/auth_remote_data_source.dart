import 'package:my_vibecode_app/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));

    if (email != 'demo@example.com' || password != 'password123') {
      throw const InvalidCredentialsException();
    }

    return const UserModel(
      id: 'user-001',
      name: 'Demo User',
      email: 'demo@example.com',
    );
  }
}

class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();
}
