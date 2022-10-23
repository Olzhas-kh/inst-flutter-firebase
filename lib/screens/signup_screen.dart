import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inst_fire/utils/colours.dart';

import '../resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/common_header.dart';
import '../utils/theme_helper.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _job_postion_controller = TextEditingController();
  final TextEditingController _city_controller = TextEditingController();
  final TextEditingController _telephone_controller = TextEditingController();
  final TextEditingController _adress_controller = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        job_postion: _job_postion_controller.text,
        city: _city_controller.text,
        telephone: _telephone_controller.text,
        adress: _adress_controller.text,
        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(res, context);
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget(150, false, ""),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    _image != null
                                        ? CircleAvatar(
                                            radius: 55,
                                            backgroundImage:
                                                MemoryImage(_image!),
                                            backgroundColor: Colors.red,
                                          )
                                        : const CircleAvatar(
                                            radius: 55,
                                            backgroundImage: NetworkImage(
                                                'https://i.stack.imgur.com/l60Hf.png'),
                                            backgroundColor: Colors.red,
                                          ),
                                    Positioned(
                                      bottom: -10,
                                      left: 80,
                                      child: IconButton(
                                        onPressed: selectImage,
                                        icon: const Icon(Icons.add_circle),
                                        color: Colors.grey.shade700,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFieldInput(
                            hintText: 'Enter your username',
                            textInputType: TextInputType.text,
                            textEditingController: _usernameController,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFieldInput(
                            hintText: 'Enter your email',
                            textInputType: TextInputType.emailAddress,
                            textEditingController: _emailController,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFieldInput(
                            hintText: 'Enter your password',
                            textInputType: TextInputType.text,
                            textEditingController: _passwordController,
                            isPass: true,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFieldInput(
                            hintText: 'Enter your bio',
                            textInputType: TextInputType.text,
                            textEditingController: _bioController,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFieldInput(
                            hintText: 'Enter your job position',
                            textInputType: TextInputType.text,
                            textEditingController: _job_postion_controller,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFieldInput(
                            hintText: 'Enter your city',
                            textInputType: TextInputType.text,
                            textEditingController: _city_controller,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFieldInput(
                            hintText: 'Enter your adress',
                            textInputType: TextInputType.text,
                            textEditingController: _adress_controller,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFieldInput(
                            hintText: 'Enter your telephone',
                            textInputType: TextInputType.text,
                            textEditingController: _telephone_controller,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        SizedBox(height: 45.0),
                        InkWell(
                          child: Container(
                            child: !_isLoading
                                ? const Text(
                                    'Sign up',
                                  )
                                : const CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                              color: blueColor,
                            ),
                          ),
                          onTap: signUpUser,
                        ),
                        SizedBox(height: 30.0),
                        Text(
                          "Do you already have an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
































// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart';

// import '../resources/auth_methods.dart';
// import '../responsive/mobile_screen_layout.dart';
// import '../responsive/responsive_layout_screen.dart';
// import '../responsive/web_screen_layout.dart';
// import '../utils/colours.dart';
// import '../utils/utils.dart';
// import '../widgets/text_field_input.dart';
// import 'login_screen.dart';


// class SignupScreen extends StatefulWidget {
//   const SignupScreen({Key? key}) : super(key: key);

//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _bioController = TextEditingController();
//   bool _isLoading = false;
//   Uint8List? _image;

//   @override
//   void dispose() {
//     super.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _usernameController.dispose();
//   }

//   void signUpUser() async {
//     // set loading to true
//     setState(() {
//       _isLoading = true;
//     });

//     // signup user using our authmethodds
//     String res = await AuthMethods().signUpUser(
//         email: _emailController.text,
//         password: _passwordController.text,
//         username: _usernameController.text,
//         bio: _bioController.text,
//         file: _image!);
//     // if string returned is sucess, user has been created
//     if (res == "success") {
//       setState(() {
//         _isLoading = false;
//       });
//       // navigate to the home screen
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => const ResponsiveLayout(
//             mobileScreenLayout: MobileScreenLayout(),
//             webScreenLayout: WebScreenLayout(),
//           ),
//         ),
//       );
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//       // show the error
//       showSnackBar( res,context);
//     }
//   }

//   selectImage() async {
//     Uint8List im = await pickImage(ImageSource.gallery);
//     // set state because we need to display the image we selected on the circle avatar
//     setState(() {
//       _image = im;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 32),
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Flexible(
//                 child: Container(),
//                 flex: 2,
//               ),
//               SvgPicture.asset(
//                 'assets/ic_instagram.svg',
//                 color: primaryColor,
//                 height: 64,
//               ),
//               const SizedBox(
//                 height: 64,
//               ),
//               Stack(
//                 children: [
//                   _image != null
//                       ? CircleAvatar(
//                           radius: 64,
//                           backgroundImage: MemoryImage(_image!),
//                           backgroundColor: Colors.red,
//                         )
//                       : const CircleAvatar(
//                           radius: 64,
//                           backgroundImage: NetworkImage(
//                               'https://i.stack.imgur.com/l60Hf.png'),
//                           backgroundColor: Colors.red,
//                         ),
//                   Positioned(
//                     bottom: -10,
//                     left: 80,
//                     child: IconButton(
//                       onPressed: selectImage,
//                       icon: const Icon(Icons.add_a_photo),
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               TextFieldInput(
//                 hintText: 'Enter your username',
//                 textInputType: TextInputType.text,
//                 textEditingController: _usernameController,
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               TextFieldInput(
//                 hintText: 'Enter your email',
//                 textInputType: TextInputType.emailAddress,
//                 textEditingController: _emailController,
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               TextFieldInput(
//                 hintText: 'Enter your password',
//                 textInputType: TextInputType.text,
//                 textEditingController: _passwordController,
//                 isPass: true,
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               TextFieldInput(
//                 hintText: 'Enter your bio',
//                 textInputType: TextInputType.text,
//                 textEditingController: _bioController,
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               InkWell(
//                 child: Container(
//                   child: !_isLoading
//                       ? const Text(
//                           'Sign up',
//                         )
//                       : const CircularProgressIndicator(
//                           color: primaryColor,
//                         ),
//                   width: double.infinity,
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   decoration: const ShapeDecoration(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(4)),
//                     ),
//                     color: blueColor,
//                   ),
//                 ),
//                 onTap: signUpUser,
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//               Flexible(
//                 child: Container(),
//                 flex: 2,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     child: const Text(
//                       'Already have an account?',
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                   ),
//                   GestureDetector(
//                     onTap: () => Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const LoginPage(),
//                       ),
//                     ),
//                     child: Container(
//                       child: const Text(
//                         ' Login.',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }