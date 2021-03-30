import 'package:firebase_database/firebase_database.dart';
import 'package:voice_library/Model/itemModel.dart';


class itemService {
 // watch(homeprovide).getlist()==null?Center(child: CircularProgressIndicator())
   static Future<List<Item>> getItems() async {
    Query itemsSnapshot = FirebaseDatabase.instance
        .reference()
        .child("voice");
    List<Item> items=[];
    itemsSnapshot.once().then((DataSnapshot snapshot){
    Map<dynamic,dynamic> valuese = snapshot.value;
    valuese.forEach((key, values) {
     if(values!= null){
       Item item = new Item();
       item.name =values['name'].toString();
       item.voiceUrl =values['voiceUrl'].toString();
       item.nShare=values['nShare'];
       items.add(item);

     }
    });
    });
    return items;
  }
}