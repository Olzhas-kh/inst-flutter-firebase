import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inst_fire/utils/colours.dart';
import 'package:intl/intl.dart';
import 'package:inst_fire/models/user.dart' as model;
import 'package:provider/provider.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:http/http.dart' as http;

import '../notify/constants.dart';
import '../notify/local_push_notification.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  List<String> userTokens = [];
  var seen = Set<String>();
  List<String> uniquelist = [];
  var userData = {};

  bool isLoading = false;
  String uid = '';
  @override
  void initState() {
    super.initState();

    getData();
    // userTokens.remove('"${userData['token'].toString().replaceAll("]", "").replaceAll("[", "")}"');
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

    for (var doc in querySnapshot.docs) {
      // Getting data directly
      userTokens.add('"${doc.get('token')}"');

      // Getting data from map
      Map<String, dynamic> data = doc.data();
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
    print(
        'Osy toke: ${uniquelist.toString().replaceAll("]", "").replaceAll("[", "")}');

    return true;
  }

  deleteTaskAlmaty(String commentId) async {
    try {
      await FireStoreMethods().deleteTaskAlmaty(commentId);
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  Future<void> _showSimpleDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            // <-- SEE HERE
            title: const Text('????????????????:'),
            backgroundColor: maroon,
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  deleteTaskAlmaty(
                    widget.snap['commentId'].toString(),
                  );
                  // remove the dialog box
                  Navigator.of(context).pop();
                },
                child: const Text('??????????????'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return widget.snap['likes'].toString() == "[]"
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: SlimyCard(
              width: 450,
              topCardHeight: 180,
              color: greyRGB,
              topCardWidget: Column(
                children: [
                  Center(
                    child: Text(
                      widget.snap['text'],
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          widget.snap.data()['profilePic'],
                        ),
                        radius: 18,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: widget.snap.data()['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    TextSpan(
                                      text:
                                          ' ${widget.snap['status'].toString().replaceAll("]", "").replaceAll("[", "")} ${widget.snap['likes'].toString().replaceAll("]", "").replaceAll("[", "")}',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '????????: ',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd/MM').format(
                                            widget.snap
                                                .data()['datePublished']
                                                .toDate(),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '??????????: ',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '${DateFormat.Hm().format(
                                            widget.snap
                                                .data()['datePublished']
                                                .toDate(),
                                          )}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      widget.snap['uid'].toString() == user.uid
                          ? IconButton(
                              onPressed: _showSimpleDialog,
                              icon: const Icon(Icons.more_vert),
                            )
                          : Container(),
                      widget.snap['likes'].toString() == "[]"
                          ? ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red.shade900),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    side: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                FireStoreMethods().likeTaskAlmaty(
                                  widget.snap['commentId'].toString(),
                                  user.username,
                                  widget.snap['likes'],
                                );
                                FireStoreMethods().statusTaskAlmaty(
                                    widget.snap['commentId'],
                                    '??????????????:',
                                    widget.snap['status']);
                                FireStoreMethods().dateProcessAlmaty(
                                  widget.snap['commentId'],
                                );
                                pushNotificationsGroupDevice(
                                    title: userData['username'],
                                    body: '???????????? ????????????: ??????????????');

                                print(uniquelist.toString());
                              },
                              child: Text('??????????????'),
                            )
                          : widget.snap['status'].contains('??????????????:')
                              ? MaterialButton(
                                  onLongPress: () {
                                    showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            // <-- SEE HERE
                                            title: const Text(
                                                'Select Booking Type'),
                                            children: <Widget>[
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  if (widget.snap['likes']
                                                      .contains(
                                                          user.username)) {
                                                    FireStoreMethods()
                                                        .likeTaskAlmaty(
                                                      widget.snap['commentId']
                                                          .toString(),
                                                      user.username,
                                                      widget.snap['likes'],
                                                    );
                                                    FireStoreMethods()
                                                        .statusTaskAlmaty(
                                                            widget.snap[
                                                                'commentId'],
                                                            '??????????????:',
                                                            widget.snap[
                                                                'status']);
                                                  } else {
                                                    showSnackBar(
                                                        '???????????? ?????? ??????????????',
                                                        context);
                                                    print('progress');
                                                  }

                                                  // remove the dialog box
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('????????????????'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  onPressed: () {
                                    if (widget.snap['likes']
                                        .contains(user.username)) {
                                      FireStoreMethods().statusTaskAlmaty(
                                          widget.snap['commentId'],
                                          '??????????????????:',
                                          widget.snap['status']);
                                      FireStoreMethods().statusTaskAlmaty(
                                          widget.snap['commentId'],
                                          '??????????????:',
                                          widget.snap['status']);
                                    } else {
                                      showSnackBar(
                                          '???????????? ?????? ??????????????', context);
                                      print('progress');
                                    }
                                  },
                                  child: Text('?? ????????????????'),
                                  color: Colors.orange,
                                )
                              : widget.snap['status'].contains('??????????????????')
                                  ? MaterialButton(
                                      onPressed: () {
                                        null;
                                      },
                                      child: Text('dfgergrg'),
                                      color: Colors.greenAccent,
                                    )
                                  : MaterialButton(
                                      onPressed: () {
                                        null;
                                      },
                                      child: Text('??????????????????'),
                                      color: Colors.green,
                                    ),
                    ],
                  ),
                ],
              ),
              bottomCardWidget: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child: Text(
                      widget.snap['description'],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
