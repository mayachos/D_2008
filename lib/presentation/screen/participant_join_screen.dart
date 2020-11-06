import 'package:d_2008/presentation/screen/home_screen.dart';
import 'package:flutter/material.dart';

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
    super.initState();
    // TODO: 変数への代入
    _eventCard = new EventCard("title", "pic", "username", "user_id", "");
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
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.keyboard_arrow_left),
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
  SpaceBox({double width = 8, double height = 8}) : super(width: width, height: height);

  SpaceBox.width([double value = 8]) : super(width: value);
  SpaceBox.height([double value = 8]) : super(height: value);
}
