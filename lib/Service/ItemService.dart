import 'package:firebase_database/firebase_database.dart';
import 'package:voice_library/Model/ItemModel.dart';



 Future<List<Item>> getItems() async {
   List<Item> items =[];
  Query itemsSnapshot = FirebaseDatabase.instance
      .reference()
      .child("voice");

  itemsSnapshot.once().then((DataSnapshot snapshot) async {
    Map<dynamic, dynamic> snapshotValue = snapshot.value as Map<dynamic, dynamic>;
    snapshotValue.forEach((key, value) {
      if (value != null) {
        Item item = Item(name: value['name'].toString(),
            voiceUrl: value['voiceUrl'].toString(),
            nShare: value["nShare"] as int);

        items.add(item);

      }
    });
  });
  return items;
}
