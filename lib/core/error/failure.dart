import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([this.properties = const <dynamic>[]]);

  final List<dynamic> properties;

  @override
  List<Object?> get props => [properties];
}

class ServerFailure extends Failure {
  const ServerFailure([this.message]);

  final String? message;

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure([this.message]);

  final String? message;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([this.message]);

  final String? message;

  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  const ValidationFailure([this.message]);

  final String? message;

  @override
  List<Object?> get props => [message];
}

class InternalAppError extends Failure {
  const InternalAppError([this.message]);

  final String? message;

  @override
  List<Object?> get props => [message];
}
