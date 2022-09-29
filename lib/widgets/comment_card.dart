import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inst_fire/models/user.dart' as model;
import 'package:provider/provider.dart';
import 'package:slimy_card/slimy_card.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';
import 'like_animation.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
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
          .collection('almaty')
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
            title: const Text('Select Booking Type'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  deleteTaskAlmaty(
                    widget.snap['commentId'].toString(),
                  );
                  // remove the dialog box
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
              SimpleDialogOption(
                onPressed: () {},
                child: const Text('Progress'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Gold'),
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
                    FireStoreMethods().likeTaskAlmaty(
                      widget.snap['commentId'].toString(),
                      userData['username'],
                      widget.snap['likes'],
                    );
                  } else {
                    showSnackBar('В пргрессе', context);
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
  //  ifButton()  {

  //   if(widget.snap["status"]=='process' && widget.snap["likes"]==userData['username']){

  //        if(widget.snap["status"]=='[]' && widget.snap["likes"]!='[]'){
  //     return MaterialButton(
  //             onPressed:  (){
  //                null;
  //             } ,
  //             child: Text('Закончил'),
  //             color: Colors.green,
  //           );
  //   }else{
  //       return  MaterialButton(
  //             onPressed:  (){
  //                FireStoreMethods().statusTaskAlmaty(widget.snap['commentId'], 'process',widget.snap['status']);
  //             } ,
  //             child: Text('Закончил'),
  //             color: Colors.orange,
  //           );

  //   }
  //   }else if(widget.snap["status"]=='process' && widget.snap["likes"]!=userData['username']){
  //     return MaterialButton(
  //             onPressed:  (){
  //                showSnackBar('В процессе', context);
  //             } ,
  //             child: Text('В процессе'),
  //             color: Colors.blue,
  //           );
  //   }else {
  //     return MaterialButton(
  //             onPressed:  (){
  //                FireStoreMethods().likeTaskAlmaty(
  //                 widget.snap['commentId'].toString(),
  //                 userData['username'],
  //                 widget.snap['likes'],
  //                 );
  //                 FireStoreMethods().statusTaskAlmaty(widget.snap['commentId'], 'process',widget.snap['status']);
  //             } ,
  //             child: Text('Выполнить'),
  //             color: Colors.grey,
  //           );
  //   }
// }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SlimyCard(
          width: 450,
          topCardHeight: 180,
          
          bottomCardWidget: Container(
            child: Center(child: Text(widget.snap['description'])),
          ),
          topCardWidget: Row(
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
                              text: ' ${widget.snap.data()['text']}',
                            ),
                            TextSpan(
                              text:
                                  ' ${widget.snap['status'].toString().replaceAll("]", "").replaceAll("[", "")} ${widget.snap['likes'].toString().replaceAll("]", "").replaceAll("[", "")}',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat.yMMMd().format(
                            widget.snap.data()['datePublished'].toDate(),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
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
                        FireStoreMethods().likeTaskAlmaty(
                          widget.snap['commentId'].toString(),
                          user.username,
                          widget.snap['likes'],
                        );
        
                        FireStoreMethods().statusTaskAlmaty(
                            widget.snap['commentId'],
                            'В процессе:',
                            widget.snap['status']);
                        statusString_1 = "в процессе: ";
                      },
                      child: Text('Выполнить'),
                      color: Colors.grey,
                    )
                  : widget.snap['status'].contains('В процессе:')
                      ? MaterialButton(
                          onLongPress: () {
                            showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    // <-- SEE HERE
                                    title: const Text('Select Booking Type'),
                                    children: <Widget>[
                                      SimpleDialogOption(
                                        onPressed: () {
                                          if (widget.snap['likes']
                                              .contains(user.username)) {
                                            FireStoreMethods().likeTaskAlmaty(
                                              widget.snap['commentId'].toString(),
                                              user.username,
                                              widget.snap['likes'],
                                            );
                                            FireStoreMethods().statusTaskAlmaty(
                                                widget.snap['commentId'],
                                                'В процессе:',
                                                widget.snap['status']);
                                            statusString_1 = "";
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
                          },
                          onPressed: () {
                            if (widget.snap['likes'].contains(user.username)) {
                              FireStoreMethods().statusTaskAlmaty(
                                  widget.snap['commentId'],
                                  'Выполнено:',
                                  widget.snap['status']);
                              FireStoreMethods().statusTaskAlmaty(
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
                          color: Colors.orange,
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
        ),
      ),
    );
  }
}
