import 'package:education_app/core/injection/global_injection.dart';
import 'package:education_app/core/injection/on_boarding_injection.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> inject() async {
  await onBoardingInjection();
  await globalInjection();
}
