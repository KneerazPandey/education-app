import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String message;
  final dynamic statusCode;

  const ServerException({
    required this.message,
    required this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheException extends Equatable implements Exception {
  final String message;
  final dynamic statusCode;

  const CacheException({
    required this.message,
    required this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}
