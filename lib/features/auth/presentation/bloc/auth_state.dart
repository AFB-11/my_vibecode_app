import 'package:equatable/equatable.dart';
import 'package:my_vibecode_app/core/error/failures.dart';
import 'package:my_vibecode_app/features/auth/domain/entities/user_entity.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.initial, this.user, this.failure});

  final AuthStatus status;
  final UserEntity? user;
  final Failure? failure;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    Failure? failure,
    bool clearUser = false,
    bool clearFailure = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, user, failure];
}
