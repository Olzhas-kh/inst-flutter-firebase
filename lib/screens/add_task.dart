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
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/utils.dart';

class AddTask extends StatefulWidget {
  const AddTask({
    super.key,
  });

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final citList = ["Almaty", "Astana", "Shymkent", "Kyzylorda", "Karaganda"];

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
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: maroon,
        title: Text(
          "Cities",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                        decoration: BoxDecoration(color: blackBlue),
                        child: ListTile(
                          onTap: () => {
                            if (userData['bio'].toString().contains('almaty') ||
                                userData['bio'].toString().contains('author'))
                              {
                                print(userData['bio'].toString()),
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AlmatyCity(),
                                  ),
                                ),
                              }
                            else
                              {
                                print(userData['bio'].toString()),
                                showSnackBar(
                                    'Вам не предоставлен доступ', context),
                              }
                          },
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.white24))),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/city_ala.png'),
                              radius: 16,
                              backgroundColor: primaryColor,
                            ),
                          ),
                          title: Text(
                            'Almaty',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                          subtitle: Row(
                            children: <Widget>[
                              Text('Задачи',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          trailing: Icon(
                              userData['bio'].toString().contains('almaty') ||
                                      userData['bio']
                                          .toString()
                                          .contains('author')
                                  ? Icons.arrow_forward_ios_outlined
                                  : Icons.lock_outline,
                              color: Colors.white,
                              size: 23.0),
                        )),
                  ),
                  Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      decoration: BoxDecoration(color: blackBlue),
                      child: ListTile(
                        onTap: () => {
                          if (userData['bio'].toString().contains('astana') ||
                              userData['bio'].toString().contains('author'))
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
                              showSnackBar(
                                  'Вам не предоставлен доступ', context),
                            }
                        },
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage('assets/city_ast.png'),
                            backgroundColor: primaryColor,
                          ),
                        ),
                        title: Text(
                          'Astana',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        subtitle: Row(
                          children: <Widget>[
                            Text('Задачи',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                        trailing: Icon(
                            userData['bio'].toString().contains('astana') ||
                                    userData['bio']
                                        .toString()
                                        .contains('author')
                                ? Icons.arrow_forward_ios_outlined
                                : Icons.lock_outline,
                            color: Colors.white,
                            size: 23.0),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      decoration: BoxDecoration(color: blackBlue),
                      child: ListTile(
                        onTap: () => {
                          if (userData['bio'].toString().contains('shymkent') ||
                              userData['bio'].toString().contains('author'))
                            {
                              print(userData['bio'].toString()),
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ShymkentCity(),
                                ),
                              ),
                            }
                          else
                            {
                              print(userData['bio'].toString()),
                              showSnackBar(
                                  'Вам не предоставлен доступ', context),
                            }
                        },
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/city_cit.png'),
                            radius: 16,
                            backgroundColor: primaryColor,
                          ),
                        ),
                        title: Text(
                          'Shymkent',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        subtitle: Row(
                          children: <Widget>[
                            Text('Задачи',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                        trailing: Icon(
                            userData['bio'].toString().contains('shymkent') ||
                                    userData['bio']
                                        .toString()
                                        .contains('author')
                                ? Icons.arrow_forward_ios_outlined
                                : Icons.lock_outline,
                            color: Colors.white,
                            size: 23.0),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      decoration: BoxDecoration(color: blackBlue),
                      child: ListTile(
                        onTap: () => {
                          if (userData['bio']
                                  .toString()
                                  .contains('kyzylorda') ||
                              userData['bio'].toString().contains('author'))
                            {
                              print(userData['bio'].toString()),
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => KyzylordaCity(),
                                ),
                              ),
                            }
                          else
                            {
                              print(userData['bio'].toString()),
                              showSnackBar(
                                  'Вам не предоставлен доступ', context),
                            }
                        },
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/city_kzo.png'),
                            backgroundColor: primaryColor,
                            radius: 16,
                          ),
                        ),
                        title: Text(
                          'Kyzylorda',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        subtitle: Row(
                          children: <Widget>[
                            Text('Задачи',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                        trailing: Icon(
                            userData['bio'].toString().contains('kyzylorda') ||
                                    userData['bio']
                                        .toString()
                                        .contains('author')
                                ? Icons.arrow_forward_ios_outlined
                                : Icons.lock_outline,
                            color: Colors.white,
                            size: 23.0),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      decoration: BoxDecoration(color: blackBlue),
                      child: ListTile(
                        onTap: () => {
                          if (userData['bio']
                                  .toString()
                                  .contains('karaganda') ||
                              userData['bio'].toString().contains('author'))
                            {
                              print(userData['bio'].toString()),
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => KaragandyCity(),
                                ),
                              ),
                            }
                          else
                            {
                              print(userData['bio'].toString()),
                              showSnackBar(
                                  'Вам не предоставлен доступ', context),
                            }
                        },
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/city_kgf.png'),
                            backgroundColor: primaryColor,
                            radius: 16,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              'Karaganda',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        subtitle: Row(
                          children: <Widget>[
                            Text('Задачи',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        trailing: Icon(
                            userData['bio'].toString().contains('karaganda') ||
                                    userData['bio']
                                        .toString()
                                        .contains('author')
                                ? Icons.arrow_forward_ios_outlined
                                : Icons.lock_outline,
                            color: Colors.white,
                            size: 23.0),
                      ),
                    ),
                  ),
                ],
              ),
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