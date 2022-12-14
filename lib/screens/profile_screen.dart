import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inst_fire/screens/add_post_screen.dart';
import 'package:inst_fire/screens/signup_screen.dart';
import 'package:inst_fire/screens/users_search/add_city_saerch_screen.dart';
import 'package:inst_fire/screens/users_search/almaty_search_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../resources/auth_methods.dart';
import '../resources/firestore_methods.dart';
import '../utils/colours.dart';
import '../utils/utils.dart';
import '../widgets/follow_button.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};

  bool isLoading = false;
  String uid = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      final User user = auth.currentUser!;
      uid = user.uid;

      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      userData = userSnap.data()!;

      setState(() {});
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
              child: Column(
                children: [
                  //for circle avtar image
                  _getHeader(),
                  SizedBox(
                    height: 10,
                  ),
                  _detailsCard(),
                  SizedBox(
                    height: 15,
                  ),

                  _settingsCard(),
                  SizedBox(
                    height: 26,
                  ),
                  logoutButton()
                ],
              ),
            )),
    );
  }

  Widget _getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    //borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(userData['photoUrl']))
                    // color: Colors.orange[100],
                    ),
              ),
            ),
            Text(
              userData['username'],
              style: TextStyle(color: blackBlue, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ],
    );
  }

  Widget _profileName(String name) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80, //80% of width,
      child: Center(
        child: Text(
          name,
          style: TextStyle(
              color: blackBlue, fontSize: 24, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _heading(String heading) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80, //80% of width,
      child: Text(
        heading,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _detailsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: blackBlue,
        elevation: 4,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text(userData['username']),
            ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text(userData['job_postion']),
            ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text(userData['city']),
            ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            userData['key'] == 'chair' ||
                    userData['key'].toString().contains('manager') ||
                    userData['key'].toString().contains('supervisor') ||
                    userData['key'].toString().contains('director') ||
                    userData['key'].toString().contains('author') ||
                    userData['key'].toString().contains('logistic')
                ? Container()
                : ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(userData['adress']),
                  ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: Icon(
                Icons.phone,
              ),
              title: Text(userData['telephone']),
              onTap: () {
                launch("tel://${userData['telephone'].replaceAll(' ', '')}");
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _settingsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: blackBlue,
        elevation: 4,
        child: Column(
          children: [
            //row for each deatails
            ListTile(
              leading: Icon(
                Icons.person_search,
              ),
              title: Text("????????????????????"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CitiesForSearch(),
                  ),
                );
              },
            ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text("????????????????????"),
              onTap: () {
                if (userData['bio'].toString().contains('author')) {
                  print(userData['bio'].toString());
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddPostScreen(),
                    ),
                  );
                } else {
                  print(userData['bio'].toString());
                  showSnackBar('?????? ???? ???????????????????????? ????????????', context);
                }
              },
            ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: Icon(Icons.person_add_alt_rounded),
              title: Text("??????????????????????"),
              onTap: () {
                if (userData['bio'].toString().contains('author')) {
                  print(userData['bio'].toString());
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RegistrationPage(),
                    ),
                  );
                } else {
                  print(userData['bio'].toString());
                  showSnackBar('?????? ???? ???????????????????????? ????????????', context);
                }
              },
            ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  Widget logoutButton() {
    return InkWell(
      onTap: () async {
        await AuthMethods().signOut(userData['uid']);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
      child: Container(
          color: maroon,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "??????????",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
          )),
    );
  }
}








// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../resources/auth_methods.dart';
// import '../resources/firestore_methods.dart';
// import '../utils/colours.dart';
// import '../utils/utils.dart';
// import '../widgets/follow_button.dart';
// import 'login_screen.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   var userData = {};

//   bool isLoading = false;
//   String uid = '';

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   getData() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       final FirebaseAuth auth = FirebaseAuth.instance;

//       final User user = auth.currentUser!;
//       uid = user.uid;

//       var userSnap =
//           await FirebaseFirestore.instance.collection('users').doc(uid).get();

//       userData = userSnap.data()!;

//       setState(() {});
//     } catch (e) {
//       showSnackBar(
//         e.toString(),
//         context,
//       );
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Center(
//               child: Column(children: [
//                 Text(userData['username']),
//                 Text(userData['bio']),
//                 Text(userData['email']),
//                 FollowButton(
//                   text: 'Sign Out',
//                   backgroundColor: mobileBackgroundColor,
//                   textColor: primaryColor,
//                   borderColor: Colors.grey,
//                   function: () async {
//                     await AuthMethods().signOut();
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(
//                         builder: (context) => const LoginPage(),
//                       ),
//                     );
//                   },
//                 ),
//               ]),
//             ),
//     );
//   }
// }
