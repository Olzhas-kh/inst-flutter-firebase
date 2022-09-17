// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:inst_fire/notify/sigh.dart';

// import 'n_main.dart';

// class Log extends StatefulWidget {
//   const Log({Key? key}) : super(key: key);

//   @override
//   _LogState createState() => _LogState();
// }

// class _LogState extends State<Log> {
//   TextEditingController emailcontroller = TextEditingController();
//   TextEditingController passwordcontroller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//         height: double.infinity,
//         child: Form(
//           child: Column(
//             children: [
//               const SizedBox(height: 40),
//               TextFormField(
//                 controller: emailcontroller,
//                 decoration: const InputDecoration(
//                   hintText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               TextFormField(
//                 controller: passwordcontroller,
//                 decoration: const InputDecoration(
//                   hintText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   FirebaseAuth.instance
//                       .signInWithEmailAndPassword(
//                     email: emailcontroller.text,
//                     password: passwordcontroller.text,
//                   )
//                       .then((value) {
//                     Get.to(HomeScreen());
//                   });
//                 },
//                 child: Text('Sign in'),
//               ),
//               MaterialButton(
//                 onPressed: () {
//                   Get.to(
//                     () => Sign(),
//                   );
//                 },
//                 child: const Text('Do not have account'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
