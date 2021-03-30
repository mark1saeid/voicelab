import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_library/Model/ItemModel.dart';

import 'package:voice_library/Provider/TrendProvider.dart';
import 'package:voice_library/Service/ItemService.dart';
import 'package:voice_library/Widgets/ItemWidget.dart';

class Trend extends StatefulWidget {
  Trend({
    Key key,
  }) : super(key: key);

  @override
  _TrendState createState() => _TrendState();
}

class _TrendState extends State<Trend> {
  final trendProvider =
      ChangeNotifierProvider<TrendProvider>((ref) => TrendProvider());

  List<Item> trenditems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: ListView.builder(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: trenditems.length,
          itemBuilder: (ctx, index) {
            trenditems.sort((b, a) => a.nShare.compareTo(b.nShare));
            return ItemWidget(
              provider: trendProvider,
              id: index,
              item: trenditems[index],
            );
          },
        ),
      )),
    );
  }
}
