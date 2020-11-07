import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_2008/di/get_it.dart';
import 'package:d_2008/domain/entity/invite_entity.dart';
import 'package:d_2008/presentation/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class ParticipantJoin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ParticipantJoin> {
  EventCard _eventCard;
  String _eventExplanation = "";
  String _withWho = "";
  InviteEntity entity;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text("詳細"),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                child: _eventCard,
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  _eventExplanation,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _withWho,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SpaceBox.height(30),
              Center(
                child: JoinButton(context, entity).build(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    String path = "";
    String inviteId = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    inviteId = prefs.get(inviteKey);
    if (inviteId == null || inviteId.isNotEmpty) {
      path = inviteId;
    } else {
      Navigator.pop(context);
    }
    DocumentReference inviteRef = FirebaseFirestore.instance.doc("/invites/$path");
    inviteRef.get().then((DocumentSnapshot snapShot) {
      InviteEntity item = InviteEntity.fromData(snapShot.data(), snapShot.id);
      entity = item;
      setState(() {
        _eventCard = EventCard(item.title, item.ownerPhotoURL, item.ownerName, "", item.status);
        _eventExplanation = item.detail;
        _withWho = item.target;
      });
    }).catchError((onError) {
      Navigator.pop(context);
    });
  }
}

class SpaceBox extends SizedBox {
  SpaceBox({double width = 8, double height = 8}) : super(width: width, height: height);

  SpaceBox.width([double value = 8]) : super(width: value);
  SpaceBox.height([double value = 8]) : super(height: value);
}

class JoinButton {
  final BuildContext context;
  final InviteEntity entity;
  JoinButton(this.context, this.entity);

  Widget build() {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Text("Join"),
      ),
      color: Color(0xffFFEB3B),
      textColor: Colors.black54,
      onPressed: () {
        if (entity != null) {
          User currentUser = getItInstance.get<User>();
          if (!entity.participantsUid.contains(currentUser.providerData.first.uid)) {
            debugPrint("test");
          } else {
            Navigator.pop(context);
          }
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}
