import 'package:firebase_database/firebase_database.dart';
import 'package:voice_library/Model/ItemModel.dart';



    Future<List<Item>> getItems() async {
    Query itemsSnapshot = FirebaseDatabase.instance
        .reference()
        .child("voice");
    List<Item> items=[];
    itemsSnapshot.once().then((DataSnapshot snapshot) async {
    Map<dynamic,dynamic> valuese =  snapshot.value;
    valuese.forEach((key, values) {
     if(values!= null){
       items.add(Item(name: values['name'].toString(),voiceUrl:values['voiceUrl'].toString() ,nShare:values['nShare'] ));
     }
    });
    });
    return  items;
  }
