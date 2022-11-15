import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:inst_fire/models/user.dart' as model;
import '../notify/constants.dart';
import '../notify/local_push_notification.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/colours.dart';
import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<String> userTokens = [];
  var seen = Set<String>();
  List<String> uniquelist = [];
  var userData = {};

  bool isLoading = false;
  String uid = '';
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FirebaseMessaging.instance.getInitialMessage();
    // FirebaseMessaging.onMessage.listen((event) {
    //   LocalNotificationService.display(event);
    // });

    // FirebaseMessaging.instance.subscribeToTopic('subscription');
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
        .where('bio', isEqualTo: 'almaty')
        .get();
    final querySnapshot1 = await FirebaseFirestore.instance
        .collection('users')
        .where('bio', isEqualTo: 'astana')
        .get();
    final querySnapshot2 = await FirebaseFirestore.instance
        .collection('users')
        .where('bio', isEqualTo: 'shymkent')
        .get();
    final querySnapshot3 = await FirebaseFirestore.instance
        .collection('users')
        .where('bio', isEqualTo: 'kyzylorda')
        .get();
    final querySnapshot4 = await FirebaseFirestore.instance
        .collection('users')
        .where('bio', isEqualTo: 'karaganda')
        .get();
    final querySnapshot5 = await FirebaseFirestore.instance
        .collection('users')
        .where('bio', isEqualTo: 'astana almaty shymkent kyzylorda karaganda')
        .get();
    final querySnapshot6 = await FirebaseFirestore.instance
        .collection('users')
        .where('bio', isEqualTo: 'almaty shymkent kyzylorda karaganda')
        .get();
    final querySnapshot7 = await FirebaseFirestore.instance
        .collection('users')
        .where('bio', isEqualTo: 'astana shymkent kyzylorda karaganda')
        .get();
    final querySnapshot8 = await FirebaseFirestore.instance
        .collection('users')
        .where('bio', isEqualTo: 'astana karaganda')
        .get();

    for (var doc in querySnapshot.docs) {
      // Getting data directly
      userTokens.add('"${doc.get('token')}"');

      // Getting data from map
      Map<String, dynamic> data = doc.data();
    }
    for (var doc in querySnapshot1.docs) {
      userTokens.add('"${doc.get('token')}"');
    }
    for (var doc in querySnapshot2.docs) {
      userTokens.add('"${doc.get('token')}"');
    }
    for (var doc in querySnapshot3.docs) {
      userTokens.add('"${doc.get('token')}"');
    }
    for (var doc in querySnapshot4.docs) {
      userTokens.add('"${doc.get('token')}"');
    }
    for (var doc in querySnapshot5.docs) {
      userTokens.add('"${doc.get('token')}"');
    }
    for (var doc in querySnapshot6.docs) {
      userTokens.add('"${doc.get('token')}"');
    }
    for (var doc in querySnapshot7.docs) {
      userTokens.add('"${doc.get('token')}"');
    }
    for (var doc in querySnapshot8.docs) {
      userTokens.add('"${doc.get('token')}"');
    }
    uniquelist = userTokens.where((country) => seen.add(country)).toList();
    uniquelist.remove('"${userData['token']}"');
    // String element1 =
    //     '"${userData['token'].toString().replaceAll("]", "").replaceAll("[", "")}"';
    // for (var item in userTokens) {
    //   if (item == element1) {
    //     userTokens.remove(item);
    //   }
    // }
  }

  Future<bool> pushNotificationsGroupDevice({
    required String title,
    required String body,
  }) async {
    String dataNotifications = '{'
        '"operation": "create",'
        '"notification_key_name": "appUser-testUser",'
        '"registration_ids": [${uniquelist.toString().replaceAll("]", "").replaceAll("[", "")}],'
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

  sendNotificationToTopic(String title, String body) async {
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
                'notification': <String, dynamic>{'title': title, 'body': body},
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

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: blackBlue,
          title: const Text('Добавить пост'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Сделать снимку'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Выбрать из галереи'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Выйти"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          'Опубликовано',
          context,
        );
        clearImage();
      } else {
        showSnackBar(res, context);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: maroon,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: IconButton(
                padding: EdgeInsets.only(right: 47, bottom: 47),
                icon: const Icon(
                  Icons.add_box_outlined,
                  size: 70,
                  color: blackBlue,
                ),
                onPressed: () => _selectImage(context),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: maroon,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    postImage(
                      userProvider.getUser.uid,
                      userProvider.getUser.username,
                      userProvider.getUser.photoUrl,
                    );
                    pushNotificationsGroupDevice(
                        title: 'COTTON News', body: 'Опубликовали новый пост');
                  },
                  child: const Text(
                    "Опубликовать",
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        userProvider.getUser.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        style: TextStyle(color: mobileBackgroundColor),
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Описание...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: secondaryColor),
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }
}
