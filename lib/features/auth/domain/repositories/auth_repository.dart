import 'package:education_app/core/enums/enums.dart';
import 'package:education_app/core/types/types.dart';
import 'package:education_app/features/auth/domain/entities/local_user.dart';

abstract interface class AuthRepository {
  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  });

  ResultFuture<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });

  ResultFuture<void> forgetPassword(String email);

  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic data,
  });
}
