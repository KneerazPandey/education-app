import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/errors.dart';
import 'package:education_app/features/on_boarding/domian/usecases/cache_first_timer.dart';
import 'package:education_app/features/on_boarding/domian/usecases/check_first_timer.dart';
import 'package:education_app/features/on_boarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckFirstTimer extends Mock implements CheckFirstTimer {}

void main() {
  late CheckFirstTimer checkFirstTimer;
  late CacheFirstTimer cacheFirstTimer;
  late OnBoardingBloc onBoardingBloc;

  setUp(() {
    cacheFirstTimer = MockCacheFirstTimer();
    checkFirstTimer = MockCheckFirstTimer();
    onBoardingBloc = OnBoardingBloc(
      cacheFirstTimer: cacheFirstTimer,
      checkFirstTimer: checkFirstTimer,
    );
  });

  test('initial state should be [OnBoardingInitial]', () {
    expect(onBoardingBloc.state, OnBoardingInitial());
  });

  const CacheFailure cacheFailure = CacheFailure(
    message: 'message',
    statusCode: 400,
  );

  group('cacheFirstTimer', () {
    blocTest<OnBoardingBloc, OnBoardingState>(
      'should emits [CachingFirstTimer, UserCache] when [CacheFirstTimerEvent] is added.',
      build: () {
        when(() => cacheFirstTimer()).thenAnswer(
          (invocation) async => const Right(null),
        );
        return onBoardingBloc;
      },
      act: (bloc) => bloc.add(CacheFirstTimerEvent()),
      expect: () => <OnBoardingState>[CachingFirstTimer(), UserCached()],
    );

    blocTest<OnBoardingBloc, OnBoardingState>(
      'should emits [CachingFirstTimer, OnBoardingError] when [CacheFirstTimerEvent] is added and the call to usecase is unsuccessfull.',
      build: () {
        when(() => cacheFirstTimer()).thenAnswer(
          (invocation) async => const Left(cacheFailure),
        );
        return onBoardingBloc;
      },
      act: (bloc) => bloc.add(CacheFirstTimerEvent()),
      expect: () => <OnBoardingState>[
        CachingFirstTimer(),
        const OnBoardingError(message: 'message'),
      ],
    );
  });

  group('checkFirstTimer', () {
    blocTest<OnBoardingBloc, OnBoardingState>(
      'should emits [CheckingFirstTimer, CheckedFirstTimerStatus] when [CheckFirstTimerEvent] is added.',
      build: () {
        when(() => checkFirstTimer()).thenAnswer(
          (invocation) async => const Right(true),
        );
        return onBoardingBloc;
      },
      act: (bloc) => bloc.add(CheckFirstTimerEvent()),
      expect: () => <OnBoardingState>[
        CheckingFirstTimer(),
        const CheckedFirstTimerStatus(isFirstTimer: true),
      ],
    );

    blocTest<OnBoardingBloc, OnBoardingState>(
      'emits [MyState] when MyEvent is added.',
      build: () {
        when(() => checkFirstTimer()).thenAnswer(
          (invocation) async => const Left(cacheFailure),
        );
        return onBoardingBloc;
      },
      act: (bloc) => bloc.add(CheckFirstTimerEvent()),
      expect: () => <OnBoardingState>[
        CheckingFirstTimer(),
        const CheckedFirstTimerStatus(isFirstTimer: true),
      ],
    );
  });
}
