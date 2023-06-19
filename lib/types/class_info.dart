import 'package:school_networking_project/types/post_info.dart';
import 'package:school_networking_project/types/user_skeleton.dart';

class ClassInfo {
  String? id;
  String? title;
  List<UserSkeleton?>? participants;
  List<PostInfo?>? posts;

  ClassInfo({
    required this.id,
    required this.title,
    required this.participants,
    required this.posts,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    dynamic participantsObject = json["participants"];

    List<UserSkeleton> participants = List.empty(growable: true);

    if (participantsObject != null) {
      for (var object in participantsObject) {
        UserSkeleton user = UserSkeleton.fromJson(object);

        participants.add(user);
      }
    }

    List<PostInfo> posts = List.empty(growable: true);

    if (json["posts"] != null) {
      for (var object in json["posts"]) {
        PostInfo postInfo = PostInfo.fromJson(object);

        posts.add(postInfo);
      }
    }

    posts.sort();

    return ClassInfo(
      id: json["id"] as String,
      title: json["name"] as String,
      participants: participants,
      posts: posts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
    };
  }
}
