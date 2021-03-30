import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class HomeProvider extends ChangeNotifier {
 bool isloading = true;
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
getisloading(){
   return isloading;
}
}
