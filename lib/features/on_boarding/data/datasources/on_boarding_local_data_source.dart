import 'package:education_app/core/errors/errors.dart';
import 'package:education_app/core/utils/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OnBoardingLocalDataSource {
  Future<void> cacheFirstTimer();

  Future<bool> checkFirstTimer();
}

class OnBoardingLocalDataSourceImpl implements OnBoardingLocalDataSource {
  final SharedPreferences sharedPreferences;

  const OnBoardingLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheFirstTimer() async {
    try {
      await sharedPreferences.setBool(Keys.firstTimerCacheKey, false);
    } catch (exception) {
      throw CacheException(message: exception.toString(), statusCode: 500);
    }
  }

  @override
  Future<bool> checkFirstTimer() async {
    try {
      bool? result = sharedPreferences.getBool(Keys.firstTimerCacheKey);
      if (result == null) return true;
      return result;
    } catch (exception) {
      throw CacheException(message: exception.toString(), statusCode: 500);
    }
  }
}
