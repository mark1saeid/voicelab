import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_library/Model/ItemModel.dart';

import 'package:voice_library/Provider/TrendProvider.dart';
import 'package:voice_library/Service/ItemService.dart';
import 'package:voice_library/Widgets/ItemWidget.dart';

class Trend extends StatelessWidget {
  final trendProvider =
      ChangeNotifierProvider<TrendProvider>((ref) => TrendProvider());


  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      color: Colors.black,
      onRefresh: ()=>getItems(),
      child: FutureBuilder(
          future: getItems(),
          builder: (context, snap) {
            if (snap.hasData) {
              List<Item> items = snap.data as List<Item>;
              items.sort((b, a) => a.nShare.compareTo(b.nShare));
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: items.length,
                      itemBuilder: (ctx, index) {
                        return ItemWidget(
                          provider: trendProvider,
                          id: index,
                          item: items[index],
                        );
                      }),
                ),
              );
            } else if (snap.hasError) {
              return Center(
                  child: Text(
                    "${snap.error.toString()}",
                    style: TextStyle(color: Colors.black),
                  ));
            } else
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              );
          }),
    );
  }
}
//items.sort((b, a) => a.nShare.compareTo(b.nShare));