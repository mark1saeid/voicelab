import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:voice_library/model/item_model.dart';
import 'package:voice_library/service/items_service.dart';

class HomeProvider extends ChangeNotifier {

  Map<String, double> percentage = <String, double>{};
  AudioPlayer audioPlayer;
  int _max =1;
  int _currant =0;

  int get max => _max;
  Map<int, bool> audioplayerState = <int, bool>{};




  void shareButton(String key) {
    updateItems(key);
  }

  @override
  Future<void> dispose() async {
    await audioPlayer.dispose();
    audioplayerState.forEach((key, value) {
      audioplayerState[key] = false;
    });
    super.dispose();
  }

  void setUpListners(Item item) {
    if(audioPlayer.playerId == item.key)  {
        if (audioPlayer.state == AudioPlayerState.PLAYING) {
          audioPlayer.onAudioPositionChanged.listen((Duration currant) {
            _currant = currant.inSeconds;
          });
          audioPlayer.onDurationChanged.listen((Duration max) {
            _max = max.inSeconds;
          });
          percentage[item.key] = currant/max;
        }
      }

    notifyListeners();
  }

  Future<void> audioLogic(Item item, int index) async {
    try {
      audioPlayer ??= AudioPlayer(playerId: item.key);

      if (audioPlayer.state == AudioPlayerState.PLAYING) {
        audioplayerState.forEach((key, value) {
          audioplayerState[key] = false;
        });
        audioplayerState[index] = false;
        await audioPlayer.stop();
      } else {
        audioplayerState.forEach((key, value) {
          audioplayerState[key] = false;
        });
        audioplayerState[index] = true;
        await audioPlayer.play(item.voiceUrl);
   //   Timer.periodic( const Duration(seconds: 1), (Timer t) => setUpListners(item));

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

  int get currant => _currant;
}
