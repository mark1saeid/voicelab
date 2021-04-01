import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  bool uploadingState=false;

  setPanalStatefalse(){
    uploadingState = false;
    notifyListeners();
  }

  setPanalStatetrue(){
    uploadingState = true;
    notifyListeners();
  }


}