


import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:voice_library/Model/ItemModel.dart';



class ItemWidget extends StatefulWidget {
 final Item item;
 final int id;
 final ProviderBase<Object, dynamic> provider;
  int finalduration;
  int curantduration;

  @override
  _ItemWidgetState createState() => _ItemWidgetState();


  ItemWidget({Key key,this.item,this.id,this.provider}) : super(key: key);

}



class _ItemWidgetState extends State<ItemWidget> {


  _downloadAudio(url,key) async {
    final cache =  DefaultCacheManager();
    final file  = await cache.getSingleFile(url.toString(),key: key.toString());
    cache.putFile(url.toString(), file.readAsBytesSync());
    print(file.path.toString());
  }




  @override
  Widget build(BuildContext context) {
    AudioPlayer audioPlayer = AudioPlayer(playerId: widget.id.toString()+ widget.item.name,);
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: GestureDetector(
          child: Consumer(
              builder: (context, watch, child) {
              bool buttonState =  watch(widget.provider).getitemstate(widget.id) as bool;
             return Icon(
              buttonState ?? false == true
              ? Icons.pause_circle_filled
                  : Icons.play_circle_fill,
              size: 50,
              );
              }),
          onTap: () async {
            if (context.read(widget.provider).getitemstate(widget.id) == true) {
              await audioPlayer.stop();
            } else {
              await audioPlayer.play(widget.item.voiceUrl.toString());
            }
            context.read(widget.provider).setitemstate(widget.id);
          },
        ),
        title: Wrap(
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Marquee(
                text: widget.item.name,
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
                        widget.finalduration = 1;
                        widget.curantduration = 0;
                      } else {
                        widget.finalduration = snapshot1.data.inSeconds;
                        widget.curantduration = snapshot2.data.inSeconds;
                      }

                      return LinearProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                          backgroundColor: Colors.white,
                          value: (widget.curantduration / widget.finalduration));
                    },
                  )),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(child: Icon(Icons.share),onTap: (){

              },),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: GestureDetector(child: Icon(Icons.favorite),onTap: ()  {




              },),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    AudioPlayer audioPlayer = AudioPlayer(playerId: widget.id.toString()+ widget.item.name);
    audioPlayer.dispose();

    super.dispose();
  }
}
