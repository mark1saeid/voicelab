import 'package:flutter/material.dart';

class PanelProvider extends ChangeNotifier {
  String audioName = "audio name";
  double postion = 0.0;
  void setName(String name){
    audioName = name.split('.').first;
    notifyListeners();
  }
  void setPosition(double num){
    postion = num;
    notifyListeners();
  }
}
