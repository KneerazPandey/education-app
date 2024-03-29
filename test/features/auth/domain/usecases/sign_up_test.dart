import 'package:dartz/dartz.dart';
import 'package:education_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:education_app/features/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/auth_repository_mock_test.dart';

void main() {
  late AuthRepository repository;
  late SignUp usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = SignUp(repository);
  });

  const String email = 'email@gmail.com';
  const String password = 'password';
  const String fullName = 'fullName';

  test(
    'should call [AuthRepository.signUp] method and should execute successfully',
    () async {
      when(
        () => repository.signUp(
          email: any(named: 'email'),
          fullName: any(named: 'fullName'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((invocation) async => const Right(null));

      final result = await usecase(
        const SignUpParams(
            email: email, fullName: fullName, password: password),
      );

      expect(result, equals(const Right(null)));
      verify(
        () => repository.signUp(
            email: email, fullName: fullName, password: password),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
