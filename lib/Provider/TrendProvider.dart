import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_library/Model/ItemModel.dart';


class TrendProvider extends ChangeNotifier {
  bool isloading = true;
  Map<int, bool> itemsState = new Map<int, bool>();
  List<Item> items = [];


  setitemstate(int id) {
    if (itemsState[id] == true) {
      itemsState[id] = false;
    } else {
      itemsState[id] = true;
    }
    notifyListeners();
  }


  getitemstate(int id) {
    return itemsState[id];
  }

  setlist(List<Item> item){
    items = item;
    notifyListeners();
  }
  getlist(){
    return items;
  }


  setisloading(){
    isloading = false;
    notifyListeners();
  }
  getisloading(){
    return isloading;
  }
}