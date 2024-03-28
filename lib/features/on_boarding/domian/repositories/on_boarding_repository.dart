import 'package:education_app/core/types/types.dart';

abstract interface class OnBoardingRepository {
  ResultFuture<void> cacheFirstTimer();

  ResultFuture<bool> checkFirstTimer();
}
