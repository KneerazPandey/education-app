import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/errors.dart';
import 'package:education_app/core/types/types.dart';
import 'package:education_app/features/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_app/features/on_boarding/domian/repositories/on_boarding_repository.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  final OnBoardingLocalDataSource localDataSource;

  const OnBoardingRepositoryImpl({
    required this.localDataSource,
  });

  @override
  ResultFuture<void> cacheFirstTimer() async {
    try {
      final result = await localDataSource.cacheFirstTimer();
      return Right(result);
    } on CacheException catch (exception) {
      return Left(CacheFailure.fromException(exception));
    }
  }

  @override
  ResultFuture<bool> checkFirstTimer() async {
    try {
      final result = await localDataSource.checkFirstTimer();
      return Right(result);
    } on CacheException catch (exception) {
      return Left(CacheFailure.fromException(exception));
    }
  }
}
