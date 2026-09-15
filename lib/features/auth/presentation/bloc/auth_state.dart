import 'package:equatable/equatable.dart';
import 'package:my_vibecode_app/core/error/failures.dart';
import 'package:my_vibecode_app/features/auth/domain/entities/user_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

final class AuthFailure extends AuthState {
  const AuthFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
