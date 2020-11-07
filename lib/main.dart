import 'package:d_2008/presentation/reasobi_app.dart';
import 'package:d_2008/presentation/screen/check_invite_screen.dart';
import 'package:d_2008/presentation/screen/home_screen.dart';
import 'package:d_2008/presentation/screen/participant_join_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';

import 'di/get_it.dart' as getIt;

void main() async {
  final MaterialColor customSwatch = const MaterialColor(0xff51B5C1, const <int, Color>{
    50: const Color(0xFFEAF6F8),
    100: const Color(0xFFCBE9EC),
    200: const Color(0xFFA8DAE0),
    300: const Color(0xFF85CBD4),
    400: const Color(0xFF6BC0CA),
    500: const Color(0xFF51B5C1), //baseColor
    600: const Color(0xFF4AAEBB),
    700: const Color(0xFF40A5B3),
    800: const Color(0xFF379DAB),
    900: const Color(0xFF278D9E),
  });

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  unawaited(getIt.init());

  runApp(MaterialApp(
    title: "REASOBI",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: customSwatch,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    routes: <String, WidgetBuilder>{
      '/': (BuildContext context) => ReasobiApp(),
      '/home': (BuildContext context) => HomeScreen(),
      '/invite': (BuildContext context) => CheckInviteScreen(),
      '/ParticipantJoin': (BuildContext context) => ParticipantJoin(),
    },
  ));
}
