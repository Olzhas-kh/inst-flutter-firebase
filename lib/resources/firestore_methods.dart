import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  Future<String> likePost(String postId, String username, List likes) async {
    String res = "Some error occurred";
    try {
      // else we need to add uid to the likes array
      _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([username])
      });

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
  Future<String> almaty(String text, String description, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String taskId = const Uuid().v1();
        _firestore.collection('almaty').doc(taskId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'description': description,
          'commentId': taskId,
          'datePublished': DateTime.now(),
          'likes': [],
          'status': [],
        }, SetOptions(merge: true));
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeTaskAlmaty(
      String commentId, String username, List likes) async {
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

  Future<String> statusTaskAlmaty(
      String commentId, String statuss, List status) async {
    String res = "Some error occurred";
    try {
      if (status.contains(statuss)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('almaty').doc(commentId).update({
          'status': FieldValue.arrayRemove([statuss])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('almaty').doc(commentId).update({
          'status': FieldValue.arrayUnion([statuss])
        });
      }

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// Nursultan
  Future<String> astana(String text, String description, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String taskId = const Uuid().v1();
        _firestore.collection('astana').doc(taskId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'description': description,
          'commentId': taskId,
          'datePublished': DateTime.now(),
          'likes': [],
          'status': [],
        }, SetOptions(merge: true));
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeTaskAstana(
      String commentId, String username, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(username)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('astana').doc(commentId).update({
          'likes': FieldValue.arrayRemove([username])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('astana').doc(commentId).update({
          'likes': FieldValue.arrayUnion([username])
        });
      }

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> statusTaskAstana(
      String commentId, String statuss, List status) async {
    String res = "Some error occurred";
    try {
      if (status.contains(statuss)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('astana').doc(commentId).update({
          'status': FieldValue.arrayRemove([statuss])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('astana').doc(commentId).update({
          'status': FieldValue.arrayUnion([statuss])
        });
      }

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// Shymkent
  Future<String> shymkent(String text, String description, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String taskId = const Uuid().v1();
        _firestore.collection('shymkent').doc(taskId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'description': description,
          'commentId': taskId,
          'datePublished': DateTime.now(),
          'likes': [],
          'status': [],
        }, SetOptions(merge: true));
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeTaskShymkent(
      String commentId, String username, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(username)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('shymkent').doc(commentId).update({
          'likes': FieldValue.arrayRemove([username])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('shymkent').doc(commentId).update({
          'likes': FieldValue.arrayUnion([username])
        });
      }

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> statusTaskShymkent(
      String commentId, String statuss, List status) async {
    String res = "Some error occurred";
    try {
      if (status.contains(statuss)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('shymkent').doc(commentId).update({
          'status': FieldValue.arrayRemove([statuss])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('shymkent').doc(commentId).update({
          'status': FieldValue.arrayUnion([statuss])
        });
      }

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// Kyzylorda
  Future<String> kyzylorda(String text, String description, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String taskId = const Uuid().v1();
        _firestore.collection('kyzylorda').doc(taskId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'description': description,
          'commentId': taskId,
          'datePublished': DateTime.now(),
          'likes': [],
          'status': [],
        }, SetOptions(merge: true));
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeTaskKyzylorda(
      String commentId, String username, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(username)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('kyzylorda').doc(commentId).update({
          'likes': FieldValue.arrayRemove([username])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('kyzylorda').doc(commentId).update({
          'likes': FieldValue.arrayUnion([username])
        });
      }

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> statusTaskKyzylorda(
      String commentId, String statuss, List status) async {
    String res = "Some error occurred";
    try {
      if (status.contains(statuss)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('kyzylorda').doc(commentId).update({
          'status': FieldValue.arrayRemove([statuss])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('kyzylorda').doc(commentId).update({
          'status': FieldValue.arrayUnion([statuss])
        });
      }

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Karagandy
  Future<String> karagandy(String text, String description, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String taskId = const Uuid().v1();
        _firestore.collection('karagandy').doc(taskId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'description': description,
          'commentId': taskId,
          'datePublished': DateTime.now(),
          'likes': [],
          'status': [],
        }, SetOptions(merge: true));
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeTaskKaragandy(
      String commentId, String username, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(username)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('karagandy').doc(commentId).update({
          'likes': FieldValue.arrayRemove([username])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('karagandy').doc(commentId).update({
          'likes': FieldValue.arrayUnion([username])
        });
      }

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> statusTaskKaragandy(
      String commentId, String statuss, List status) async {
    String res = "Some error occurred";
    try {
      if (status.contains(statuss)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('karagandy').doc(commentId).update({
          'status': FieldValue.arrayRemove([statuss])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('karagandy').doc(commentId).update({
          'status': FieldValue.arrayUnion([statuss])
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

  // Delete Task Astana
  Future<String> deleteTaskAstana(String commentId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('astana').doc(commentId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Task Shymkent
  Future<String> deleteTaskShymkent(String commentId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('shymkent').doc(commentId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Task Kyzylorda
  Future<String> deleteTaskKyzylorda(String commentId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('kyzylorda').doc(commentId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Task Karagandy
  Future<String> deleteTaskKaragandy(String commentId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('karagandy').doc(commentId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
