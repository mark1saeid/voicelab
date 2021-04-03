import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:voice_library/model/item_model.dart';
import 'package:voice_library/provider/panel_provider.dart';




class ItemWidget extends StatelessWidget {
  final Item item;
  final int id;
  final itemProvider;

  const ItemWidget(
      {@required this.item, @required this.id, @required this.itemProvider});

  /*_downloadAudio(url,key) async {
    final cache =  DefaultCacheManager();
    final file  = await cache.getSingleFile(url.toString(),key: key.toString());
    cache.putFile(url.toString(), file.readAsBytesSync());
    print(file.path.toString());
  }*/

  @override
  Widget build(BuildContext context) {
    final panelProvider = Provider.of<PanelProvider>(context);

    final marquee = Marquee(
        text: item.name,
        velocity: 30,
        blankSpace: 30,
        style: const TextStyle(fontWeight: FontWeight.bold));
    final bool isPlaying = itemProvider.audioplayerState[id] as bool ?? false;
    final precent = itemProvider.percentage[item.key] as double ?? 0;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: GestureDetector(
            onTap: (){itemProvider.audioLogic(item, id);
            panelProvider.setName(item.name.toString());
            panelProvider.setPosition(0.5);
            },
            child: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                size: 50)),
        title: Wrap(children: [
          SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: marquee)
        ]),
        subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 15, top: 4),
            child: Builder(builder: (context) {
              return LinearProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                  backgroundColor: Colors.black12,
                  value: precent);
            })),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  itemProvider.shareButton(item.key);
                },
                child: const Icon(Icons.share),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(Icons.favorite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
