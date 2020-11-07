import 'package:d_2008/presentation/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../di/get_it.dart';

class ParticipantJoin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ParticipantJoin> {
  EventCard _eventCard;
  String _eventExplanation;
  String _withWho;

  @override
  void initState() {
    // TODO: 変数への代入
    _eventCard = new EventCard("title", "pic", "username", "user_id", "1");
    _eventExplanation = "みんなでどこにいきますか〜、すごく楽しみにしているので早くいきたいです！";
    _withWho = "お友達";
  }

  Widget _joinButton = new RaisedButton(
    child: Container(
      padding: EdgeInsets.all(10),
      child: Text("Join"),
    ),
    color: Color(0xffFFEB3B),
    textColor: Colors.black54,

    // TODO: joinButtonの動作
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
              Center(
                child: _joinButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpaceBox extends SizedBox {
  SpaceBox({double width = 8, double height = 8})
      : super(width: width, height: height);

  SpaceBox.width([double value = 8]) : super(width: value);
  SpaceBox.height([double value = 8]) : super(height: value);
}
