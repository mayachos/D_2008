import 'package:d_2008/firebase/dynamic_link/dynamic_link_service.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class HomeScreen extends StatelessWidget {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 50,
          width: 100,
          child: FutureBuilder<Uri>(
            future: _dynamicLinkService.createDynamicLink(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Uri uri = snapshot.data;
                return FlatButton(
                  color: Colors.amber,
                  onPressed: () => Share.share(uri.toString()),
                  child: Text('Share'),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
