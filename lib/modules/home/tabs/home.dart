import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:voice_library/model/item_model.dart';
import 'package:voice_library/provider/home_provider.dart';
import 'package:voice_library/service/items_service.dart';
import 'package:voice_library/widgets/item_widget.dart';
import 'package:voice_library/widgets/loading.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () => getItems(),
      child: FutureBuilder(
        future: getItems(),
        builder: (context, snap) {
          if (snap.hasData) {
            final List<Item> items = snap.data as List<Item>;
            return Scaffold(
              body: Padding(
                padding:  EdgeInsets.only(left: 10, right: 10, top: 10,bottom: MediaQuery.of(context).size.height/4),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemCount: items.length,
                    itemBuilder: (ctx, index) {
                      return ItemWidget(
                        id: index,
                        item: items[index],
                        itemProvider: homeProvider,
                      );
                    }),
              ),
            );
          } else if (snap.hasError) {
            return Center(child: Text(snap.error.toString(), style: const TextStyle(color: Colors.black)));
          } else {
            return LoadingCircle();
          }
        },
      ),
    );
  }
}
