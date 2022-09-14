import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inst_fire/models/city_task.dart';
import 'package:inst_fire/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

 

 // Almaty
  Future<String> almaty( String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String taskId = const Uuid().v1();
        _firestore
            .collection('almaty')
            .doc(taskId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': taskId,
          'datePublished': DateTime.now(),
          'likes': [],
          
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<String> likeTaskAlmaty(String commentId, String username, List likes) async {
    String res = "Some error occurred";
    try {
    
      if (likes.contains(username)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('almaty').doc(commentId).update({
          'likes': FieldValue.arrayRemove([username])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('almaty').doc(commentId).update({
          'likes': FieldValue.arrayUnion([username])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  
// Almaty
  Future<String> nursultan( String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String taskId = const Uuid().v1();
        _firestore
            .collection('nursultan')
            .doc(taskId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': taskId,
          'datePublished': DateTime.now(),
          'likes': [],
          
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<String> checkTaskNursultan(String commentId, String username, List likes) async {
    String res = "Some error occurred";
    try {
    
      if (likes.contains(username)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('nursultan').doc(commentId).update({
          'likes': FieldValue.arrayRemove([username])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('nursultan').doc(commentId).update({
          'likes': FieldValue.arrayUnion([username])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  // Delete Task Almaty
  Future<String> deleteTaskAlmaty(String commentId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('almaty').doc(commentId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
   // Delete Task Nursultan
  Future<String> deleteTaskNursultan(String commentId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('nursultan').doc(commentId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

 
}