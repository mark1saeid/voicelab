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
        name = snapshot.value["name"],
        voiceUrl = snapshot.value["voiceUrl"],
        nShare = snapshot.value["nShare"];



  toJson() {
    return {
      "name": name,
      "voiceUrl": voiceUrl,
      "nShare" : nShare,
    };
  }
}