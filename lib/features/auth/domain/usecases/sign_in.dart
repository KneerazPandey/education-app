import 'package:education_app/core/types/types.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/features/auth/domain/entities/local_user.dart';
import 'package:education_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignIn implements UseCaseWithParams<LocalUser, SignInParams> {
  final AuthRepository repository;

  const SignIn(this.repository);

  @override
  ResultFuture<LocalUser> call(SignInParams params) async {
    return await repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
