// import 'dart:math';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin
//       _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   static void initialize() {
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: AndroidInitializationSettings("@mipmap/ic_launcher"));
//     _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   static void display(RemoteMessage message) async {
//     try {
//       print("In Notification method");
//       // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
//       Random random = new Random();
//       int id = random.nextInt(1000);
//       final NotificationDetails notificationDetails = NotificationDetails(
//           android: AndroidNotificationDetails(
//         "mychanel",
//         "my chanel",
//         importance: Importance.max,
//         priority: Priority.high,
//       ));
//       print("my id is ${id.toString()}");
//       await _flutterLocalNotificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetails,
//       );
//     } on Exception catch (e) {
//       print('Error>>>$e');
//     }
//   }
// }










// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static void initialize(BuildContext context) {
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: AndroidInitializationSettings("@mipmap/ic_launcher"));

//     _notificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? route)async{
//       if(route!=null){
//              Navigator.of(context).pushNamed(route);

//       }
//     });
//   }

//   static void display(RemoteMessage message) async {
//     try {
//   final id = DateTime.now().millisecondsSinceEpoch ~/1000;
//   final NotificationDetails notificationDetails = NotificationDetails(
//     android: AndroidNotificationDetails(
//       "easyapproach",
//        "easyapproach channel",
//        importance: Importance.max,
//        priority: Priority.high,
       
//     )
//   );
//   await _notificationsPlugin.show(id, message.notification!.title,
//       message.notification!.title, notificationDetails, payload: message.data["route"],);
// } on Exception catch (e) {
//   print(e);
// }
//   }
// }
