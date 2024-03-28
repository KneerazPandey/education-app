import 'package:education_app/core/common/views/page_under_construction_screen.dart';
import 'package:education_app/features/on_boarding/presentation/screen/on_boarding_screen.dart';
import 'package:education_app/core/routing/app_routing.dart';
import 'package:flutter/material.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRouting.onBoardingScreenRouteName:
      return _buildPageRoute(
        settings: settings,
        page: const OnBoardingScreen(),
      );
    default:
      return _buildPageRoute(
        settings: settings,
        page: const PageUnderConstructionScreen(),
      );
  }
}

PageRouteBuilder<dynamic> _buildPageRoute({
  required RouteSettings settings,
  required Widget page,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
  );
}
