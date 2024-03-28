abstract interface class OnBoardingLocalDataSource {
  Future<void> cacheFirstTimer();

  Future<bool> checkFirstTimer();
}
