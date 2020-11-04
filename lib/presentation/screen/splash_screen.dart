import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
