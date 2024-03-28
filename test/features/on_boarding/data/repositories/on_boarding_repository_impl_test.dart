import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/errors.dart';
import 'package:education_app/features/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_app/features/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:education_app/features/on_boarding/domian/repositories/on_boarding_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../datasources/on_boarding_local_data_source_mock_test.dart';

void main() {
  late OnBoardingLocalDataSource localDataSource;
  late OnBoardingRepositoryImpl repositoryImpl;

  setUp(() {
    localDataSource = MockOnBoardingLocalDataSource();
    repositoryImpl = OnBoardingRepositoryImpl(
      localDataSource: localDataSource,
    );
  });

  test(
    'should be a subclass of [OnBoardingRepository]',
    () {
      expect(repositoryImpl, isA<OnBoardingRepository>());
    },
  );

  const String message = 'error message';
  const int statusCode = 400;
  const CacheException cacheException = CacheException(
    message: message,
    statusCode: statusCode,
  );

  group('cacheFirstTimer', () {
    test(
      'should complete successfully when call to local data source is successfull',
      () async {
        when(() => localDataSource.cacheFirstTimer()).thenAnswer(
          (invocation) async => Future.value(null),
        );

        final result = await repositoryImpl.cacheFirstTimer();

        expect(result, equals(const Right<dynamic, void>(null)));
        verify(() => localDataSource.cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(localDataSource);
      },
    );

    test(
      'should return [CacheFailure] when the call to localdata source is unsuccessfull',
      () async {
        when(() => localDataSource.cacheFirstTimer()).thenThrow(cacheException);

        final result = await repositoryImpl.cacheFirstTimer();

        expect(
          result,
          Left<CacheFailure, dynamic>(
            CacheFailure.fromException(cacheException),
          ),
        );
        verify(() => localDataSource.cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(localDataSource);
      },
    );
  });

  group('checkFirstTimer', () {
    test(
      'should return bool when the call to localdata source is made successfull',
      () async {
        when(() => localDataSource.checkFirstTimer()).thenAnswer(
          (invocation) async => Future.value(false),
        );

        final result = await repositoryImpl.checkFirstTimer();

        expect(result, const Right(false));
        verify(() => localDataSource.checkFirstTimer()).called(1);
        verifyNoMoreInteractions(localDataSource);
      },
    );

    test(
      'should return Left(CacheFailure) when the call to localdata source is made unsuccessfull',
      () async {
        when(() => localDataSource.checkFirstTimer()).thenThrow(cacheException);

        final result = await repositoryImpl.checkFirstTimer();

        expect(
          result,
          Left<CacheFailure, dynamic>(
              CacheFailure.fromException(cacheException)),
        );
        verify(() => localDataSource.checkFirstTimer()).called(1);
        verifyNoMoreInteractions(localDataSource);
      },
    );

    // test(, () => null)
  });
}
