import 'package:education_app/core/enums/enums.dart';
import 'package:education_app/core/types/types.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateUser implements UseCaseWithParams<void, UpdateUserParams> {
  final AuthRepository repository;

  const UpdateUser(this.repository);

  @override
  ResultFuture<void> call(UpdateUserParams params) async {
    return await repository.updateUser(
      action: params.action,
      data: params.data,
    );
  }
}

class UpdateUserParams extends Equatable {
  final dynamic data;
  final UpdateUserAction action;

  const UpdateUserParams({
    required this.data,
    required this.action,
  });

  @override
  List<Object?> get props => [data, action];
}
