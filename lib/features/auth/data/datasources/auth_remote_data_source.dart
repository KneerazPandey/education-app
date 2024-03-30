import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/constants/firebase_constant.dart';
import 'package:education_app/core/enums/enums.dart';
import 'package:education_app/core/errors/errors.dart';
import 'package:education_app/core/types/types.dart';
import 'package:education_app/features/auth/data/models/local_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuthClient;
  final FirebaseFirestore firebaseFirestoreClient;
  final FirebaseStorage firebaseStorageClient;

  const AuthRemoteDataSourceImpl({
    required this.firebaseAuthClient,
    required this.firebaseFirestoreClient,
    required this.firebaseStorageClient,
  });

  @override
  Future<void> forgetPassword(String email) async {
    try {
      await firebaseAuthClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (exception) {
      throw ServerException(
        message: exception.message ?? 'Error Occured',
        statusCode: exception.code,
      );
    } catch (exception) {
      throw ServerException(message: exception.toString(), statusCode: '500');
    }
  }

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
          await firebaseAuthClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      if (user != null) {
        DocumentSnapshot<DataMap> userData =
            await _getUserDetailsFromDocument(user.uid);
        if (userData.exists) {
          return LocalUserModel.fromMap(userData.data()!);
        }
        await _createUserDocument(user);
        final recentData = await _getUserDetailsFromDocument(user.uid);
        return LocalUserModel.fromMap(recentData.data()!);
      }
      throw const ServerException(
        message: 'Please try again.',
        statusCode: '500',
      );
    } on ServerException {
      rethrow;
    } on FirebaseAuthException catch (exception) {
      throw ServerException(
        message: exception.message ?? 'Error Occured',
        statusCode: exception.code,
      );
    } catch (exception) {
      throw ServerException(message: exception.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      UserCredential credential = await firebaseAuthClient
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(fullName);
      await credential.user?.updatePhotoURL(
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0GtXLJA1Hl7oE2QzfHLcd-wRU7o-OrPdAiAZINnAUPA&s',
      );
      if (credential.user != null) {
        await _createUserDocument(credential.user!);
      }
      return;
    } on FirebaseAuthException catch (exception) {
      throw ServerException(
        message: exception.message ?? 'Error Occured',
        statusCode: exception.code,
      );
    } catch (exception) {
      throw ServerException(message: exception.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    required data,
  }) async {
    try {
      switch (action) {
        case UpdateUserAction.fullName:
          await firebaseAuthClient.currentUser
              ?.updateDisplayName(data as String);
          await _updateUserDetails({'fullName': data});
          break;
        case UpdateUserAction.email:
          await firebaseAuthClient.currentUser
              ?.verifyBeforeUpdateEmail(data as String);
          await _updateUserDetails({'email': data});
          break;
        case UpdateUserAction.profilePic:
          final Reference ref = firebaseStorageClient.ref().child(
              '${FirebaseConstant.userProfilePicStorage}/${firebaseAuthClient.currentUser?.uid}');
          await ref.putFile(data as File);
          final String url = await ref.getDownloadURL();
          await firebaseAuthClient.currentUser?.updatePhotoURL(url);
          await _updateUserDetails({'profilePic': url});
          break;
        case UpdateUserAction.password:
          final newData = jsonDecode(data as String) as DataMap;
          final User? user = firebaseAuthClient.currentUser;
          if (user == null || user.email == null) {
            throw const ServerException(
              message: 'User Does not exists',
              statusCode: '401',
            );
          }
          await firebaseAuthClient.currentUser?.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: user.email!,
              password: newData['oldPassword'] as String,
            ),
          );
          await firebaseAuthClient.currentUser?.updatePassword(
            newData['newPassword'] as String,
          );
          break;
        case UpdateUserAction.bio:
          await _updateUserDetails({'bio': data as String});
          break;
        default:
          break;
      }
    } on ServerException {
      rethrow;
    } on FirebaseAuthException catch (exception) {
      throw ServerException(
        message: exception.message ?? 'Error Occured',
        statusCode: exception.code,
      );
    } on FirebaseException catch (exception) {
      throw ServerException(
        message: exception.message ?? 'Error Occured',
        statusCode: exception.code,
      );
    } catch (exception) {
      throw ServerException(message: exception.toString(), statusCode: '500');
    }
  }

  Future<void> _createUserDocument(User user) async {
    return await firebaseFirestoreClient
        .collection(FirebaseConstant.userCollection)
        .doc(user.uid)
        .set(
          LocalUserModel(
            uid: user.uid,
            email: user.email!,
            points: 0,
            fullName: user.displayName ?? '',
          ).toMap(),
        );
  }

  Future<DocumentSnapshot<DataMap>> _getUserDetailsFromDocument(
    String uid,
  ) async {
    return await firebaseFirestoreClient
        .collection(FirebaseConstant.userCollection)
        .doc(uid)
        .get();
  }

  Future<void> _updateUserDetails(DataMap map) async {
    return await firebaseFirestoreClient
        .collection(FirebaseConstant.userCollection)
        .doc(firebaseAuthClient.currentUser?.uid)
        .update(map);
  }
}
