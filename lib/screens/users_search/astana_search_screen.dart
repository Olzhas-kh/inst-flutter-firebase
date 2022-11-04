import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:inst_fire/screens/profile_other_users.dart';
import 'package:inst_fire/screens/profile_screen.dart';

import '../../utils/colours.dart';
import '../../utils/global_variables.dart';

class AstanaSearchScreen extends StatefulWidget {
  const AstanaSearchScreen({Key? key}) : super(key: key);

  @override
  State<AstanaSearchScreen> createState() => _AstanaSearchScreenState();
}

class _AstanaSearchScreenState extends State<AstanaSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maroon,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration:
                const InputDecoration(labelText: 'Поиск пользователей...'),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              print(_);
            },
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    if ((snapshot.data! as dynamic)
                        .docs[index]['bio']
                        .toString()
                        .contains('astana')) {
                      return Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(color: blackBlue),
                          child: ListTile(
                              onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfileOtherUsers(
                                        uid: (snapshot.data! as dynamic)
                                            .docs[index]['uid'],
                                      ),
                                    ),
                                  ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 3),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.white24))),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['photoUrl'],
                                  ),
                                  radius: 16,
                                ),
                              ),
                              title: Text(
                                (snapshot.data! as dynamic).docs[index]
                                    ['username'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              subtitle: Row(
                                children: <Widget>[
                                  Text(
                                      (snapshot.data! as dynamic).docs[index]
                                          ['job_postion'],
                                      style: TextStyle(color: Colors.white))
                                ],
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.white, size: 30.0)),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Image.network(
                    (snapshot.data! as dynamic).docs[index]['postUrl'],
                    fit: BoxFit.cover,
                  ),
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          webScreenSize
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }
}
