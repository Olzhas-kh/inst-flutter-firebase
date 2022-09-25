import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inst_fire/notify/notify_main.dart';
import 'package:inst_fire/screens/add_task.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/users_search/almaty_search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  AddTask(),
  const FeedScreen(),
  ProfileScreen(),
];
