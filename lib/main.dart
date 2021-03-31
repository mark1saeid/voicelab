import 'dart:io';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:voice_library/Provider/PanalProvider.dart';
import 'package:voice_library/UI/Favorite.dart';
import 'package:voice_library/UI/Home.dart';
import 'package:voice_library/UI/Trend.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice Library',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Voice'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _absolutePathOfAudio;
  final navigatorKey = GlobalKey<NavigatorState>();
  final databaseRef = FirebaseDatabase.instance.reference();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FilePickerResult result;
  PlatformFile file;
  static const colorizeColors = [
    Colors.black,
    Colors.yellow,
    Colors.red,
  ];

  static const colorizeTextStyle = TextStyle(
      fontSize: 25.0, fontFamily: 'Horizon', fontWeight: FontWeight.bold);

  PanelController _pc = new PanelController();
  final panelstate =
      ChangeNotifierProvider<PanelProvider>((ref) => PanelProvider());

  @override
  void initState() {
    super.initState();
    //  _pc.hide();
  }

  @override
  Widget build(BuildContext context) {
    var radius = BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    );
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 5, top: 20, right: 5),
            child: ListTile(
              title:  SizedBox(
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
                    isRepeatingAnimation: true,
                    onTap: () {
                      print("Tap Event");
                    },
                  )),
              trailing:
                  GestureDetector(child: Icon(Icons.arrow_circle_up_rounded,color: Colors.black,size: 26,)
                  ,onTap: (){

                    _selectVoice();

                    },),


            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
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
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BubbleTabIndicator(
                      indicatorHeight: 25.0,
                      indicatorColor: Colors.black,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Trend"),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Home"),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Favorite"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Consumer(
          builder: (context, watch, child) => SlidingUpPanel(
            maxHeight: MediaQuery.of(context).size.height/2,
            minHeight: 60,
            margin: const EdgeInsets.only(left: 0, right: 0),
            borderRadius: radius,
            controller: _pc,
            defaultPanelState: PanelState.CLOSED,
            collapsed: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: radius = BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  )),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.arrow_drop_up_rounded,
                      size: 25,
                    ),
                    Text(
                      "contol",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            panel: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    _absolutePathOfAudio == null
                        ? Container()
                        : Text(_absolutePathOfAudio),

                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                Trend(),
                Home(),
                Favorite(),
              ],
            ),
          ),
        ),

      ),
    );
  }
  _selectVoice() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['m4a', 'mp3', 'wav'],
    );
    if (result != null) {
      file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      _uploadVoice();
    } else {
      // User canceled the picker
    }
  }
   _uploadVoice() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("voice" + file.name);
    UploadTask uploadTask = ref.putFile(File(file.path));
    uploadTask.then((res) async {
      res.ref.getDownloadURL();
      databaseRef.child("voice").push().set({
        'name': file.name,
        'voiceUrl': await res.ref.getDownloadURL(),
        'nShare': 0
      });
    });
  }

}
