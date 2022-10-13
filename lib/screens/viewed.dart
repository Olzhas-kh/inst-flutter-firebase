import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../resources/auth_methods.dart';
import '../resources/firestore_methods.dart';
import '../utils/colours.dart';
import '../utils/utils.dart';
import '../widgets/follow_button.dart';
import 'login_screen.dart';

class ViewedProfile extends StatefulWidget {
  final String uid;
  const ViewedProfile({Key? key, required this.uid}) : super(key: key);

  @override
  _ViewedProfileState createState() => _ViewedProfileState();
}

class _ViewedProfileState extends State<ViewedProfile> {
  var userData = {};

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
    return isLoading
        ? Container()
        : Column(
            children: [
              Container(
                width: 250,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(userData['photoUrl'].toString()),
                        radius: 18,
                      ),
                      Text(' ${userData['username'].toString()}'),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          );
  }
}
