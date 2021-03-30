
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:voice_library/Model/itemModel.dart';



class ItemWidget extends StatefulWidget {
  @override
  _ItemWidgetState createState() => _ItemWidgetState(item, id, provider);


  ItemWidget({Key key,this.item,this.id,this.provider}) : super(key: key);
  Item item;
  int id;
  var provider;

  int finalduration;

  int curantduration;



}



class _ItemWidgetState extends State<ItemWidget> {
  Item _item;
  int _id;
  var _provider;

  int finalduration;

  int curantduration;

  _ItemWidgetState(Item item, int id, provider) {
    this._item = item;
    this._id = id;
    _provider = provider;
  }

  @override
  Widget build(BuildContext context) {
    AudioPlayer audioPlayer = AudioPlayer(playerId: _id.toString()+_item.name);
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: GestureDetector(
          child: Consumer(
              builder: (context, watch, child) => Icon(
                    watch(_provider).getitemstate(_id) ?? false == true
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    size: 50,
                  )),
          onTap: () async {
            if (context.read(_provider).getitemstate(_id) == true) {
              await audioPlayer.stop();
            } else {
              await audioPlayer.play(_item.voiceUrl.toString());
            }
            context.read(_provider).setitemstate(_id);
          },
        ),
        title: Wrap(
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Marquee(
                text: _item.name,
                velocity: 30,
                blankSpace: 30,
                style: TextStyle(fontWeight: FontWeight.bold),
                scrollAxis: Axis.horizontal,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(bottom: 15, top: 4),
          child: StreamBuilder<Duration>(
              stream: audioPlayer.onDurationChanged,
              builder: (context, snapshot1) => StreamBuilder<Duration>(
                    stream: audioPlayer.onAudioPositionChanged,
                    builder: (context, snapshot2) {
                      if (snapshot1.data == null || snapshot2.data == null) {
                        finalduration = 1;
                        curantduration = 0;
                      } else {
                        finalduration = snapshot1.data.inSeconds;
                        curantduration = snapshot2.data.inSeconds;
                      }

                      return LinearProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                          backgroundColor: Colors.white,
                          value: (curantduration / finalduration));
                    },
                  )),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.share),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(Icons.favorite),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    AudioPlayer audioPlayer = AudioPlayer(playerId: _id.toString()+_item.name);
    audioPlayer.dispose();
    final provider = context.read(_provider);

    provider.set;
    super.dispose();
  }
}
