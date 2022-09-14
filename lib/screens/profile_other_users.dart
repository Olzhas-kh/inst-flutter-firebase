import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../resources/auth_methods.dart';
import '../resources/firestore_methods.dart';
import '../utils/colours.dart';
import '../utils/utils.dart';
import '../widgets/follow_button.dart';
import 'login_screen.dart';


class ProfileOtherUsers extends StatefulWidget {
  final String uid;
  const ProfileOtherUsers({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileOtherUsersState createState() => _ProfileOtherUsersState();
}

class _ProfileOtherUsersState extends State<ProfileOtherUsers> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

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
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

    

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
    return  Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(children: [
          Text(userData['username']),
          Text(userData['bio']),
          Text(userData['email']),
          
        ]),
      ),
    );
  }

  
}