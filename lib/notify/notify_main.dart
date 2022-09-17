// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:inst_fire/screens/profile_screen.dart';
// import 'package:inst_fire/services/local_notification_service.dart';



// class Notify_main extends StatefulWidget {
//   const Notify_main({super.key});

//   @override
//   State<Notify_main> createState() => _Notify_mainState();
// }

// class _Notify_mainState extends State<Notify_main> {
  
//   @override
//   void initState() {
//     super.initState();
//       LocalNotificationService.initialize(context);

    
//     FirebaseMessaging.instance.getInitialMessage().then((message){
//       if(message != null){
//         final routeFromMessage = message.data["route"];

//       Navigator.of(context).pushNamed(routeFromMessage);
//       }
//     });


//     //foreground work
//     FirebaseMessaging.onMessage.listen((message) { 
//       if(message.notification != null){
//         print(message.notification!.body);
//       print(message.notification!.title);
//       }
//       LocalNotificationService.display(message);
//     });


//     //Уведомления баскан кездеги жумыс, приложения ашык турган кезде но свернуть болган кезде
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       final routeFromMessage = message.data["route"];

//       Navigator.of(context).pushNamed(routeFromMessage);
      
//      });

//   }


//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Main'),
//     );
//   }
// }