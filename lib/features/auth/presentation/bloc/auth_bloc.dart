import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_vibecode_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:my_vibecode_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:my_vibecode_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.loginUseCase}) : super(const AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final LoginUseCase loginUseCase;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );
    result.match(
      (failure) => emit(AuthFailure(failure)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
