import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_library/Model/ItemModel.dart';



class HomeProvider extends ChangeNotifier {
 bool isloading = true;
 List<Item> item = [];
 Map<int, bool> itemsState = new Map<int, bool>();




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


 setisloading(){
   isloading = false;
   notifyListeners();
 }
 setlist(List<Item> newList){
   item = newList;
   notifyListeners();
 }
}
