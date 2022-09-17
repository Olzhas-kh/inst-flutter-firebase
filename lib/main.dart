import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inst_fire/notify/notify_main.dart';
import 'package:inst_fire/providers/user_provider.dart';
import 'package:inst_fire/responsive/mobile_screen_layout.dart';
import 'package:inst_fire/responsive/responsive_layout_screen.dart';
import 'package:inst_fire/responsive/web_screen_layout.dart';
import 'package:inst_fire/screens/add_task.dart';
import 'package:inst_fire/screens/login_screen.dart';
import 'package:inst_fire/screens/profile_screen.dart';
import 'package:inst_fire/screens/search_screen.dart';
import 'package:inst_fire/screens/signup_screen.dart';
import 'package:inst_fire/services/local_notification_service.dart';
import 'package:inst_fire/utils/colours.dart';
import 'package:provider/provider.dart';



//Уведомления, проиложенияга али кирмеген кезде
Future<void> backgroundHandler(RemoteMessage message)async{
  print(message.data.toString());
  print(message.notification!.title);
} 

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
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  









  // This widget is the root of your application.
  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Instagram clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        

        //Stream Builder ОЛ ЮСЕРДИН ДАННЫЕ СОХРАНЯЕТ
        home: 
        StreamBuilder(
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

            return const LoginScreen();
          },
        ),
        
      ),
    );
  }
}
