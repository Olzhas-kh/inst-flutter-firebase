import 'package:cloud_firestore/cloud_firestore.dart';

class CityTask {
  final String description;
  final String uid;
  final String username;
  final String taskId;
  final datePublished;
  
  
  final likes;

  const CityTask({
    required this.description,
    required this.uid,
    required this.username,
    required this.taskId,
    required this.datePublished,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "taskId": taskId,
        "uid": uid,
        "username": username,
        "datePublished": datePublished,
        "likes": likes,
      };

  static CityTask fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CityTask(
        description: snapshot['description'],
        taskId: snapshot['taskId'],
        uid: snapshot['uid'],
        username: snapshot['username'],
        datePublished: snapshot['datePublished'],
        likes: snapshot['likes']);
  }
}
