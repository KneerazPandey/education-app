import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/enums.dart';
import 'package:education_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:education_app/features/auth/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/auth_repository_mock_test.dart';

void main() {
  late AuthRepository repository;
  late UpdateUser usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = UpdateUser(repository);
  });

  const UpdateUserAction action = UpdateUserAction.email;
  const dynamic data = 'updatedemail@gmail.com';

  test(
    'should udate user by calling [AuthRepository.updateUser] when the call is successfull',
    () async {
      when(() =>
              repository.updateUser(action: action, data: any(named: 'data')))
          .thenAnswer(
        (invocation) async => const Right(null),
      );

      final result =
          await usecase(const UpdateUserParams(data: data, action: action));

      expect(result, equals(const Right(null)));
      verify(() => repository.updateUser(action: action, data: data)).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
