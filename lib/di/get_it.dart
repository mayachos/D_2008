import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getItInstance.registerSingletonAsync<SharedPreferences>(() async => await SharedPreferences.getInstance());
}
