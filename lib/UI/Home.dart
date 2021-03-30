import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:voice_library/Model/itemModel.dart';

import 'package:voice_library/Provider/homeProvider.dart';
import 'package:voice_library/Service/itemService.dart';
import 'package:voice_library/Widgets/itemWidget.dart';





class Home extends StatelessWidget {
  final homeprovide =
      ChangeNotifierProvider<homeProvider>((ref) => homeProvider());
  List<Item> homeitem = [];

  itemService service = new itemService();

  Home({
     final Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: RefreshIndicator(
          color: Colors.black,
          onRefresh: () => _setupNeeds(),
          child: FutureBuilder<List<Item>>(
              future: itemService.getItems() ,
              builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading....');
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else
                  return ListView.builder(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: snapshot.data.length ?? 0,
                      itemBuilder: (ctx, index) {
                        return ItemWidget(provider: homeprovide,id: index,item: snapshot.data[index],);
                      //  snapshot.data[index], index, homeprovide
                      });
            }
          }),
        ),
      )),
    );
  }

  _setupNeeds() async {
    List<Item> test;
    test = await itemService.getItems();
   // setState(() {
    //  homeitem = test;
  //  });
  }
}
