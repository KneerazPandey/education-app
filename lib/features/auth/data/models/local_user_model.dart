import 'package:education_app/core/types/types.dart';
import 'package:education_app/features/auth/domain/entities/local_user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.points,
    required super.fullName,
    super.groups,
    super.followers,
    super.followings,
    super.bio,
    super.profilePic,
    super.enrolledCourseIds,
  });

  factory LocalUserModel.empty() {
    return const LocalUserModel(
      uid: '',
      email: '',
      points: 0,
      fullName: '',
      bio: null,
      profilePic: null,
      enrolledCourseIds: [],
      followers: [],
      followings: [],
      groups: [],
    );
  }

  LocalUserModel copyWith({
    String? uid,
    String? email,
    int? points,
    String? fullName,
    String? bio,
    String? profilePic,
    List<String>? enrolledCourseIds,
    List<String>? followers,
    List<String>? followings,
    List<String>? groups,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      points: points ?? this.points,
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      profilePic: profilePic ?? this.profilePic,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      groups: groups ?? this.groups,
    );
  }

  factory LocalUserModel.fromMap(DataMap map) {
    return LocalUserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      points: (map['points'] as num).toInt(),
      fullName: map['fullName'] as String,
      profilePic: map['profilePic'] as String?,
      bio: map['bio'] as String?,
      groups: (map['groups'] as List<dynamic>).cast<String>(),
      followers: (map['followers'] as List<dynamic>).cast<String>(),
      followings: (map['followings'] as List<dynamic>).cast<String>(),
      enrolledCourseIds:
          (map['enrolledCourseIds'] as List<dynamic>).cast<String>(),
    );
  }

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'points': points,
      'profilePic': profilePic,
      'fullName': fullName,
      'bio': bio,
      'groups': groups,
      'followers': followers,
      'followings': followings,
      'enrolledCourseIds': enrolledCourseIds,
    };
  }
}
