import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:voice_library/modules/home/home_page.dart';
import 'package:voice_library/provider/home_provider.dart';
import 'package:voice_library/provider/main_proivder.dart';
import 'package:voice_library/provider/panel_provider.dart';
import 'package:voice_library/provider/trend_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => TrendProvider()),
    ChangeNotifierProvider(create: (_) => MainProvider()),
    ChangeNotifierProvider(create: (_) => PanelProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice Library',
      theme: ThemeData.light(),
      home: MyHomePage(),
    );
  }
}
