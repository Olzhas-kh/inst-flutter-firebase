class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List follewers;
  final List follewing;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.follewers,
    required this.follewing,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": follewers,
        "following": follewing,
      };
}
