import 'package:education_app/core/injection/dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> globalInjection() async {
  final SharedPreferences sharedPreference =
      await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreference);
}
