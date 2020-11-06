import 'package:flutter/material.dart';

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
        "title", "pic", "username", "user_id", 1); //1…募集中, 2…Joined !, 3…しめきり
    _eventExplanation = 'みんなでどこに行きますか〜、すごく楽しみにしているので早く行きたいです！';
    _withWho = "お友達";
    _participants.add(new ParticipantCard("kari", "Username", "this_is_id"));
  }

  Widget _closeButton = new RaisedButton(
    child: Container(
      padding: EdgeInsets.all(10),
      child: Text("Close"),
    ),
    color: Color(0xffFFEB3B),
    textColor: Colors.black54,

    // TODO: closeボタンを押したときの挙動
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
  final String _topPicture;
  final int _status;

  EventCard(this._title, this._topPicture, this._username, this._userId,
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

class ParticipantCard extends StatelessWidget {
  final String _pic;
  final String _username;
  final String _user_id;

  ParticipantCard(this._pic, this._username, this._user_id);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
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
