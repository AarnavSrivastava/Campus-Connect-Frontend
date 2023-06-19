import 'package:school_networking_project/types/school_info.dart';

class UserInfo {
  String? id;
  String? name;
  String? email;
  String? photoUrl;
  bool? exists;
  SchoolInfo? schoolInfo;

  UserInfo({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.schoolInfo,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    SchoolInfo? schoolInfo;

    if (json["school"] != null) {
      schoolInfo = SchoolInfo.fromJson(json["school"]);
    } else {
      schoolInfo = null;
    }

    UserInfo user = UserInfo(
      name: json["name"] as String,
      email: json["email"] as String,
      photoUrl: json["photo_url"] as String,
      schoolInfo: schoolInfo,
    );

    user.id = json["id"] as String;

    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "photoUrl": photoUrl,
    };
  }

  Stream watchExists<bool>() async* {
    yield exists;
  }
}
