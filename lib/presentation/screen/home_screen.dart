import 'package:d_2008/presentation/screen/invite_screen.dart';
import 'package:d_2008/presentation/transition/fade_route.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REASOBI"),
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            // TODO: Change List View
            child: Container(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            FadeRoute(page: InviteScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(0, 150, 136, 1.0),
      ),
    );
  }
}
