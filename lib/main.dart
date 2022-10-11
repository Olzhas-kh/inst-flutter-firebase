import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:inst_fire/providers/user_provider.dart';
import 'package:inst_fire/responsive/mobile_screen_layout.dart';
import 'package:inst_fire/responsive/responsive_layout_screen.dart';
import 'package:inst_fire/responsive/web_screen_layout.dart';
import 'package:inst_fire/screens/login_screen.dart';
import 'package:inst_fire/screens/profile_screen.dart';

import 'package:inst_fire/utils/colours.dart';
import 'package:provider/provider.dart';

import 'notify/local_push_notification.dart';

//Уведомления, проиложенияга али кирмеген кезде

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// On click listner
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cotton',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: primaryColor,
        ),
        routes: {
          '/message': (context) => ProfileScreen(),
        },

        //Stream Builder ОЛ ЮСЕРДИН ДАННЫЕ СОХРАНЯЕТ
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }

            return const LoginPage();
          },
        ),
      ),
    );
  }
}
