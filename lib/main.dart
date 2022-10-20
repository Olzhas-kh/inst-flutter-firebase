import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'package:inst_fire/providers/user_provider.dart';
import 'package:inst_fire/responsive/mobile_screen_layout.dart';
import 'package:inst_fire/responsive/responsive_layout_screen.dart';
import 'package:inst_fire/responsive/web_screen_layout.dart';
import 'package:inst_fire/screens/login_screen.dart';
import 'package:inst_fire/screens/profile_screen.dart';

import 'package:inst_fire/utils/colours.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

import 'notify/local_push_notification.dart';

//Уведомления, проиложенияга али кирмеген кезде

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// On click listner
  if (message.notification != null) {
    //No need for showing Notification manually.
    //For BackgroundMessages: Firebase automatically sends a Notification.
    //If you call the flutterLocalNotificationsPlugin.show()-Methode for
    //example the Notification will be displayed twice.
  }
  return;
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
        home: SplashScreen(
          seconds: 3,
          navigateAfterSeconds: StreamBuilder(
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
          backgroundColor: Colors.black,
          useLoader: true,
          imageBackground: AssetImage('assets/WelcomeBar.png'),
          loaderColor: primaryColor,
        ),
      ),
    );
  }
}

// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'message_handler.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData.dark(),
//       home: const MyHomePage(title: 'Flutter Firebase Push'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   String _receivedPushMessage = "...";
//   final myController = TextEditingController();

//   @override
//   void dispose() {
//     // Clean up the controller when the widget is disposed.
//     myController.dispose();
//     super.dispose();
//   }

//   // It is assumed that all messages contain a data field with the key 'type'
//   Future<void> setupInteractedMessage() async {
//     // Get any messages which caused the application to open from
//     // a terminated state.
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

//     // If the message also contains a data property with a "type" of "chat",
//     // navigate to a chat screen
//     if (initialMessage != null) {
//       _handleMessage(initialMessage);
//     }

//     // Also handle any interaction when the app is in the background via a
//     // Stream listener
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
//   }

//   void _listenForMessages() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');

//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//         setState(() {
//           String? body = message.notification?.body;
//           if (body != null) {
//             this._receivedPushMessage = body;
//           } else {
//             this._receivedPushMessage = "message boy was null";
//           }
//         });
//       }
//     });
//   }

//   void _handleMessage(RemoteMessage message) {
//     if (message.data['type'] == 'chat') {
//       Navigator.pushNamed(
//         context,
//         '/chat',
//         arguments: message,
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Run code required to handle interacted messages in an async function
//     // as initState() must not be async
//     _requestPermission();
//     // setupInteractedMessage();
//     _listenForMessages();
//   }

//   void _requestPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//       print(await FirebaseMessaging.instance.getToken());
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }

//   /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
//   String constructFCMPayload(String? token) {
//     return jsonEncode({
//       'token': token,
//       'data': {'via': 'FlutterFire Cloud Messaging!!!'},
//       'notification': {
//         'title': 'Hello FlutterFire!',
//         'body': 'This notification was created via FCM!',
//       },
//     });
//   }

//   Future<void> _sendPush() async {
//     // myController.text;

//     var _token = await FirebaseMessaging.instance.getToken();

//     if (_token == null) {
//       print('Unable to send FCM message, no token exists.');
//       return;
//     }

//     try {
//       await http.post(
//         // Reusing this URL from the FlutterFire examples
//         Uri.parse('https://api.rnfirebase.io/messaging/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: constructFCMPayload(_token),
//       );
//       print('FCM request for device sent!');
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Received Push will show here:',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               child: Text(
//                 _receivedPushMessage,
//                 style: const TextStyle(
//                     fontSize: 32,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 100),
//             Text(
//               'Type your message and send a push:',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               child: TextField(
//                 style: const TextStyle(fontSize: 32),
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter your push message',
//                 ),
//                 controller: myController,
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _sendPush,
//         tooltip: 'Send Push',
//         child: const Icon(Icons.send),
//       ),
//     );
//   }
// }
