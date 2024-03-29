import 'package:dartz/dartz.dart';
import 'package:education_app/features/auth/domain/entities/local_user.dart';
import 'package:education_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:education_app/features/auth/domain/usecases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/auth_repository_mock_test.dart';

void main() {
  late AuthRepository repository;
  late SignIn usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = SignIn(repository);
  });

  const String email = 'email@gmail.com';
  const String password = 'password';

  test(
    'should call [AuthRepository.signIn] with LocalUser when the call is successfull',
    () async {
      when(() => repository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'))).thenAnswer(
        (invocation) async => Right(LocalUser.empty()),
      );

      final result = await usecase(
        const SignInParams(email: email, password: password),
      );

      expect(result, equals(Right(LocalUser.empty())));
      verify(() => repository.signIn(email: email, password: password))
          .called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
