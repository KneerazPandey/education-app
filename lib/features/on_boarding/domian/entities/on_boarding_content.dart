import 'package:education_app/core/res/res.dart';
import 'package:equatable/equatable.dart';

class OnBoardingContent extends Equatable {
  final String image;
  final String title;
  final String description;

  const OnBoardingContent({
    required this.image,
    required this.title,
    required this.description,
  });

  factory OnBoardingContent.first() {
    return const OnBoardingContent(
      image: AppMedias.casualReading,
      title: 'Brand new curriculum',
      description:
          "This is the first online education platform designed by the world's",
    );
  }

  factory OnBoardingContent.second() {
    return const OnBoardingContent(
      image: AppMedias.casualLife,
      title: "Brand a fun atmosphere",
      description:
          "This is the first online education platform designed by the world's",
    );
  }

  factory OnBoardingContent.third() {
    return const OnBoardingContent(
      image: AppMedias.casualMeditation,
      title: "Enjoy to join the lesson",
      description:
          "This is the first online education platform designed by the world's",
    );
  }

  @override
  List<Object?> get props => [image, title, description];
}
