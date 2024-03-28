import 'package:education_app/core/types/types.dart';

abstract interface class UseCaseWithoutParams<Type> {
  ResultFuture<Type> call();
}
