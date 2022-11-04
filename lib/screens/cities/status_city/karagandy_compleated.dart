import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inst_fire/utils/colours.dart';
import 'package:intl/intl.dart';
import 'package:inst_fire/models/user.dart' as model;
import 'package:provider/provider.dart';
import 'package:slimy_card/slimy_card.dart';

import '../../../providers/user_provider.dart';
import '../../../resources/firestore_methods.dart';
import '../../../utils/utils.dart';

class CompleatedKaragandy extends StatefulWidget {
  final snap;
  const CompleatedKaragandy({Key? key, required this.snap}) : super(key: key);

  @override
  State<CompleatedKaragandy> createState() => _CompleatedKaragandyState();
}

class _CompleatedKaragandyState extends State<CompleatedKaragandy> {
  bool isbutton = true;
  final listStatus = [
    '',
    'В процессе: ',
    'Выполнено: ',
  ];
  String changedText = '';
  String statusString_1 = '';
  Color colorButton = Colors.grey;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void _button1() {
    setState(() {
      isbutton = true;
    });
  }

  void _button2() {
    setState(() {
      isbutton = false;
    });
  }

  var userData = {};

  bool isLoading = false;
  String uid = '';
  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      final User user = auth.currentUser!;
      uid = user.uid;

      var userSnap = await FirebaseFirestore.instance
          .collection('karagandy')
          .doc(widget.snap['commentId'])
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

  bool isLikeAnimating = false;

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
                    showSnackBar('В процессе', context);
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

    return widget.snap['status'].contains('Выполнено:')
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: SlimyCard(
              width: 450,
              topCardHeight: 180,
              color: greenStatus,
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
                                                .data()['dateCompleated']
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
                                                .data()['dateCompleated']
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
                                    'В процессе:',
                                    widget.snap['status']);
                                statusString_1 = "в процессе: ";
                              },
                              child: Text('Выполнить'),
                              color: Colors.red,
                            )
                          : widget.snap['status'].contains('В процессе:')
                              ? ElevatedButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.orange),
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
                                                            'В процессе:',
                                                            widget.snap[
                                                                'status']);
                                                    statusString_1 = "";
                                                  } else {
                                                    showSnackBar(
                                                        'В процессе', context);
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
                                          'В процессе:',
                                          widget.snap['status']);
                                    } else {
                                      showSnackBar('В процессе', context);
                                      print('progress');
                                    }
                                    statusString_1 = "выполнено: ";
                                  },
                                  child: Text('В процессе'),
                                )
                              : widget.snap['status'].contains('Выполнено')
                                  ? MaterialButton(
                                      onPressed: () {
                                        null;
                                      },
                                      child: Text('dfgergrg'),
                                      color: Colors.greenAccent,
                                    )
                                  : ElevatedButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.green.shade900),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            side:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        null;
                                      },
                                      child: Text('Выполнено'),
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
