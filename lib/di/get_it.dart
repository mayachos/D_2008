import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getItInstance.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
}
