import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/errors.dart';
import 'package:education_app/features/on_boarding/domian/repositories/on_boarding_repository.dart';
import 'package:education_app/features/on_boarding/domian/usecases/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/on_boarding_repository_mock_test.dart';

void main() {
  late OnBoardingRepository repository;
  late CacheFirstTimer usecase;

  setUp(() {
    repository = MOckOnBoardingRepository();
    usecase = CacheFirstTimer(repository);
  });

  test(
    'should call the [OnBoardingRepository.cacheFirstTimer] when the call is made successfull',
    () async {
      when(() => repository.cacheFirstTimer()).thenAnswer(
        (invocation) async => const Right(null),
      );

      final result = await usecase();

      expect(result, const Right(null));
      verify(() => repository.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  const CacheFailure cacheFailure = CacheFailure(
    message: 'Error Occured',
    statusCode: 400,
  );

  test(
    'should return the Left(CacheFailure) when the call to [OnBoardingRepository.cacheFirstTimer] is made uncessfull',
    () async {
      when(() => repository.cacheFirstTimer()).thenAnswer(
        (invocation) async => const Left(cacheFailure),
      );

      final result = await usecase();

      expect(result, const Left(cacheFailure));
      verify(() => repository.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
