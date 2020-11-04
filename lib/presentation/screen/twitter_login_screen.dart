import 'package:d_2008/di/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../env_constants.dart';
import 'home_screen.dart';

class TwitterLoginScreen extends StatefulWidget {
  final String title;

  TwitterLoginScreen({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _TwitterLoginScreenState createState() => _TwitterLoginScreenState();
}

class _TwitterLoginScreenState extends State {
  final FirebaseAuth _auth = getItInstance.get<FirebaseAuth>();
  final TwitterLogin twitterLogin = TwitterLogin(
    consumerKey: twitterConsumerKey,
    consumerSecret: twitterSecretConsumerKey,
  );

  // Twitterを経由してログイン認証
  Future<void> signInWithTwitter() async {
    final TwitterLoginResult result = await twitterLogin.authorize();
    final SharedPreferences prefs = await getItInstance.getAsync<SharedPreferences>();

    final AuthCredential credential = TwitterAuthProvider.credential(
      accessToken: result.session.token,
      secret: result.session.secret,
    );

    final User user = (await _auth.signInWithCredential(credential)).user;

    if (user.getIdToken() != null) {
      prefs.setString(twitterAccessToken, result.session.token);
      prefs.setString(twitterSecret, result.session.secret);
      getItInstance.registerFactory<User>(() => user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext _) => HomeScreen(),
        ),
      );
    } else {
      prefs.setString(twitterAccessToken, "");
      prefs.setString(twitterSecret, "");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget loginBtnTwitter = RaisedButton(
      child: Text("Sign in with Twitter"),
      color: Color(0xFF1DA1F2),
      textColor: Colors.white,
      onPressed: signInWithTwitter,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loginBtnTwitter,
          ],
        ),
      ),
    );
  }
}
