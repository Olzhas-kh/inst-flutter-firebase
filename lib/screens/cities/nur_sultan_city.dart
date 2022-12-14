import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:inst_fire/screens/cities/status_city/astana_compleated.dart';
import 'package:inst_fire/screens/cities/status_city/astana_inprogress.dart';
import 'package:inst_fire/utils/colours.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:inst_fire/models/user.dart' as model;
import '../../notify/constants.dart';
import '../../notify/local_push_notification.dart';
import '../../providers/user_provider.dart';
import '../../resources/firestore_methods.dart';
import '../../utils/utils.dart';
import '../cities_task_card.dart/nursultan_task_card.dart';

class AstanaCity extends StatefulWidget {
  const AstanaCity({super.key, required});

  @override
  State<AstanaCity> createState() => _AstanaCityState();
}

class _AstanaCityState extends State<AstanaCity> {
  get mobileBackgroundColor => null;

  void _addTask(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: const titleDesAddScreen()),
            ));
  }

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
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: maroon,
                  title: const Text(
                    '????????????',
                  ),
                  bottom: TabBar(tabs: [
                    Tab(
                      text: '????????????',
                    ),
                    Tab(
                      text: '??????????????',
                    ),
                    Tab(
                      text: '??????????????????',
                    ),
                  ]),
                ),
                body: TabBarView(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('astana')
                          .orderBy('datePublished', descending: false)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (ctx, index) => AstanaGiveTask(
                              snap: snapshot.data!.docs[index],
                            ),
                          ),
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('astana')
                          .orderBy('datePublished', descending: false)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (ctx, index) => InProgressAstana(
                              snap: snapshot.data!.docs[index],
                            ),
                          ),
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('astana')
                          .orderBy('datePublished', descending: false)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (ctx, index) => CompleatedAstana(
                              snap: snapshot.data!.docs[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: maroon,
                  onPressed: () => _addTask(context),
                  tooltip: 'Add Task',
                  child: const Icon(
                    Icons.add,
                    color: primaryColor,
                  ),
                ),
                // text input
              ),
      );
}

class titleDesAddScreen extends StatefulWidget {
  const titleDesAddScreen({
    super.key,
  });

  @override
  State<titleDesAddScreen> createState() => _titleDesAddScreenState();
}

class _titleDesAddScreenState extends State<titleDesAddScreen> {
  List<String> userTokens = [];
  var seen = Set<String>();
  List<String> uniquelist = [];
  String tok = '';

  var userData = {};

  bool isLoading = false;
  String uid = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User user = auth.currentUser!;
    uid = user.uid;

    var userSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    userData = userSnap.data()!;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('bio', isEqualTo: 'astana')
        .get();

    for (var doc in querySnapshot.docs) {
      // Getting data directly
      userTokens.add('"${doc.get('token')}"');

      // Getting data from map
      Map<String, dynamic> data = doc.data();
    }
    uniquelist = userTokens.where((country) => seen.add(country)).toList();
    uniquelist.remove('"${userData['token']}"');
  }

  sendNotificationToTopic(String title) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAANd42yUc:APA91bH0bRQLnJ-XS-GHxS50PsQeNCFLdYR1mz8tRJIlAbY2pybNt3sRj7oyaaKisdfa5FGkLpBcJYeeosHZLdi3lo2AirA18U_1LRwFJiL8ZK1X_TNdmdNVK0yHmxZhB_X3sZxX25SH'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body': 'You are followed by someone'
                },
                'priority': 'high',
                'data': data,
                'to': '/topics/subscription'
              }));

      if (response.statusCode == 200) {
        print("Yeh notificatin is sended");
      } else {
        print("Error");
      }
    } catch (e) {}
  }

  Future<bool> pushNotificationsGroupDevice({
    required String title,
    required String body,
  }) async {
    String dataNotifications = '{'
        '"operation": "create",'
        '"notification_key_name": "appUser-testUser",'
        '"registration_ids": [${uniquelist.toString().replaceAll("]", "").replaceAll("[", "")}],'
        '"screen": "homePage",'
        '"notification" : {'
        '"title":"$title",'
        '"body":"$body"'
        ' }'
        ' }';

    var response = await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotifications,
    );

    print(response.body.toString());

    return true;
  }

  TextEditingController descriptionController = TextEditingController();

  final TextEditingController titleController = TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreMethods().astana(
        titleController.text,
        descriptionController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        showSnackBar(res, context);
      }
      setState(() {
        titleController.text = "";
        descriptionController.text = "";
      });
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            '???????????????? ????????????',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: TextField(
              autofocus: true,
              controller: titleController,
              decoration: InputDecoration(
                label: Text('????????????????'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          TextField(
            autofocus: true,
            controller: descriptionController,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              label: Text('????????????????'),
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('??????????'),
              ),
              InkWell(
                onTap: () {
                  getData();
                  pushNotificationsGroupDevice(
                      title: userData['username'], body: titleController.text);
                  postComment(
                    userData['uid'],
                    userData['username'],
                    userData['photoUrl'],
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    '????????????????????????',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
