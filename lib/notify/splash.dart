import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:inst_fire/screens/login_screen.dart';

// import '../responsive/mobile_screen_layout.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   User? user = FirebaseAuth.instance.currentUser;
//   @override
//   void initState() {
//     super.initState();
//     timer();
//   }

//   Timer timer() {
//     if (user.isNull) {
//       return Timer(
//           Duration(seconds: 2),
//           () => Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (context) => LoginPage())));
//     } else {
//       return Timer(
//           Duration(seconds: 2),
//           () => Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (context) => MobileScreenLayout())));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//               begin: Alignment.topRight,
//               end: Alignment.bottomLeft,
//               colors: [
//                 Color.fromARGB(255, 228, 150, 163),
//                 Color.fromARGB(255, 46, 46, 46),
//               ]),
//         ),
//         child: Center(
//           child: Image.asset(
//             "assets/logo.png",
//             height: 400.0,
//             width: 400.0,
//           ),
//         ),
//       ),
//     );
//   }
// }
