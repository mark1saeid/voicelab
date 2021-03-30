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

  Future uploadFile() async {
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
            padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
            child: Row(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width / 3.3,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'Voice Lab',
                          textStyle: colorizeTextStyle,
                          colors: colorizeColors,

                        ),
                      ],
                      isRepeatingAnimation: true,
                      onTap: () {
                        print("Tap Event");
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: Center(
                      child: Material(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius:  BorderRadius.circular(30.0)),
                        shadowColor: Colors.black,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.bottom,
                          textAlign: TextAlign.start,
                          cursorHeight: 20,
                          cursorColor: Colors.transparent,
                          autofocus: false,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              hintText: "Search",
                              fillColor: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
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
            minHeight: 60,
            margin: const EdgeInsets.only(left: 10, right: 10),
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
                      "Upload Your Voice Now",
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
                    RaisedButton(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      child: Text(
                        "Select",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
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
                        } else {
                          // User canceled the picker
                        }
                      },
                    ),
                    RaisedButton(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      child: Text(
                        "Upload",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        uploadFile();
                      },
                    ),
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
        floatingActionButton: Consumer(
          builder: (context, watch, child) => FloatingActionButton(
            onPressed: () {
              if (watch(panelstate).getPanalState() == true) {
                watch(panelstate).setPanalStatefalse();
                _pc.hide();
                print("${watch(panelstate).getPanalState()}");
              } else {
                watch(panelstate).setPanalStatetrue();
                _pc.show();
                print("${watch(panelstate).getPanalState()}");
              }
            },
            child: const Icon(Icons.music_note),
            backgroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
