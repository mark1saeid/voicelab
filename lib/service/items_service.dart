import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:voice_library/model/item_model.dart';
import 'package:http/http.dart' as http;

Future<List<Item>> getItems() async {
 // final databaseReference =
 //     FirebaseDatabase.instance.reference().child("voice");
 // final data = await databaseReference.once();

  final url = Uri.parse('https://audio1lab-default-rtdb.firebaseio.com/voice.json?');
  final response = await http.get(url);
  final data = jsonDecode(response.body);


  final res = data as Map<dynamic, dynamic>;
  final resData = <Item>[];
  res.forEach((key, value) => resData.add(Item.fromMap(value, key.toString())));
  return resData;
}

void updateItems(String key) {
  final databaseReference =
  FirebaseDatabase.instance.reference().child("voice").child(key);
 final data = databaseReference.once();
  data.then((value){
   final Map<String, dynamic> updatedValue = <String,Object>{};
   updatedValue['nShare'] = value.value['nShare']+1;
   databaseReference.update(updatedValue);
   print(value.value['nShare'].toString());

  });

  
  
}
