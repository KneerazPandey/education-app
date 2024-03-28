import 'package:education_app/core/types/types.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/features/on_boarding/domian/repositories/on_boarding_repository.dart';

class CheckFirstTimer implements UseCaseWithoutParams<bool> {
  final OnBoardingRepository repository;

  const CheckFirstTimer(this.repository);

  @override
  ResultFuture<bool> call() async {
    return await repository.checkFirstTimer();
  }
}
