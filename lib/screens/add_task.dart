import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inst_fire/screens/cities/almaty_city.dart';
import 'package:inst_fire/screens/cities/nur_sultan_city.dart';
import 'package:inst_fire/utils/colours.dart';
import 'package:inst_fire/models/user.dart' as model;

import '../utils/utils.dart';



class AddTask extends StatefulWidget {
  
  const AddTask({super.key, });

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var userData = {};

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
    return Center(
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              
                print(userData['bio'].toString());
                Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AlmatyCity(),
              ),
            );
             
              
             
              
            },
            child: Text(
              'Almaty',
              style: TextStyle(color: primaryColor),
            ),
          ),
          TextButton(
            onPressed: ()  {
              if(userData['bio'].toString().contains('nursultan')){
                print(userData['bio'].toString());
                Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NursultanCity(),
              ),
            );
              }else{
                print(userData['bio'].toString());
                showSnackBar('Вы не можете зайти так как вы не являтесь',context );
              }
             
              
            },
            child: Text(
              'Nursultan',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
