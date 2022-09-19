import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inst_fire/models/user.dart' as model;
import '../../providers/user_provider.dart';
import '../../resources/firestore_methods.dart';
import '../../utils/utils.dart';
import '../../widgets/comment_card.dart';



class AlmatyCity extends StatefulWidget {
  
  const AlmatyCity({super.key,required});

  @override
  State<AlmatyCity> createState() => _AlmatyCityState();
}

class _AlmatyCityState extends State<AlmatyCity> {
  
  
    
      
        get mobileBackgroundColor => null;

  void _addTask(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: titleDesAddScreen()
              ),
            ));
  }

  
  @override
  Widget build(BuildContext context) {
    

    return 


    Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Tasks',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('almaty')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
              tooltip: 'Add Task',
              child: const Icon(Icons.add),
      ),
      // text input
      
    );
  }
}

class titleDesAddScreen extends StatefulWidget {


  const titleDesAddScreen({
    super.key,
    
  });

  
  @override
  State<titleDesAddScreen> createState() => _titleDesAddScreenState();
}

class _titleDesAddScreenState extends State<titleDesAddScreen> {

  
  
TextEditingController descriptionController = TextEditingController();
 
  final TextEditingController titleController =
      TextEditingController();


void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreMethods().almaty(
        titleController.text,
        descriptionController.text,
        uid,
        name,
        profilePic,
        
      );

      if (res != 'success') {
        showSnackBar(res, context);
      }
      setState(() {
        titleController.text = "";
        descriptionController.text = "";
      });
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Add Task',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: TextField(
              autofocus: true,
              controller: titleController,
              decoration: InputDecoration(
                label: Text('Title'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          TextField(
            autofocus: true,
            controller:descriptionController,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              label: Text('Description'),
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('cancel'),
              ),
              InkWell(
                onTap: () => postComment(
                  user.uid,
                  user.username,
                  user.photoUrl,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
              
            ],
          ),
        ],
      ),
    );
  }
}