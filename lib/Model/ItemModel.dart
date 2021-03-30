import 'package:firebase_database/firebase_database.dart';
class Item {
  final String name;
  final String voiceUrl;
  final int nShare;

  Item({
    this.name,
    this.voiceUrl,
    this.nShare
  });

  Item.fromSnapshot(DataSnapshot snapshot) :
        name = snapshot.value["name"] as String,
        voiceUrl = snapshot.value["voiceUrl"] as String,
        nShare = snapshot.value["nShare"] as int;



  toJson() {
    return {
      "name": name,
      "voiceUrl": voiceUrl,
      "nShare" : nShare,
    };
  }
}