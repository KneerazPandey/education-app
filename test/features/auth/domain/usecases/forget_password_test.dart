import 'package:dartz/dartz.dart';
import 'package:education_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:education_app/features/auth/domain/usecases/forget_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/auth_repository_mock_test.dart';

void main() {
  late AuthRepository repository;
  late ForgetPassword usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = ForgetPassword(repository);
  });

  const String email = 'email@gmail.com';

  test(
    'should call [AuthRepository.forgetPassword] when the call is successfull',
    () async {
      when(() => repository.forgetPassword(any())).thenAnswer(
        (invocation) async => const Right(null),
      );

      final result = await usecase(const ForgetPasswordParams(email: email));

      expect(result, const Right(null));
      verify(() => repository.forgetPassword(email)).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
