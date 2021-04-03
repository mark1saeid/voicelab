import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  bool uploadingState = false;

  void setPanalStatefalse() {
    uploadingState = false;
    notifyListeners();
  }

  void setPanalStatetrue() {
    uploadingState = true;
    notifyListeners();
  }
}
