import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/constants/constants.dart';
import 'package:education_app/core/enums/enums.dart';
import 'package:education_app/core/errors/errors.dart';
import 'package:education_app/core/types/types.dart';
import 'package:education_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:education_app/features/auth/data/models/local_user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {
  User? _user;

  MockUserCredential(User? user) : _user = user;

  @override
  User? get user => _user;

  set user(User? user) {
    _user = user;
  }
}

class MockUser extends Mock implements User {
  String _uid = 'uid';
  final String _email = 'email@gmail.com';

  @override
  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  @override
  String get email => _email;
}

void main() {
  late FirebaseAuth firebaseAuthClient;
  late FirebaseFirestore firebaseFirestoreClient;
  late FirebaseStorage firebaseStorageClient;
  late AuthRemoteDataSourceImpl remoteDataSourceImpl;
  late UserCredential userCredential;
  late User user;
  late DocumentReference<DataMap> documentReference;

  final LocalUserModel localUserModel = LocalUserModel.empty();
  const String email = 'email@gmail.com';
  const String password = 'password';
  const String fullName = 'fullName';
  FirebaseAuthException firebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no user associated with this email and password',
  );

  setUp(() async {
    firebaseAuthClient = MockFirebaseAuth();
    firebaseFirestoreClient = FakeFirebaseFirestore();
    firebaseStorageClient = MockFirebaseStorage();
    documentReference = firebaseFirestoreClient
        .collection(FirebaseConstant.userCollection)
        .doc();
    await documentReference
        .set(localUserModel.copyWith(uid: documentReference.id).toMap());
    user = MockUser()..uid = documentReference.id;
    userCredential = MockUserCredential(user);
    remoteDataSourceImpl = AuthRemoteDataSourceImpl(
      firebaseAuthClient: firebaseAuthClient,
      firebaseFirestoreClient: firebaseFirestoreClient,
      firebaseStorageClient: firebaseStorageClient,
    );

    when(() => firebaseAuthClient.currentUser).thenReturn(user);
  });

  group('forgetPassword', () {
    test(
      'should complete successfully when no [Exception] is thrown',
      () async {
        when(
          () => firebaseAuthClient.sendPasswordResetEmail(
              email: any(named: 'email')),
        ).thenAnswer((invocation) async => Future.value(null));

        final call = remoteDataSourceImpl.forgetPassword(email);
        expect(call, completes);
        verify(() => firebaseAuthClient.sendPasswordResetEmail(email: email))
            .called(1);
        verifyNoMoreInteractions(firebaseAuthClient);
      },
    );

    test(
      'should thrwo [ServerException] when [FirebaseAuthException] is thrown',
      () async {
        when(
          () => firebaseAuthClient.sendPasswordResetEmail(
              email: any(named: 'email')),
        ).thenThrow(firebaseAuthException);

        final call = remoteDataSourceImpl.forgetPassword;

        expect(() => call(email), throwsA(isA<ServerException>()));
        verify(() => firebaseAuthClient.sendPasswordResetEmail(email: email))
            .called(1);
        verifyNoMoreInteractions(firebaseAuthClient);
      },
    );
  });

  group('signIn', () {
    test(
      'should return [LocalUserModel] when no exception is thrown',
      () async {
        when(
          () => firebaseAuthClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((invocation) async => userCredential);

        final result = await remoteDataSourceImpl.signIn(
          email: email,
          password: password,
        );

        expect(result.uid, userCredential.user?.uid);
        expect(result.points, 0);
        verify(() => firebaseAuthClient.signInWithEmailAndPassword(
            email: email, password: password));
        verifyNoMoreInteractions(firebaseAuthClient);
      },
    );

    test(
      'should throw [ServerException] when the [FirebaseAuthException] or any exception is thrown',
      () async {
        when(() => firebaseAuthClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'))).thenThrow(firebaseAuthException);

        final call = remoteDataSourceImpl.signIn;

        expect(() => call(email: email, password: password),
            throwsA(isA<ServerException>()));
        verify(() => firebaseAuthClient.signInWithEmailAndPassword(
            email: email, password: password)).called(1);
        verifyNoMoreInteractions(firebaseAuthClient);
      },
    );

    test(
      'should throw [ServerException] when user is null after signing in',
      () async {
        final UserCredential emptyUserCredential = MockUserCredential(null);
        when(() => firebaseAuthClient.signInWithEmailAndPassword(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((invocation) async => emptyUserCredential);

        final call = remoteDataSourceImpl.signIn;

        expect(() => call(email: email, password: password),
            throwsA(isA<ServerException>()));
        verify(() => firebaseAuthClient.signInWithEmailAndPassword(
            email: email, password: password)).called(1);
        verifyNoMoreInteractions(firebaseAuthClient);
      },
    );
  });

  group('signUp', () {
    test(
      'should complete successfully when there is no any exception thrown',
      () async {
        when(() => firebaseAuthClient.createUserWithEmailAndPassword(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((invocation) async => userCredential);
        when(() => userCredential.user?.updateDisplayName(any()))
            .thenAnswer((invocation) async => Future.value());
        when(() => userCredential.user?.updatePhotoURL(any()))
            .thenAnswer((invocation) async => Future.value());

        final call = remoteDataSourceImpl.signUp(
          email: email,
          fullName: fullName,
          password: password,
        );

        expect(call, completes);
        verify(
          () => firebaseAuthClient.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);

        await untilCalled(() => userCredential.user?.updateDisplayName(any()));
        await untilCalled(() => userCredential.user?.updatePhotoURL(any()));

        verify(
          () => userCredential.user?.updateDisplayName(fullName),
        ).called(1);
        verify(
          () => userCredential.user?.updatePhotoURL(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0GtXLJA1Hl7oE2QzfHLcd-wRU7o-OrPdAiAZINnAUPA&s',
          ),
        ).called(1);
        verifyNoMoreInteractions(firebaseAuthClient);
      },
    );

    test(
      'should throw [ServerExcrption] if [FirebaseAuthException] or any exception occured',
      () async {
        when(() => firebaseAuthClient.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'))).thenThrow(firebaseAuthException);

        final call = remoteDataSourceImpl.signUp;

        expect(
          () => call(email: email, password: password, fullName: fullName),
          throwsA(isA<ServerException>()),
        );
        verify(() => firebaseAuthClient.createUserWithEmailAndPassword(
            email: email, password: password)).called(1);
        verifyNoMoreInteractions(firebaseAuthClient);
      },
    );
  });

  group('updateUser', () {
    setUp(() {
      when(() => firebaseAuthClient.currentUser).thenReturn(user);
    });
    test(
      'should update user details successfully when no exception is thrown ',
      () async {
        when(() => user.updateDisplayName(any()))
            .thenAnswer((invocation) async => Future.value());

        final call = remoteDataSourceImpl.updateUser(
          action: UpdateUserAction.fullName,
          data: fullName,
        );

        expect(call, completes);
        verify(
          () => user.updateDisplayName(fullName),
        ).called(1);
      },
    );
  });
}
