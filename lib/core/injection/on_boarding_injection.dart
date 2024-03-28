import 'package:education_app/core/injection/dependency_injection.dart';
import 'package:education_app/features/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_app/features/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:education_app/features/on_boarding/domian/repositories/on_boarding_repository.dart';
import 'package:education_app/features/on_boarding/domian/usecases/cache_first_timer.dart';
import 'package:education_app/features/on_boarding/domian/usecases/check_first_timer.dart';
import 'package:education_app/features/on_boarding/presentation/bloc/on_boarding_bloc.dart';

Future<void> onBoardingInjection() async {
  sl.registerFactory<OnBoardingBloc>(
    () => OnBoardingBloc(cacheFirstTimer: sl(), checkFirstTimer: sl()),
  );

  sl.registerLazySingleton<CacheFirstTimer>(() => CacheFirstTimer(sl()));

  sl.registerLazySingleton<CheckFirstTimer>(() => CheckFirstTimer(sl()));

  sl.registerLazySingleton<OnBoardingRepository>(
    () => OnBoardingRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<OnBoardingLocalDataSource>(
    () => OnBoardingLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
