import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_2008/constants.dart';
import 'package:d_2008/di/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInviteScreen extends StatefulWidget {
  final String inviteId;
  CheckInviteScreen({this.inviteId});
  @override
  _CheckInviteScreenState createState() => _CheckInviteScreenState(inviteId);
}

class _CheckInviteScreenState extends State<CheckInviteScreen> {
  _CheckInviteScreenState(this.inviteId);
  final User currentUser = getItInstance.get<User>();
  final String inviteId;
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REASOBI"),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }

  Future<void> getData() async {
    String path = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (inviteId == null || inviteId.isNotEmpty) {
      path = prefs.get(inviteKey);
    } else {
      path = inviteId;
    }
    DocumentReference inviteRef = FirebaseFirestore.instance.doc("/invites/$path");
    inviteRef.get().then((DocumentSnapshot snapShot) {
      snapShot.data().forEach((key, value) {
        debugPrint("key: $key");
        debugPrint("value: $value");
        // TODO: IDをみて条件分岐
        Navigator.pushReplacementNamed(context, "/ParticipantJoin");
      });
    });
  }
}
