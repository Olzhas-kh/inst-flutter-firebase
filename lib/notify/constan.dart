// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:inst_fire/notify/n_main.dart';
// import 'package:inst_fire/notify/sigh.dart';
// import 'package:inst_fire/responsive/mobile_screen_layout.dart';
// import 'package:inst_fire/screens/signup_screen.dart';

// class SplashScreen extends StatelessWidget {
//   String dotCoderLogo =
//       'https://raw.githubusercontent.com/OsamaQureshi796/MealMonkey/main/assets/dotcoder.png';

//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user.isNull) {
//       Timer(Duration(seconds: 5), () => Get.offAll(() => SignupScreen()));
//     } else {
//       Timer(Duration(seconds: 5), () => Get.offAll(() => MobileScreenLayout()));
//     }
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Container(
//                 width: Get.width,
//                 height: 220,
//                 child: Image.network(
//                   dotCoderLogo,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text("FCM by DOTCODER")
//           ],
//         ),
//       ),
//     );
//   }
// }
