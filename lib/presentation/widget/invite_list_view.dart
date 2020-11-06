import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_2008/di/get_it.dart';
import 'package:d_2008/domain/entity/invite_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InviteListView extends StatefulWidget {
  @override
  _InviteListViewState createState() => _InviteListViewState();
}

class _InviteListViewState extends State<InviteListView> {
  List<InviteEntity> inviteList = [];

  @override
  void initState() {
    super.initState();
    fetchInviteList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: inviteList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${inviteList[index]}'),
        );
      },
    );
  }

  Future<void> fetchInviteList() async {
    final User currentUser = getItInstance.get<User>();
    final UserInfo userInfo = currentUser.providerData.first;
    List<InviteEntity> invites = [];
    CollectionReference invitesRef = FirebaseFirestore.instance.collection('invites');
    invitesRef.where("participantsUid", arrayContainsAny: [userInfo.uid]).get().then(
          (QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach(
              (doc) {
                debugPrint(doc.data().toString());
                invites.add(InviteEntity.fromData(doc.data(), doc.id));
              },
            );
            setState(
              () {
                inviteList = invites;
              },
            );
          },
        );
  }
}
