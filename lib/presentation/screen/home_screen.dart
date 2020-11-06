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
  var _cardList = List<EventCard>();

  @override
  void initState() {
    _cardList.add(EventCard("ドンキ行きたい1",
        "assets/images/Jaappao_2020_Square3.png", "Jaappao", "_Jaappao_", 1));

    _cardList.add(EventCard("ドンキ行きたい2",
        "assets/images/Jaappao_2020_Square3.png", "Jaappao", "_Jaappao_", 2));

    _cardList.add(EventCard("ドンキ行きたい3",
        "assets/images/Jaappao_2020_Square3.png", "Jaappao", "_Jaappao_", 3));
  }

  @override
  Widget build(BuildContext context) {
    fetchInvites();
    return Scaffold(
      appBar: AppBar(
        title: Text("REASOBI"),
        leading: Container(),
        leadingWidth: 0.0,
      ),
      body: SafeArea(
        child: WillPopScope(
          child: Container(
            child: SingleChildScrollView(
              // TODO: Change List View
              child: Container(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: _cardList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _cardList[index];
                  },
                ),
              ),
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
    CollectionReference invitesRef =
        FirebaseFirestore.instance.collection('invites');
    invitesRef
        .where("participantsUid", arrayContainsAny: [userInfo.uid])
        .get()
        .then(
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

class SpaceBox extends SizedBox {
  SpaceBox({double width = 8, double height = 8})
      : super(width: width, height: height);

  SpaceBox.width([double value = 8]) : super(width: value);
  SpaceBox.height([double value = 8]) : super(height: value);
}

class EventCard extends StatelessWidget {
  final String _title;
  final String _username;
  final String _userId;
  final String _userPicture;
  final int _status;

  EventCard(this._title, this._userPicture, this._username, this._userId,
      this._status);

  List<Widget> statusIcon() {
    if (this._status == 1) {
      return <Widget>[Icon(Icons.check_circle), SpaceBox.width(5), Text("募集中")];
    } else if (this._status == 2) {
      return <Widget>[
        Icon(Icons.thumb_up),
        SpaceBox.width(5),
        Text("Joined !")
      ];
    } else if (this._status == 3) {
      return <Widget>[Icon(Icons.block), SpaceBox.width(3), Text("しめきり")];
    } else {
      return <Widget>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    _title,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  //userPicture
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          // image: NetworkImage(_pic)
                          image: NetworkImage(
                              "https://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png"))),
                ),
                SpaceBox.width(5),
                Text(_username, style: TextStyle(fontWeight: FontWeight.bold)),
                SpaceBox.width(5),
                Text('@' + _userId),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: this.statusIcon(),
            ),
          ],
        ),
      ),
    );
  }
}
