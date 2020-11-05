import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_2008/di/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InviteScreen extends StatefulWidget {
  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final titleController = TextEditingController();
  final detailController = TextEditingController();
  final targetController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    detailController.dispose();
    targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REASOBI"),
      ),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 40),
                TextField(
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(hintText: 'タイトル'),
                  controller: titleController,
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 20,
                  maxLengthEnforced: true,
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(hintText: '詳細'),
                  controller: detailController,
                  maxLength: 60,
                  maxLengthEnforced: true,
                ),
                TextField(
                  decoration: InputDecoration(hintText: '対象'),
                  controller: targetController,
                  maxLength: 15,
                  maxLengthEnforced: true,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: true
          ? FloatingActionButton(
              onPressed: () {
                // TODO: loadingの実装
                final User currentUser = getItInstance.get<User>();
                final UserInfo userInfo = currentUser.providerData.first;
                CollectionReference invitesRef = FirebaseFirestore.instance.collection('invites');
                DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userInfo.uid);
                debugPrint(currentUser.providerData.toString());

                String title = "タイトル";
                String detail = "詳細";
                String target = "誰でも";

                invitesRef.add({
                  'ownerId': userInfo.uid,
                  'ownerName': userInfo.displayName,
                  'ownerPhotoURL': userInfo.photoURL,
                  'title': title,
                  'detail': detail,
                  'target': target,
                  'participantsRef': [userRef],
                  "participantsUid": [userInfo.uid],
                  'expulsionUserUid': [],
                  'isOpen': true,
                  'isClosed': false,
                }).then((value) {
                  print(value);
                }).catchError((error) => print("Failed to add user: $error"));
              },
              child: Icon(Icons.check),
              backgroundColor: Color.fromRGBO(0, 150, 136, 1.0),
            )
          : null,
    );
  }
}
