import 'dart:convert';
import 'dart:typed_data';
import 'package:voice_library/config/styles.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toast/toast.dart';
import 'package:voice_library/modules/home/tabs/favorite.dart';
import 'package:voice_library/modules/home/tabs/home.dart';
import 'package:voice_library/modules/home/tabs/trend.dart';
import 'package:voice_library/config/colors.dart';
import 'package:voice_library/provider/main_proivder.dart';
import 'package:voice_library/provider/panel_provider.dart';
import 'package:voice_library/widgets/loading.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController tabContoller;
  final databaseRef = FirebaseDatabase.instance.reference();


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FilePickerResult result;
  Uint8List  file;

  final _pc = PanelController();

  @override
  void initState() {
    super.initState();
    tabContoller = TabController(vsync: this, length: 3, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    final panelProvider = Provider.of<PanelProvider>(context);
    const radius = BorderRadius.only(
        topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0));
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 5, top: 20, right: 5),
          child: ListTile(
            title: SizedBox(
                width: MediaQuery.of(context).size.width / 3.3,
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'voicelab',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ],
                  onTap: () => print("Tap Event"),
                )),
            trailing: GestureDetector(
              onTap: _selectVoice,
              child: Builder(
                builder: (context) {
                  final provider = Provider.of<MainProvider>(context);
                  final isLoading = provider.uploadingState;
                  return isLoading
                      ? SizedBox(
                          width: 21,
                          height: 21,
                          child: LoadingCircle(),
                        )
                      : const Icon(Icons.arrow_circle_up_rounded,
                          color: Colors.black, size: 28);
                },
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Column(
            children: [
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width / 1.2,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: const BubbleTabIndicator(
                    indicatorRadius: 15,
                    indicatorHeight: 25.0,
                    indicatorColor: Colors.black,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  ),
                  controller: tabContoller,
                  tabs: const [
                    Tab(child: Align(child: Text("Trend"))),
                    Tab(child: Align(child: Text("Home"))),
                    Tab(child: Align(child: Text("Favorite"))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          final size = MediaQuery.of(context).size;
          return SlidingUpPanel(
            boxShadow: const <BoxShadow>[
              BoxShadow(blurRadius: 4.0, color: Color.fromRGBO(0, 0, 0, 0.25))
            ],
            panel: SizedBox(
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children:  [
                  const Icon(Icons.multitrack_audio_rounded,size: 100,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Builder(builder:(ctx)=>  Text(panelProvider.audioName.toString() ,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,)),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40),
                    child:  Builder(builder:(ctx)=> Slider(activeColor: Colors.black, value: panelProvider.postion,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.favorite_rounded,size: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.skip_previous_rounded,size: 50,),
                            Icon(Icons.play_arrow,size: 50,),
                            Icon(Icons.skip_next_rounded,size: 50,)
                          ],
                        ),
                        GestureDetector(onTap: () {
                       getData();
                        },child:const Icon(Icons.share_rounded,size: 30))
                      ]
                    ),
                  ),
                ],
              ),
            ),
            maxHeight: size.height / 2,
            minHeight: size.height / 12,
            margin: const EdgeInsets.only(left: 10, right: 10),
            borderRadius: radius,
            controller: _pc,
            collapsed: Container(
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0))),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Column(
                    children: const [
                      Icon(Icons.arrow_drop_up_outlined, size: 25),
                    ],
                  ),
                ),
              ),
            ),
            body: TabBarView(
              controller: tabContoller,
              children: [
                Trend(),
                Home(),
                Favorite(),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectVoice() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowedExtensions: ['m4a', 'mp3', 'wav'],
    );
    if (result != null) {
      file = result.files.single.bytes;
   final  PlatformFile files = result.files.single;

    //  print(file.name);
    //  print(file.path);
      _uploadVoice(files.name);
    } else {
      // User canceled the picker
    }
  }

  Future<void> _uploadVoice(String name) async {
    Toast.show(
      "uploading",
      context,
      duration: Toast.LENGTH_SHORT,
      gravity: Toast.BOTTOM,
      backgroundColor: Colors.black,
    );

    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    mainProvider.setPanalStatetrue();
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child("voice$name");
    final uploadTask = ref.putData(file);
    final res = await uploadTask;
    res.ref.getDownloadURL();


    final url = Uri.parse('https://audio1lab-default-rtdb.firebaseio.com/voice.json');
    await http.post(url,body: json.encode({
      'name': name,
      'voiceUrl': await res.ref.getDownloadURL(),
      'nShare': 0
    }));




  /* databaseRef.child("voice").push().set({
      'name': file.name,
      'voiceUrl': await res.ref.getDownloadURL(),
      'nShare': 0
    });*/
    uploadTask.whenComplete(() {
      Toast.show(
        "uploaded",
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black,
      );
      mainProvider.setPanalStatefalse();
    });
    uploadTask.catchError(() {
      mainProvider.setPanalStatefalse();
      Toast.show(
        "Erorr",
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.black,
      );
    });
  }
  Future getData() async {
    try {
      final url = Uri.parse('https://audio1lab-default-rtdb.firebaseio.com/voice.json?');
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      print(data);
      return data;
    } catch (e) {
      print(e);
      return null;
    }
  }

}
