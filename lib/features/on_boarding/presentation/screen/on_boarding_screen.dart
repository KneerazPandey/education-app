import 'package:education_app/core/common/views/loading_view.dart';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/res/res.dart';
import 'package:education_app/core/routing/app_routing.dart';
import 'package:education_app/features/on_boarding/domian/entities/on_boarding_content.dart';
import 'package:education_app/features/on_boarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:education_app/features/on_boarding/presentation/widgets/on_boarding_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    context.read<OnBoardingBloc>().add(CheckFirstTimerEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnBoardingBloc, OnBoardingState>(
      listener: (context, state) {
        if (state is CheckedFirstTimerStatus && !state.isFirstTimer) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouting.loginScreenRouteName,
            (route) => false,
          );
        } else if (state is UserCached) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouting.loginScreenRouteName,
            (route) => false,
          );
        }
      },
      builder: (BuildContext context, OnBoardingState state) {
        if (state is CheckingFirstTimer || state is CachingFirstTimer) {
          return const GradientBackground(
            image: AppMedias.onBoardingBackground,
            child: LoadingView(),
          );
        }
        return Scaffold(
          body: GradientBackground(
            image: AppMedias.onBoardingBackground,
            child: Stack(
              children: <Widget>[
                PageView(
                  controller: pageController,
                  children: <Widget>[
                    OnBoardingBody(content: OnBoardingContent.first()),
                    OnBoardingBody(content: OnBoardingContent.second()),
                    OnBoardingBody(content: OnBoardingContent.third()),
                  ],
                ),
                Align(
                  alignment: const Alignment(0, .08),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    onDotClicked: (int index) {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 20,
                      activeDotColor: AppColors.primaryColour,
                      dotColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
