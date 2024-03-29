import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/enums.dart';
import 'package:education_app/core/errors/errors.dart';
import 'package:education_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:education_app/features/auth/data/models/local_user_model.dart';
import 'package:education_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../datasources/auth_remote_data_source_mock_test.dart';

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late AuthRepositoryImpl repositoryImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repositoryImpl = AuthRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  const String email = 'email@gmail.com';
  const String password = 'password';
  const String fullName = 'fullname';
  const String message = 'Error Occured';
  const dynamic statusCode = 400;
  const ServerException serverException = ServerException(
    message: message,
    statusCode: statusCode,
  );

  group('forgetPassword', () {
    test(
      'should call [AuthRemoteDataSource.forgetPassword] successfully',
      () async {
        when(() => remoteDataSource.forgetPassword(any()))
            .thenAnswer((invocation) async => Future.value(null));

        final result = await repositoryImpl.forgetPassword(email);

        expect(result, const Right(null));
        verify(() => remoteDataSource.forgetPassword(email)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when the call to remote datasource is unsuccessull',
      () async {
        when(() => remoteDataSource.forgetPassword(any()))
            .thenThrow(serverException);

        final result = await repositoryImpl.forgetPassword(email);

        expect(result, Left(ServerFailure.fromException(serverException)));
        verify(() => remoteDataSource.forgetPassword(email)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('signIn', () {
    test(
      'should return [LocalUser] when the call to remote datasource is successfull',
      () async {
        when(() => remoteDataSource.signIn(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((invocation) async => LocalUserModel.empty());

        final result =
            await repositoryImpl.signIn(email: email, password: password);

        expect(result, Right(LocalUserModel.empty()));
        verify(() => remoteDataSource.signIn(email: email, password: password))
            .called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when the call to remote datasource is unsuccessfull',
      () async {
        when(() => remoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'))).thenThrow(serverException);

        final result =
            await repositoryImpl.signIn(email: email, password: password);

        expect(result, Left(ServerFailure.fromException(serverException)));
        verify(() => remoteDataSource.signIn(email: email, password: password))
            .called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('updateUser', () {
    test(
      'should update the user profile when the call to remote datasource is successfull',
      () async {
        when(
          () => remoteDataSource.updateUser(
              action: UpdateUserAction.email, data: 'data'),
        ).thenAnswer((invocation) async => Future.value(null));

        final result = await repositoryImpl.updateUser(
            action: UpdateUserAction.email, data: 'data');

        expect(result, const Right(null));
        verify(() => remoteDataSource.updateUser(
            action: UpdateUserAction.email, data: 'data')).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when the call to remote datasource is unsuccessfull',
      () async {
        when(() => remoteDataSource.updateUser(
            action: UpdateUserAction.email,
            data: 'data')).thenThrow(serverException);

        final result = await repositoryImpl.updateUser(
            action: UpdateUserAction.email, data: 'data');

        expect(result, Left(ServerFailure.fromException(serverException)));
        verify(() => remoteDataSource.updateUser(
            action: UpdateUserAction.email, data: 'data')).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('signUp', () {
    test(
      'should complete when the call to remote datasource is successfull',
      () async {
        when(() => remoteDataSource.signUp(
                email: any(named: 'email'),
                password: any(named: 'password'),
                fullName: any(named: 'fullName')))
            .thenAnswer((invocation) async => Future.value(null));

        final result = await repositoryImpl.signUp(
          email: email,
          password: password,
          fullName: fullName,
        );

        expect(result, const Right(null));
        verify(() => remoteDataSource.signUp(
            email: email, password: password, fullName: fullName)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when the call to remote datasource is unsuccessfull',
      () async {
        when(() => remoteDataSource.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
            )).thenThrow(serverException);

        final result = await repositoryImpl.signUp(
            email: email, password: password, fullName: fullName);

        expect(result, Left(ServerFailure.fromException(serverException)));
        verify(() => remoteDataSource.signUp(
              email: email,
              password: password,
              fullName: fullName,
            )).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
