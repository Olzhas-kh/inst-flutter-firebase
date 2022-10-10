import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inst_fire/screens/cities/almaty_city.dart';
import 'package:inst_fire/screens/cities/karagandy_city.dart';
import 'package:inst_fire/screens/cities/kyzylorda_city.dart';
import 'package:inst_fire/screens/cities/nur_sultan_city.dart';
import 'package:inst_fire/screens/cities/shymkent_city.dart';
import 'package:inst_fire/screens/cities_task_card.dart/kyzylorda_card.dart';
import 'package:inst_fire/screens/cities_task_card.dart/shymkent_card.dart';
import 'package:inst_fire/utils/colours.dart';
import 'package:inst_fire/models/user.dart' as model;

import '../utils/utils.dart';

class AddTask extends StatefulWidget {
  const AddTask({
    super.key,
  });

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var userData = {};
  final citList = ["Almaty", "Astana", "Shymkent", "Kyzylorda", "Karaganda"];

  String uid = '';

  @override
  void initState() {
    super.initState();
    getBio();
  }

  getBio() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      final User user = auth.currentUser!;
      uid = user.uid;

      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      userData = userSnap.data()!;
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maroon,
        title: Text(
          "Cities",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: ListView.builder(
        itemCount: citList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: blackBlue),
              child: ListTile(
                  onTap: () => {
                        if (index == 0)
                          {
                            print(userData['bio'].toString()),
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AlmatyCity(),
                              ),
                            ),
                          }
                        else if (index == 1)
                          {
                            if (userData['bio']
                                .toString()
                                .contains('nursultan'))
                              {
                                print(userData['bio'].toString()),
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AstanaCity(),
                                  ),
                                ),
                              }
                            else
                              {
                                print(userData['bio'].toString()),
                                showSnackBar('У вас нету доступа', context),
                              }
                          }
                        else if (index == 2)
                          {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ShymkentCity(),
                              ),
                            ),
                          }
                        else if (index == 3)
                          {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => KyzylordaCity(),
                              ),
                            ),
                          }
                        else if (index == 4)
                          {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => KaragandyCity(),
                              ),
                            ),
                          }
                      },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.white24))),
                    child: CircleAvatar(
                      radius: 16,
                    ),
                  ),
                  title: Text(
                    citList[index].toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                  subtitle: Row(
                    children: <Widget>[
                      Text(citList[index].toString(),
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Colors.white, size: 30.0)),
            ),
          );
        },
      ),
    );
  }
}




//  if (userData['bio'].toString().contains('')) {
//                 print(userData['bio'].toString());
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => AlmatyCity(),
//                   ),
//                 );
//               } else {
//                 print(userData['bio'].toString());
//                 showSnackBar('У вас нету доступа', context);
//               }