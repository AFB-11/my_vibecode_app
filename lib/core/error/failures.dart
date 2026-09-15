import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure()
    : super('The email or password is incorrect.');
}

class ServerFailure extends Failure {
  const ServerFailure() : super('Something went wrong. Please try again.');
}
