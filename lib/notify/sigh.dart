// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'log.dart';
// import 'notifacation_screen.dart';

// class Sign extends StatefulWidget {
//   const Sign({Key? key}) : super(key: key);

//   @override
//   _SignState createState() => _SignState();
// }

// class _SignState extends State<Sign> {
//   AuthController? authController;

//   @override
//   void initState() {
//     super.initState();
//     authController = Get.put(AuthController());
//   }

//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   TextEditingController namecontroller = TextEditingController();
//   TextEditingController emailcontroller = TextEditingController();
//   TextEditingController passwordcontroller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//           child: Form(
//             key: formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: namecontroller,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Requred';
//                     } else {
//                       return null;
//                     }
//                   },
//                   decoration: const InputDecoration(
//                     hintText: 'Enter your name',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   controller: emailcontroller,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Requred';
//                     }
//                     if (!value.contains('@')) {
//                       return 'enter valid email';
//                     } else {
//                       return null;
//                     }
//                   },
//                   decoration: const InputDecoration(
//                     hintText: 'Enter your email',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   controller: passwordcontroller,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Requred';
//                     } else {
//                       return null;
//                     }
//                   },
//                   decoration: const InputDecoration(
//                     hintText: 'Enter your password',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (!formKey.currentState!.validate()) {
//                       return;
//                     }

//                     authController!.CreateMyUser(
//                       email: emailcontroller.text.trim(),
//                       password: passwordcontroller.text.trim(),
//                       name: namecontroller.text.trim(),
//                     );
//                   },
//                   child: Text('Create Account'),
//                 ),
//                 MaterialButton(
//                   onPressed: () {
//                     Get.to(() => Log());
//                   },
//                   child: Text('Already have account'),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
