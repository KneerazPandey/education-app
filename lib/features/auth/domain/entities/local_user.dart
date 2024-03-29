import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  final String uid;
  final String email;
  final String? profilePic;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> groups;
  final List<String> enrolledCourseIds;
  final List<String> followings;
  final List<String> followers;

  const LocalUser({
    required this.uid,
    required this.email,
    this.profilePic,
    this.bio,
    required this.points,
    required this.fullName,
    this.groups = const [],
    this.enrolledCourseIds = const [],
    this.followers = const [],
    this.followings = const [],
  });

  factory LocalUser.empty() {
    return const LocalUser(
      uid: '',
      email: '',
      fullName: '',
      profilePic: '',
      bio: '',
      points: 0,
      enrolledCourseIds: [],
      followers: [],
      followings: [],
      groups: [],
    );
  }

  @override
  List<Object?> get props => [uid, email];
}
