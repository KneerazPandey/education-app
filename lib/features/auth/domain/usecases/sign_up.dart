import 'package:education_app/core/types/types.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignUp implements UseCaseWithParams<void, SignUpParams> {
  final AuthRepository repository;

  const SignUp(this.repository);

  @override
  ResultFuture<void> call(SignUpParams params) async {
    return await repository.signUp(
      email: params.email,
      fullName: params.fullName,
      password: params.password,
    );
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String fullName;
  final String password;

  const SignUpParams({
    required this.email,
    required this.fullName,
    required this.password,
  });

  @override
  List<Object?> get props => [email, fullName, password];
}
