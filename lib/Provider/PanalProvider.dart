import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PanelProvider extends ChangeNotifier {
  bool panalstate=true;

 setPanalStatefalse(){
   panalstate = false;
   notifyListeners();
 }

  setPanalStatetrue(){
    panalstate = true;
    notifyListeners();
  }
  getPanalState(){
   return panalstate;
  }

}
