import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inst_fire/models/user.dart' as model;
import 'package:provider/provider.dart';

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
                onPressed: (){},
                child: const Text('Check users'),
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

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
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
                      text: '${widget.snap['likes']} likes',
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
          Container(
            padding: const EdgeInsets.all(8),
            child: LikeAnimation(
              isAnimating: widget.snap['likes'].contains(user.username),
              smallLike: true,
              child: IconButton(
                icon: widget.snap['likes'].contains(user.username)
                    ? const Icon(
                        Icons.check_box_outlined,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.check_box_outline_blank,
                      ),
                onPressed: () => FireStoreMethods().likeTaskAlmaty(
                  widget.snap['commentId'].toString(),
                  user.username,
                  widget.snap['likes'],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
