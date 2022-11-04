import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Scaffold(
      appBar: isLoading
          ? null
          : AppBar(
              backgroundColor: maroon,
              title: Text(userData['username']),
            ),
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
                  _profileName(userData['username']),
                  SizedBox(
                    height: 14,
                  ),
                  _heading("Personal Details"),
                  SizedBox(
                    height: 6,
                  ),
                  _detailsCard(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
    );
  }

  Widget _getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
                    fit: BoxFit.fill, image: NetworkImage(userData['photoUrl']))
                // color: Colors.orange[100],
                ),
          ),
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
            //row for each deatails
            ListTile(
              leading: Icon(Icons.email),
              title: Text(userData['email']),
            ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
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
                    userData['key'].toString().contains('author')
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
}
