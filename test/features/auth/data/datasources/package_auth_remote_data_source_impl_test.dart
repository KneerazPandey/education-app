import 'package:education_app/core/constants/constants.dart';
import 'package:education_app/core/enums/enums.dart';
import 'package:education_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore firebaseFirestoreClient;
  late MockFirebaseAuth firebaseAuthClient;
  late MockFirebaseStorage firebaseStorageClient;
  late AuthRemoteDataSourceImpl remoteDataSourceImpl;

  setUp(() async {
    firebaseFirestoreClient = FakeFirebaseFirestore();
    firebaseAuthClient = MockFirebaseAuth();
    firebaseStorageClient = MockFirebaseStorage();
    remoteDataSourceImpl = AuthRemoteDataSourceImpl(
      firebaseAuthClient: firebaseAuthClient,
      firebaseFirestoreClient: firebaseFirestoreClient,
      firebaseStorageClient: firebaseStorageClient,
    );
  });

  const String password = 'password';
  const String email = 'email';
  const String fullName = 'fullName';

  test('signUp', () async {
    await remoteDataSourceImpl.signUp(
      email: email,
      fullName: fullName,
      password: password,
    );

    expect(firebaseAuthClient.currentUser, isNotNull);
    expect(firebaseAuthClient.currentUser?.displayName, fullName);

    final user = await firebaseFirestoreClient
        .collection(FirebaseConstant.userCollection)
        .doc(firebaseAuthClient.currentUser!.uid)
        .get();
    expect(user.exists, isTrue);
  });

  test('signIn', () async {
    await remoteDataSourceImpl.signUp(
      email: email,
      fullName: fullName,
      password: password,
    );
    await remoteDataSourceImpl.signIn(email: email, password: password);
    expect(firebaseAuthClient.currentUser, isNotNull);
    expect(firebaseAuthClient.currentUser?.email, email);
  });

  group('updateUser', () {
    setUp(() async {
      await remoteDataSourceImpl.signUp(
        email: email,
        fullName: fullName,
        password: password,
      );
      await remoteDataSourceImpl.signIn(email: email, password: password);
    });

    test('update fullName', () async {
      await remoteDataSourceImpl.updateUser(
        action: UpdateUserAction.fullName,
        data: 'NewFullName',
      );

      expect(firebaseAuthClient.currentUser?.displayName, 'NewFullName');
    });
  });
}
