import 'package:d_2008/di/get_it.dart';
import 'package:d_2008/presentation/screen/home_screen.dart';
import 'package:d_2008/presentation/screen/twitter_login_screen.dart';
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
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logInWithTwitter(BuildContext context) async {
    final SharedPreferences prefs = await getItInstance.getAsync<SharedPreferences>();
    try {
      final AuthCredential credential = TwitterAuthProvider.credential(
        accessToken: prefs.getString(twitterAccessToken),
        secret: prefs.getString(twitterSecret),
      );
      _auth.signInWithCredential(credential).then((user) {
        debugPrint("ログイン成功");
        getItInstance.registerFactory<User>(() => user.user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext _) => HomeScreen(),
          ),
        );
        return;
      });
    } catch (error) {
      prefs.remove(twitterAccessToken);
      prefs.remove(twitterSecret);
      debugPrint("ログイン失敗");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext _) => TwitterLoginScreen(),
        ),
      );
    }
  }
}
