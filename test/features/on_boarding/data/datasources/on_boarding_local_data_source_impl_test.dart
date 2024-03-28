import 'package:education_app/core/errors/errors.dart';
import 'package:education_app/core/utils/keys.dart';
import 'package:education_app/features/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreference extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences sharedPreferences;
  late OnBoardingLocalDataSourceImpl localDataSourceImpl;

  setUp(() {
    sharedPreferences = MockSharedPreference();
    localDataSourceImpl = OnBoardingLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
  });

  const message = 'Error occured while caching the data';
  const statusCode = 400;
  const CacheException cacheException = CacheException(
    message: message,
    statusCode: statusCode,
  );

  group('cacheFirstTimer', () {
    test(
      'should call [SharedPreference] to cache the first timer',
      () async {
        when(() => sharedPreferences.setBool(any(), any())).thenAnswer(
          (invocation) async => Future.value(true),
        );

        await localDataSourceImpl.cacheFirstTimer();

        verify(() => sharedPreferences.setBool(Keys.firstTimerCacheKey, false))
            .called(1);
        verifyNoMoreInteractions(sharedPreferences);
      },
    );

    test(
      'should throw [CacheException] when the call to SharedPreference on setting the cache data is failed',
      () async {
        when(
          () => sharedPreferences.setBool(any(), any()),
        ).thenThrow(cacheException);

        final methodCall = localDataSourceImpl.cacheFirstTimer;

        expect(methodCall, throwsA(isA<CacheException>()));
        verify(() => sharedPreferences.setBool(Keys.firstTimerCacheKey, false));
        verifyNoMoreInteractions(sharedPreferences);
      },
    );
  });

  group('checkFirstTimer', () {
    test(
      'should return bool when the call to [SharedPreference] is made successfull',
      () async {
        when(() => sharedPreferences.getBool(any()))
            .thenAnswer((invocation) => true);

        var result = await localDataSourceImpl.checkFirstTimer();

        expect(result, true);
        verify(() => sharedPreferences.getBool(Keys.firstTimerCacheKey))
            .called(1);
        verifyNoMoreInteractions(sharedPreferences);
      },
    );

    test(
      'should throw [CacheFailure] when the call to [SharedPreference.getBool] is unsuccessfull',
      () async {
        when(() => sharedPreferences.getBool(any())).thenThrow(Exception());

        final methodCall = localDataSourceImpl.checkFirstTimer();

        expect(methodCall, throwsA(isA<CacheException>()));
        verify(() => sharedPreferences.getBool(Keys.firstTimerCacheKey))
            .called(1);
        verifyNoMoreInteractions(sharedPreferences);
      },
    );
  });
}
