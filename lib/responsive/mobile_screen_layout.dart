import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../notify/local_push_notification.dart';
import '../screens/add_post_screen.dart';
import '../utils/colours.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation
  var userData = {};

  bool isLoading = false;
  String uid = '';
  @override
  void initState() {
    super.initState();

    pageController = PageController();
    tokenGet();
    getData();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });

    FirebaseMessaging.instance.subscribeToTopic('subscription');
  }

  void tokenGet() async {
    String? token = await FirebaseMessaging.instance.getToken();

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
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
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : PageView(
              children: homeScreenItems,
              controller: pageController,
              onPageChanged: onPageChanged,
            ),
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: primaryColor,
        color: maroon,
        items: [
          Icon(
            Icons.add_task,
            color: (_page == 0) ? primaryColor : primaryColor,
            size: 28,
          ),
          Icon(
            Icons.newspaper_rounded,
            color: (_page == 1) ? primaryColor : primaryColor,
            size: 28,
          ),
          Icon(
            Icons.person,
            color: (_page == 2) ? primaryColor : primaryColor,
            size: 28,
          ),
        ],
        onTap: navigationTapped,
        index: _page,
      ),
    );
  }
}
