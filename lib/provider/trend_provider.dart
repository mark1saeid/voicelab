import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_library/model/item_model.dart';

class TrendProvider extends ChangeNotifier {
  Map<int,double> percentage = <int, double>{};
  AudioPlayer audioPlayer;
  Map<int, bool> audioplayerState = <int, bool>{};



  @override
  Future<void> dispose() async {
    await audioPlayer.dispose();
    audioplayerState.forEach((key, value) {
      audioplayerState[key] =false;
    });
    super.dispose();
  }

  void setUpListners(int index) {
    if(audioPlayer != null) {
      if (audioPlayer.state ==
          AudioPlayerState.PLAYING) {
        audioPlayer.onAudioPositionChanged
            .listen((Duration currant) {
          audioPlayer.onDurationChanged
              .listen((Duration max) {
          final double precentage = currant.inSeconds / max.inSeconds;
            percentage[index] = precentage;
          });
        });
      }}
    notifyListeners();
  }

  Future<void> audioLogic(Item item, int index) async {
    try {
      audioPlayer ??= AudioPlayer();

      if (audioPlayer.state == AudioPlayerState.PLAYING) {

        audioplayerState.forEach((key, value) {
          audioplayerState[key] =false;
        });
        audioplayerState[index] = false;
        await audioPlayer.stop();
      } else {
        audioplayerState.forEach((key, value) {
          audioplayerState[key] =false;
        });
        setUpListners(index);
        audioplayerState[index] = true;
        await audioPlayer.play(item.voiceUrl);
      }
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  bool isloading = true;
  List<Item> item = [];
  Map<int, bool> itemsState = <int, bool>{};

  bool getitemstate(int id) {
    return itemsState[id];
  }

  void setisloading() {
    isloading = false;
    notifyListeners();
  }

  void setlist(List<Item> newList) {
    item = newList;
    notifyListeners();
  }
}
