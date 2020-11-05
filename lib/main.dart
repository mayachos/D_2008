import 'package:d_2008/presentation/reasobi_app.dart';
import 'package:d_2008/presentation/widget/invite_list_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';

import 'di/get_it.dart' as getIt;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  unawaited(getIt.init());

  runApp(MaterialApp(
    title: "REASOBI",
    theme: ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    routes: <String, WidgetBuilder>{
      '/invite': (BuildContext context) => InviteListView(),
      '/': (BuildContext context) => ReasobiApp(),
    },
  ));
}
