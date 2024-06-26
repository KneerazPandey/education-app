import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/res/res.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageUnderConstructionScreen extends StatelessWidget {
  const PageUnderConstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        image: AppMedias.onBoardingBackground,
        child: SafeArea(
          child: Center(
            child: Lottie.asset(AppMedias.pageUnderConstruction),
          ),
        ),
      ),
    );
  }
}
