import 'package:education_app/core/types/types.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class ForgetPassword implements UseCaseWithParams<void, ForgetPasswordParams> {
  final AuthRepository repository;

  const ForgetPassword(this.repository);

  @override
  ResultFuture<void> call(params) async {
    return await repository.forgetPassword(params.email);
  }
}

class ForgetPasswordParams extends Equatable {
  final String email;

  const ForgetPasswordParams({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}
