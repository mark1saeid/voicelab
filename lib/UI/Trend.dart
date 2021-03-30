import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:voice_library/Model/itemModel.dart';

import 'package:voice_library/Provider/trendProvider.dart';
import 'package:voice_library/Service/itemService.dart';
import 'package:voice_library/Widgets/itemWidget.dart';

class Trend extends StatefulWidget {
  Trend({
    final Key key,
  }) : super(key: key);
  @override
  _TrendState createState() => _TrendState();
}

class _TrendState extends State<Trend> {

  final trendprovide =
  ChangeNotifierProvider<trendProvider>((ref) => trendProvider());


  List<Item> trenditems = [];
  @override
  void initState() {
    super.initState();
  //  _setupNeeds();
  }

  _setupNeeds() async {
    List<Item> items = await itemService.getItems();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      trenditems = items;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: ListView.builder(
          physics:  BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: trenditems.length,
          itemBuilder: (ctx,index){
            trenditems.sort((b, a) => a.nShare.compareTo(b.nShare));
            return ItemWidget(provider: trendprovide,id: index,item: trenditems[index],);
          },),
      )
      ),
    );
  }
}
