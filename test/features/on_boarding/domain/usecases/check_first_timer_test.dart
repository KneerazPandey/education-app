import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/errors.dart';
import 'package:education_app/features/on_boarding/domian/repositories/on_boarding_repository.dart';
import 'package:education_app/features/on_boarding/domian/usecases/check_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/on_boarding_repository_mock_test.dart';

void main() {
  late OnBoardingRepository repository;
  late CheckFirstTimer usecase;

  setUp(() {
    repository = MOckOnBoardingRepository();
    usecase = CheckFirstTimer(repository);
  });

  test(
    'should return Right(true) when the call to [OnBoardingRepository.checkFirstTimer] is made successfully',
    () async {
      when(() => repository.checkFirstTimer()).thenAnswer(
        (invocation) async => const Right(true),
      );

      final result = await usecase();

      expect(result, const Right(true));
      verify(() => repository.checkFirstTimer()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  const CacheFailure cacheFailure = CacheFailure(
    message: 'Error Occured',
    statusCode: 400,
  );

  test(
    'should return Left(CacheFailure) when the call to [OnBoardingRepository.checkFirstTimer] is unsuccessfull',
    () async {
      when(() => repository.checkFirstTimer()).thenAnswer(
        (invocation) async => const Left(cacheFailure),
      );

      final result = await usecase();

      expect(result, const Left(cacheFailure));
      verify(() => repository.checkFirstTimer()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
