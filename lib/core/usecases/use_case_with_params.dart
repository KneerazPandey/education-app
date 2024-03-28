import 'package:education_app/core/types/types.dart';

abstract interface class UseCaseWithParams<Type, Params> {
  ResultFuture<Type> call(Params params);
}
