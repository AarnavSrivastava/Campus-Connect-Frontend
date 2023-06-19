class UserSkeleton {
  String? name;
  String? email;
  String? photoUrl;

  UserSkeleton({
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory UserSkeleton.fromJson(Map<String, dynamic> json) {
    UserSkeleton user = UserSkeleton(
      name: json["name"] as String,
      email: json["email"] as String,
      photoUrl: json["photo_url"] as String,
    );

    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "photoUrl": photoUrl,
    };
  }
}
