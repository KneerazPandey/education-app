import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/res/colors.dart';
import 'package:education_app/core/res/fonts.dart';
import 'package:education_app/features/on_boarding/domian/entities/on_boarding_content.dart';
import 'package:education_app/features/on_boarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingBody extends StatelessWidget {
  final OnBoardingContent content;

  const OnBoardingBody({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          content.image,
          height: context.height * .4,
        ),
        SizedBox(height: context.height * .03),
        Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 0),
          child: Column(
            children: <Widget>[
              Text(
                content.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppFonts.aeonik,
                  fontWeight: FontWeight.w700,
                  fontSize: 40,
                ),
              ),
              SizedBox(height: context.height * .02),
              Text(
                content.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: context.height * .04),
              ElevatedButton(
                onPressed: () {
                  context.read<OnBoardingBloc>().add(CacheFirstTimerEvent());
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 17,
                  ),
                  backgroundColor: AppColors.primaryColour,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.aeonik,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
