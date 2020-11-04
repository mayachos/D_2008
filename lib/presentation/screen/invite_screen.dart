import 'package:flutter/material.dart';

class InviteScreen extends StatefulWidget {
  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REASOBI"),
      ),
      body: SafeArea(
        child: Container(),
      ),
      floatingActionButton: true
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.check),
              backgroundColor: Color.fromRGBO(0, 150, 136, 1.0),
            )
          : null,
    );
  }
}
