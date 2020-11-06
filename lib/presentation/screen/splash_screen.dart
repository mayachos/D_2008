import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_2008/di/get_it.dart';
import 'package:d_2008/presentation/screen/twitter_login_screen.dart';
import 'package:d_2008/presentation/transition/fade_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../env_constants.dart';

class SplashScreen extends StatelessWidget {
  final FirebaseAuth _auth = getItInstance.get<FirebaseAuth>();
  final TwitterLogin twitterLogin = TwitterLogin(
    consumerKey: twitterConsumerKey,
    consumerSecret: twitterSecretConsumerKey,
  );

  @override
  Widget build(BuildContext context) {
    logInWithTwitter(context);
    return Container(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset(
                    "assets/images/logo2.png",
                    width: 250.0,
                    height: 250.0,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logInWithTwitter(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final AuthCredential credential = TwitterAuthProvider.credential(
        accessToken: prefs.getString(twitterAccessToken),
        secret: prefs.getString(twitterSecret),
      );
      _auth.signInWithCredential(credential).then((user) {
        debugPrint("ログイン成功");
        prefs.setBool(loggedIn, true);
        User currentUser = user.user;
        UserInfo userInfo = currentUser.providerData.first;
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userInfo.uid);
        Map<String, dynamic> data = {
          "displayName": userInfo.displayName,
          "photoURL": userInfo.photoURL,
        };
        userRef.update(data).then((value) async {
          getItInstance.registerFactory<User>(() => currentUser);
          Navigator.pushNamed(context, '/home');
        });
        return;
      });
    } catch (error) {
      prefs.remove(twitterAccessToken);
      prefs.remove(twitterSecret);
      debugPrint("ログイン失敗");
      sleep(Duration(milliseconds: 1000));
      Navigator.pushReplacement(
        context,
        FadeRoute(page: TwitterLoginScreen()),
      );
    }
  }
}
