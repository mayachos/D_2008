import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_2008/di/get_it.dart';
import 'package:d_2008/domain/entity/invite_entity.dart';
import 'package:d_2008/presentation/screen/invite_screen.dart';
import 'package:d_2008/presentation/transition/fade_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    fetchInvites();
    return Scaffold(
      appBar: AppBar(
        title: Text("REASOBI"),
      ),
      body: SafeArea(
        child: WillPopScope(
          child: Container(
            child: SingleChildScrollView(
              // TODO: Change List View
              child: Container(),
            ),
          ),
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

  Future<void> fetchInvites() async {
    final User currentUser = getItInstance.get<User>();
    final UserInfo userInfo = currentUser.providerData.first;
    List<InviteEntity> invites = [];
    CollectionReference invitesRef = FirebaseFirestore.instance.collection('invites');
    invitesRef.where("participantsUid", arrayContainsAny: [userInfo.uid]).get().then(
          (QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach(
              (doc) {
                invites.add(InviteEntity.fromData(doc.data(), doc.id));
              },
            );
            return invites;
          },
        );
  }
}
