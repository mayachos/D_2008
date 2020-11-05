import 'package:d_2008/presentation/screen/splash_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ReasobiApp extends StatefulWidget {
  @override
  _ReasobiAppState createState() => _ReasobiAppState();
}

class _ReasobiAppState extends State<ReasobiApp> {
  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
  }

  void initDynamicLinks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(inviteKey);
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        String invitedId = deepLink.queryParameters["id"];
        prefs.setString(inviteKey, invitedId);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
      final String invitedId = deepLink.queryParameters["id"];
      prefs.setString(inviteKey, invitedId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(),
    );
  }
}
