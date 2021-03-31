import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_library/Model/ItemModel.dart';
import 'package:voice_library/Provider/HomeProvider.dart';
import 'package:voice_library/Service/ItemService.dart';
import 'package:voice_library/Widgets/ItemWidget.dart';


class Home extends HookWidget {
  final homeProvider =
  ChangeNotifierProvider<HomeProvider>((ref) => HomeProvider());


  int x = 0;
  int y = 0;

  @override
  Widget build(BuildContext context) {
    final  future = useMemoized(() async {
      List<Item> item = await getItems();
     return item;
    });
    print("Home " + "${x++}");

    return FutureBuilder<List<Item>>(
      future: future,
      builder:(context, snapshot)
      {
        print("Future ${y++}");
             return snapshot.hasData
                  ? Scaffold(
                      body: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, index) {
                              return ItemWidget(
                                provider: homeProvider,
                                id: index,
                                item: snapshot.data[index],
                              );
                            }),
                      ),
                    )
                  : Container(
                      child: Center(child: CircularProgressIndicator()));
            });
  }


}

