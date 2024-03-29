import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/errors/errors.dart';
import 'package:education_app/core/types/types.dart';
import 'package:education_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:education_app/features/auth/domain/entities/local_user.dart';
import 'package:education_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  ResultFuture<void> forgetPassword(String email) async {
    try {
      final result = await remoteDataSource.forgetPassword(email);
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }

  @override
  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result =
          await remoteDataSource.signIn(email: email, password: password);
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }

  @override
  ResultFuture<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.signUp(
        email: email,
        fullName: fullName,
        password: password,
      );
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }

  @override
  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required data,
  }) async {
    try {
      final result = await remoteDataSource.updateUser(
        action: action,
        data: data,
      );
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }
}
