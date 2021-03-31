import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_library/Model/ItemModel.dart';

import 'package:voice_library/Provider/HomeProvider.dart';
import 'package:voice_library/Service/ItemService.dart';
import 'package:voice_library/Widgets/ItemWidget.dart';

class Home extends StatefulWidget {
//  List<Item> homeItems = [];
//  bool _isloading = true;
  final homeProvider =
      ChangeNotifierProvider<HomeProvider>((ref) => HomeProvider());

  int x = 0;
  int y = 0;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _setupNeeds();
  }

  @override
  Widget build(BuildContext context) {
    print("Home " + "${widget.x++}");
    // print(widget.homeItems.length.toString());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: RefreshIndicator(
            color: Colors.black,
            onRefresh: () => _setupNeeds(),
            child: Consumer(builder: (context, watch, child) {
              print("conc");
              return ListView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: watch(widget.homeProvider).item.length,
                  itemBuilder: (ctx, index) {
                    return ItemWidget(
                      provider: widget.homeProvider,
                      id: index,
                      item: watch(widget.homeProvider).item[index],
                    );
                  });
            })),
      ),
    );
  }

  Future<void> _setupNeeds() async {
    List<Item> test = await getItems();
    context.read(widget.homeProvider).setlist(test);
  }
}
/*
widget._isloading
? Padding(
padding: const EdgeInsets.all(100),
child: CircularProgressIndicator(),
)*/
