import 'package:firebase_database/firebase_database.dart';
class Item {
   String name;
   String voiceUrl;
   int nShare;

  Item({
    this.name,
    this.voiceUrl,
    this.nShare
  });

  Item.fromSnapshot(Map<dynamic,dynamic> snapshot) :
        name = snapshot["name"] as String,
        voiceUrl = snapshot["voiceUrl"] as String,
        nShare = snapshot["nShare"] as int;



  toJson() {
    return {
      "name": name,
      "voiceUrl": voiceUrl,
      "nShare" : nShare,
    };
  }
}