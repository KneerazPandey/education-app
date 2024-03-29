import 'dart:convert';

import 'package:education_app/core/types/types.dart';
import 'package:education_app/features/auth/data/models/local_user_model.dart';
import 'package:education_app/features/auth/domain/entities/local_user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  LocalUserModel localUserModel = LocalUserModel.empty();
  final map = jsonDecode(fixtureReader('user.json')) as DataMap;

  test('should be a subclass of [LocalUser] entity', () async {
    expect(localUserModel, isA<LocalUser>());
  });

  group('fromMap', () {
    test(
      'should return a valid [LocalUserModel] from the map data',
      () {
        final result = LocalUserModel.fromMap(map);

        expect(result, isA<LocalUserModel>());
        expect(result, localUserModel);
      },
    );

    test('should throw a [Error] when the map is invalid', () {
      final newMap = map..remove('uid');
      const methodCall = LocalUserModel.fromMap;

      expect(() => methodCall(newMap), throwsA(isA<Error>()));
    });
  });

  group('toMap', () {
    test('should return a valid [DataMap] from the LocalUserModel', () {
      final result = localUserModel.toMap();
      expect(result, map);
    });
  });

  group('copyWith', () {
    test(
      'should return a valid [LocalUserModel] with the updated value',
      () {
        final result = localUserModel.copyWith(uid: '1111');
        expect(result.uid, '1111');
      },
    );
  });
}
