import 'package:education_app/core/injection/dependency_injection.dart';
import 'package:education_app/core/res/res.dart';
import 'package:education_app/core/routing/app_routing.dart';
import 'package:education_app/core/routing/routing.dart';
import 'package:education_app/features/on_boarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await inject();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnBoardingBloc>(
          create: (BuildContext context) => sl<OnBoardingBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Education App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSwatch(
            accentColor: AppColors.primaryColour,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
          ),
          fontFamily: AppFonts.poppins,
        ),
        onGenerateRoute: onGenerateRoute,
        initialRoute: AppRouting.onBoardingScreenRouteName,
      ),
    );
  }
}
