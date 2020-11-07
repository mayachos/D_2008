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
    prefs.remove(loggedIn);
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        await Future.delayed(Duration(seconds: 4));
        String invitedId = deepLink.queryParameters["id"];
        prefs.setString(inviteKey, invitedId);
        Navigator.pushNamed(context, "/invite");
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      await Future.delayed(Duration(seconds: 4));
      final String invitedId = deepLink.queryParameters["id"];
      prefs.setString(inviteKey, invitedId);
      Navigator.pushNamed(context, '/invite');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(),
    );
  }
}
