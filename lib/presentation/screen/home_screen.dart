import 'package:d_2008/presentation/screen/invite_screen.dart';
import 'package:d_2008/presentation/transition/fade_route.dart';
import 'package:d_2008/presentation/widget/invite_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REASOBI"),
        leading: Container(),
        leadingWidth: 0.0,
      ),
      body: SafeArea(
        child: WillPopScope(
          child: InviteListView(),
          onWillPop: () {
            return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
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
