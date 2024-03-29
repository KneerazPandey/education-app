import 'package:education_app/core/enums/enums.dart';
import 'package:education_app/features/auth/data/models/local_user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<void> forgetPassword(String email);

  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });

  Future<void> updateUser({
    required UpdateUserAction action,
    required data,
  });
}
