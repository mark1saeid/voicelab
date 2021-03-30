import 'package:flutter/material.dart';
import 'package:voice_library/Widgets/itemWidget.dart';
class Favorite extends StatefulWidget {
  Favorite({
    final Key key,
  }) : super(key: key);
  @override
  _FavoriteState createState() => _FavoriteState();
}


class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: ListView(
          children: <Widget>[
          ],
        ),
      ),),
    );
  }
}
