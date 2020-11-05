import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_2008/di/get_it.dart';
import 'package:d_2008/presentation/screen/invite_screen.dart';
import 'package:d_2008/presentation/transition/fade_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    fetchInvites();
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

  Future<void> fetchInvites() async {
    final User currentUser = getItInstance.get<User>();
    final UserInfo userInfo = currentUser.providerData.first;
    CollectionReference invitesRef = FirebaseFirestore.instance.collection('invites');
    // Note: 参加している募集を取得
    invitesRef.where("participantsUid", arrayContainsAny: [userInfo.uid]).get().then(
          (QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach(
              (doc) {
                // Note: 参加者一覧を取得するサンプル実装
                List<dynamic> participants = doc.data()["participantsRef"];
                participants.forEach(
                  (participant) {
                    debugPrint(participant.toString());
                    participant.get().then(
                      (userQuerySnapshot) {
                        debugPrint(userQuerySnapshot.data().toString());
                      },
                    );
                  },
                );
              },
            );
          },
        );
  }
}
