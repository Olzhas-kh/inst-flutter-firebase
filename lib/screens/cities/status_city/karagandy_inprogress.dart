import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inst_fire/utils/colours.dart';
import 'package:intl/intl.dart';
import 'package:inst_fire/models/user.dart' as model;
import 'package:provider/provider.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:http/http.dart' as http;

import '../../../notify/constants.dart';
import '../../../providers/user_provider.dart';
import '../../../resources/firestore_methods.dart';
import '../../../utils/utils.dart';

class InProgressKaragandy extends StatefulWidget {
  final snap;
  const InProgressKaragandy({Key? key, required this.snap}) : super(key: key);

  @override
  State<InProgressKaragandy> createState() => _InProgressKaragandyState();
}

class _InProgressKaragandyState extends State<InProgressKaragandy> {
  var userData = {};
  List<String> userTokens = [];
  bool isLoading = false;
  String uid = '';
  var seen = Set<String>();
  List<String> uniquelist = [];
  @override
  void initState() {
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
        .where('bio', isEqualTo: 'karagandy')
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

  deleteTaskKaragandy(String commentId) async {
    try {
      await FireStoreMethods().deleteTaskKaragandy(commentId);
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
            backgroundColor: maroon,
            // <-- SEE HERE
            title: const Text('Выберите: '),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  deleteTaskKaragandy(
                    widget.snap['commentId'].toString(),
                  );
                  // remove the dialog box
                  Navigator.of(context).pop();
                },
                child: const Text('Удалить'),
              ),
            ],
          );
        });
  }

  Future<void> _back() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            // <-- SEE HERE
            title: const Text('Select Booking Type'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  if (widget.snap['likes'].contains(userData['username'])) {
                    FireStoreMethods().likeTaskKaragandy(
                      widget.snap['commentId'].toString(),
                      userData['username'],
                      widget.snap['likes'],
                    );
                  } else {
                    showSnackBar('Заявка уже принято', context);
                    print('progress');
                  }
                  // remove the dialog box
                  Navigator.of(context).pop();
                },
                child: const Text('Отменить'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return widget.snap['status'].contains('Принято:')
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: SlimyCard(
              width: 450,
              topCardHeight: 180,
              color: orangeStatus,
              topCardWidget: Column(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        widget.snap['text'],
                        style: TextStyle(fontSize: 25),
                      ),
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
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '${widget.snap['status'].toString().replaceAll("]", "").replaceAll("[", "")} ${widget.snap['likes'].toString().replaceAll("]", "").replaceAll("[", "")}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
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
                                          'Дата: ',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd/MM').format(
                                            widget.snap
                                                .data()['dateProcess']
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
                                          'Время: ',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '${DateFormat.Hm().format(
                                            widget.snap
                                                .data()['dateProcess']
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
                          ? MaterialButton(
                              onPressed: () {
                                FireStoreMethods().likeTaskKaragandy(
                                  widget.snap['commentId'].toString(),
                                  user.username,
                                  widget.snap['likes'],
                                );

                                FireStoreMethods().statusTaskKaragandy(
                                    widget.snap['commentId'],
                                    'Принято:',
                                    widget.snap['status']);
                              },
                              child: Text('Выполнить'),
                              color: Colors.red,
                            )
                          : widget.snap['status'].contains('Принято:')
                              ? ElevatedButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            orangeButton),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        side: BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  onLongPress: () {
                                    showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            backgroundColor: maroon,
                                            // <-- SEE HERE
                                            title: const Text('Выберите:'),
                                            children: <Widget>[
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  if (widget.snap['likes']
                                                      .contains(
                                                          user.username)) {
                                                    FireStoreMethods()
                                                        .likeTaskKaragandy(
                                                      widget.snap['commentId']
                                                          .toString(),
                                                      user.username,
                                                      widget.snap['likes'],
                                                    );
                                                    FireStoreMethods()
                                                        .statusTaskKaragandy(
                                                            widget.snap[
                                                                'commentId'],
                                                            'Принято:',
                                                            widget.snap[
                                                                'status']);
                                                    pushNotificationsGroupDevice(
                                                        title: userData[
                                                            'username'],
                                                        body:
                                                            '${widget.snap['text']}, Статус задачи: отменен');
                                                  } else {
                                                    showSnackBar(
                                                        'Заявка уже принято',
                                                        context);
                                                    print('progress');
                                                  }

                                                  // remove the dialog box
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Отменить'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  onPressed: () {
                                    if (widget.snap['likes']
                                        .contains(user.username)) {
                                      FireStoreMethods().statusTaskKaragandy(
                                          widget.snap['commentId'],
                                          'Выполнено:',
                                          widget.snap['status']);
                                      FireStoreMethods().statusTaskKaragandy(
                                          widget.snap['commentId'],
                                          'Принято:',
                                          widget.snap['status']);
                                      FireStoreMethods().dateCompletedKaraganda(
                                        widget.snap['commentId'],
                                      );
                                      pushNotificationsGroupDevice(
                                          title: userData['username'],
                                          body: 'Статус задачи:  выполнено');
                                    } else {
                                      showSnackBar(
                                          'Заявка уже принято', context);
                                      print('progress');
                                    }
                                  },
                                  child: Text('Завершить'),
                                )
                              : widget.snap['status'].contains('Выполнено')
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
                                      child: Text('Выполнено'),
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
