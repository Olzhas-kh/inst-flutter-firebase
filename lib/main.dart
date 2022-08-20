import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inst_fire/responsive/mobile_screen_layout.dart';
import 'package:inst_fire/responsive/responsive_layout_screen.dart';
import 'package:inst_fire/responsive/web_screen_layout.dart';
import 'package:inst_fire/screens/login_screen.dart';
import 'package:inst_fire/utils/colours.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDc041lGSp03NrUgDY64HUGaQi17RJSgK0",
        appId: "1:231361399111:web:1e151a2d2d44e8fa3be462",
        messagingSenderId: "231361399111",
        projectId: "instagram-clone-bd4c8",
        storageBucket: "instagram-clone-bd4c8.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      // home: const ResponsiveLayout(
      //     webScreenLayout: WebScreenLayout(),
      //     mobileScreenLayout: MobileScreenLayout()),
      home: LoginScreen(),
    );
  }
}
