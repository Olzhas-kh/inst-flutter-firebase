import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colours.dart';
import '../utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
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
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: mobileBackgroundColor,
        items: [
          Icon(
            Icons.add_task,
            color: (_page == 0) ? Colors.black : secondaryColor,
            size: 28,
          ),
          Icon(
            Icons.newspaper_rounded,
            color: (_page == 1) ? Colors.black : secondaryColor,
            size: 28,
          ),
          Icon(
            Icons.person,
            color: (_page == 2) ? Colors.black : secondaryColor,
            size: 28,
          ),
        ],
        onTap: navigationTapped,
        index: _page,
      ),
    );
  }
}
