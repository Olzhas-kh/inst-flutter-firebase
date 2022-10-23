import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final String jobPosition;
  final String city;
  final String telephone;
  final String adress;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.jobPosition,
    required this.city,
    required this.telephone,
    required this.adress,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "job_postion": jobPosition,
        "city": city,
        "telephone": telephone,
        "adress": adress,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      jobPosition: snapshot['job_postion'],
      city: snapshot['city'],
      telephone: snapshot['telephone'],
      adress: snapshot['adress'],
    );
  }
}
