import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_2008/di/get_it.dart';
import 'package:d_2008/domain/entity/invite_entity.dart';
import 'package:d_2008/presentation/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../di/get_it.dart';

class ParticipantJoin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ParticipantJoin> {
  EventCard _eventCard;
  String _eventExplanation = "";
  String _withWho = "";
  InviteEntity entity = InviteEntity();
  List<MemberCard> memberList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = getItInstance<User>();
    String buttonText = "";
    bool isOwner = true;
    if (currentUser.providerData.first.uid != entity.ownerId) {
      isOwner = false;
    }
    String photoURL = currentUser.providerData.first.photoURL;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text("詳細"),
        actions: [
          Container(
            //userPicture
            width: 40.0,
            height: 40.0,
            margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(photoURL)
                  // image: NetworkImage("https://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png")
                  ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: _eventCard,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                    child: Icon(Icons.article_rounded),
                  ),
                  Flexible(
                    child: Container(
                      child: Text(
                        _eventExplanation,
                        softWrap: true,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: new Divider(color: Colors.black),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Icon(Icons.supervised_user_circle),
                  ),
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
              Container(
                child: Center(
                  child: JoinButton(context, entity).build(),
                ),
              ),
              SizedBox(height: 20),
              isOwner
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: memberList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return memberList[index];
                        },
                      ),
                    )
                  : Container(),
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
        _eventCard = EventCard(item.title, item.ownerPhotoURL, item.ownerName, "", item.status, "");
        _eventExplanation = item.detail;
        _withWho = item.target;
        memberList = item.participants.map((user) => MemberCard(user["displayName"], user["photoURL"])).toList();
      });
    }).catchError((onError) {
      Navigator.canPop(context);
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
    User currentUser = getItInstance<User>();
    String buttonText = "";
    bool isOwner = true;
    // 参加者
    if (currentUser.providerData.first.uid != entity.ownerId) {
      isOwner = false;
      buttonText = "Join";
    } else {
      isOwner = true;
      buttonText = "Close";
    }
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Text(buttonText),
      ),
      color: Color(0xffFFEB3B),
      textColor: Colors.black54,
      onPressed: () {
        try {
          if (entity != null) {
            if (!isOwner) {
              User currentUser = getItInstance.get<User>();
              if (!entity.participantsUid.contains(currentUser.providerData.first.uid)) {
                UserInfo info = currentUser.providerData.first;
                // 更新
                DocumentReference inviteRef = FirebaseFirestore.instance.doc("/invites/${entity.id}");
                List<String> userIds = entity.participantsUid.map((e) => e.toString()).toList();
                userIds.add(info.uid);
                List<Map<String, dynamic>> participants = [];

                entity.participants.forEach((element) {
                  participants.add(element);
                });
                participants.addAll({
                  {
                    "uid": info.uid,
                    "displayName": info.displayName,
                    "photoURL": info.photoURL,
                  }
                });

                // 取得, パスを取得, 削除, ポスト
                inviteRef.get().then((DocumentSnapshot snapshot) {
                  inviteRef.delete().then((_) {
                    DocumentReference dRef = FirebaseFirestore.instance.collection('invites').doc('${snapshot.id}');
                    dRef.set({
                      'ownerId': snapshot.data()["ownerId"].toString(),
                      'ownerName': snapshot.data()["ownerName"].toString(),
                      'ownerPhotoURL': snapshot.data()["ownerPhotoURL"].toString(),
                      'title': snapshot.data()["title"].toString(),
                      'detail': snapshot.data()["detail"].toString(),
                      'target': snapshot.data()["target"].toString(),
                      'participantsRef': snapshot.data()["participantsRef"].toString(),
                      'participantsUid': userIds,
                      'usersInfo': participants,
                      'expulsionUserUid': [],
                      'isOpen': true,
                      'isClosed': false,
                    }).then((_) => Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false));
                  });
                }).catchError((onError) {
                  debugPrint(onError.toString());
                });
              } else {
                Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
              }
            } else {
              DocumentReference inviteRef = FirebaseFirestore.instance.doc("/invites/${entity.id}");
              inviteRef.update({"isClosed": true, "isOpen": false});
              Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
            }
          } else {
            Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
          }
        } catch (error) {
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        }
      },
    );
  }
}

class MemberCard extends StatelessWidget {
  final String _username;
  final String _userPicture;

  MemberCard(this._username, this._userPicture);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(_userPicture))),
                ),
                SpaceBox.width(15),
                Text(_username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SpaceBox.width(5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
