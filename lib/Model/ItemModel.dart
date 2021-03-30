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
        name = snapshot.value["name"].toString(),
        voiceUrl = snapshot.value["voiceUrl"].toString(),
        nShare = int.parse(snapshot.value["nShare"].toString());



  toJson() {
    return {
      "name": name,
      "voiceUrl": voiceUrl,
      "nShare" : nShare,
    };
  }
}