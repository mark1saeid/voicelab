import 'package:firebase_database/firebase_database.dart';
import 'package:voice_library/Model/ItemModel.dart';



 Future<List<Item>> getItems() async {
  final databaseReference = FirebaseDatabase.instance.reference().child("voice");
  List<Item> items = [];
  databaseReference.once().then((value) {
    Map data = value.value as Map;
    data.forEach((index, data) {
      Item item = Item(name: data['name'].toString(),
          voiceUrl: data['voiceUrl'].toString(),
          nShare: data["nShare"] as int);
      items.add(item);
    }
    );

  });

   return items;
}

