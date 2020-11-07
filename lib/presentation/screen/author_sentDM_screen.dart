import 'package:d_2008/presentation/screen/author_invite_close_screen.dart'; //ParticipantCardのため
import 'package:d_2008/presentation/screen/home_screen.dart'; //EventCardのため
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:d_2008/presentation/screen/author_invite_close_screen.dart';

import '../../di/get_it.dart'; //ParticipantCardのため

class SendDMScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SendDMScreen> {
  EventCard _eventCard;
  String _eventExplanation;
  String _withWho;
  List<ParticipantCard> _participants = new List<ParticipantCard>();

  @override
  void initState() {
    // TODO: 変数への代入
    _eventCard = new EventCard("title", "pic", "username", "user_id", "", ""); //1…募集中, 2…Joined !, 3…しめきり
    _eventExplanation = 'みんなでどこに行きますか〜、すごく楽しみにしているので早く行きたいです！';
    _withWho = "お友達";
    _participants.add(new ParticipantCard("kari", "Username", "this_is_id"));
  }

  Widget _sendDM = new RaisedButton(
    child: Container(
      padding: EdgeInsets.all(10),
      child: Text("DMを送信する"),
    ),
    color: Color(0xff51B5C1),
    textColor: Colors.black54,

    //TODO: DM送信のボタンを押した時の動作を記述
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
        title: Text("投稿詳細"),
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
              TextField(
                decoration: InputDecoration(hintText: 'DMの文をここに書く'),
                // controller: ,
                maxLength: 60,
                maxLengthEnforced: true,
              ),
              Center(
                child: _sendDM,
              )
            ],
          ),
        ),
      ),
    );
  }
}
