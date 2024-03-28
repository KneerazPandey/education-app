import 'package:education_app/core/types/types.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/features/on_boarding/domian/repositories/on_boarding_repository.dart';

class CacheFirstTimer implements UseCaseWithoutParams<void> {
  final OnBoardingRepository repository;

  const CacheFirstTimer(this.repository);

  @override
  ResultFuture<void> call() async {
    return await repository.cacheFirstTimer();
  }
}
