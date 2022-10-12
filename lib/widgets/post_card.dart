import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:inst_fire/models/user.dart' as model;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../screens/commets_screen.dart';
import '../utils/colours.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import 'like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  var userData = {};

  bool isLoading = false;
  String uid = '';
  int commentLen = 0;
  int viewsLen = 0;
  bool isLikeAnimating = false;
  bool isViewed = false;
  List likeUser = [];
  @override
  void initState() {
    super.initState();
    fetchCommentLen();

    getData();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      QuerySnapshot snap2 = await FirebaseFirestore.instance
          .collection('posts')
          .where('likes')
          .get();
      commentLen = snap.docs.length;
      viewsLen = snap2.docs.length;
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
    setState(() {});
  }

  getData() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      final User user = auth.currentUser!;
      uid = user.uid;
      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      userData = userSnap.data()!;

      FireStoreMethods().likePost(
        widget.snap['postId'].toString(),
        userData['username'].toString(),
        widget.snap['likes'],
      );
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

// Text(widget.snap['likes'][0].toString().replaceAll("]","").replaceAll("[", ""),),
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        border: Border.all(
          color: primaryColor,
        ),
        color: primaryColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'].toString(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.snap['username'].toString(),
                          style: const TextStyle(
                            color: blackBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'].toString() == user.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      'Delete',
                                    ]
                                        .map(
                                          (e) => InkWell(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Text(e),
                                              ),
                                              onTap: () {
                                                deletePost(
                                                  widget.snap['postId']
                                                      .toString(),
                                                );
                                                // remove the dialog box
                                                Navigator.of(context).pop();
                                              }),
                                        )
                                        .toList()),
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: blackBlue,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          // IMAGE SECTION OF THE POST
          GestureDetector(
            onDoubleTap: () {
              FireStoreMethods().likePost(
                widget.snap['postId'].toString(),
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          // LIKE, COMMENT SECTION OF THE POST
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: blackBlue,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          // <-- SEE HERE
                          title: const Text('Посмотрели: '),
                          backgroundColor: maroon,
                          content: SizedBox(
                            height: 200,
                            width: double.maxFinite,
                            child: ListView.builder(
                                itemCount: widget.snap['likes'].length,
                                itemBuilder: (BuildContext context, index) {
                                  return SingleChildScrollView(
                                    child: Text(
                                      widget.snap['likes'][index]
                                          .toString()
                                          .replaceAll("]", "")
                                          .replaceAll("[", ""),
                                    ),
                                  );
                                }),
                          ),
                        );
                      });
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.comment_outlined,
                  color: blackBlue,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      postId: widget.snap['postId'].toString(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['likes'].length} просмотров',
                      style: TextStyle(color: blackBlue),
                    )),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: blackBlue),
                      children: [
                        TextSpan(
                          text: widget.snap['username'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    child: Text(
                      'Смотреть все $commentLen комментарии',
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        postId: widget.snap['postId'].toString(),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  // Future<void> _showSimpleDialog() async {
  //   await showDialog<void>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           // <-- SEE HERE
  //           title: const Text('Посмотрели: '),
  //           content:
  //               SizedBox(
  //                 width: double.maxFinite,
  //                 child:
  //               ListView.builder(
  //                 itemCount: viewsLen,
  //                 itemBuilder: (BuildContext context,index){
  //                   return  Text("asdad  $index");

  //               }),
  //             ),
  //         );
  //       }
  //       );
  // }
}
