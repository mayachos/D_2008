import 'package:d_2008/presentation/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../di/get_it.dart';

class AuthorInviteClose extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AuthorInviteClose> {
  EventCard _eventCard;
  String _eventExplanation;
  String _withWho;
  List<ParticipantCard> _participants = new List<ParticipantCard>();

  @override
  void initState() {
    // TODO: 変数への代入
    _eventCard = new EventCard(
        "title", "pic", "username", "user_id", "1"); //1…募集中, 2…Joined !, 3…しめきり
    _eventExplanation = 'みんなでどこに行きますか〜、すごく楽しみにしているので早く行きたいです！';
    _withWho = "お友達";
    _participants.add(new ParticipantCard("kari", "Username", "this_is_id"));
  }

  Widget _closeButton = new RaisedButton(
    child: Container(
      padding: EdgeInsets.all(10),
      child: Text("Close"),
    ),
    color: Color(0xff51B5C1),
    textColor: Colors.black54,

    // TODO: closeボタンを押したときの挙動
    onPressed: () {},
  );

  @override
  Widget build(BuildContext context) {
    User currentUser = getItInstance.get<User>();
    String photoURL = currentUser.providerData.first.photoURL;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.keyboard_arrow_left),
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
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(photoURL)
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
              Expanded(
                child: ListView.builder(
                  itemCount: _participants.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _participants[index];
                  },
                ),
              ),
              SpaceBox.height(30),
              Center(
                child: _closeButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParticipantCard extends StatelessWidget {
  final String _pic;
  final String _username;
  final String _user_id;

  ParticipantCard(this._pic, this._username, this._user_id);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Row(
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
              Text('@' + _user_id),
            ],
          ),
        ),
      ),
    );
  }
}
