import 'package:school_networking_project/types/comments_info.dart';
import 'package:school_networking_project/types/user_skeleton.dart';

class PostInfo implements Comparable<PostInfo> {
  String? id;
  String? title;
  List<String?>? fileURLs;
  String? description;
  UserSkeleton? owner;
  List<CommentInfo?>? comments;
  DateTime? creationTime;

  PostInfo({
    required this.id,
    required this.title,
    required this.fileURLs,
    required this.description,
    required this.owner,
    required this.comments,
    required this.creationTime,
  });

  factory PostInfo.fromJson(Map<String, dynamic> json) {
    List<String> files = List.empty(growable: true);
    if (json["files"] != null) {
      for (var file in json["files"]) {
        files.add(file);
      }
    }

    List<CommentInfo> comments = List.empty(growable: true);

    if (json["comments"] != null) {
      for (var object in json["comments"]) {
        CommentInfo commentInfo = CommentInfo.fromJson(object);

        comments.add(commentInfo);
      }
    }

    comments.sort();

    UserSkeleton userInfo = UserSkeleton.fromJson(json["poster"]);

    return PostInfo(
      id: json["id"],
      title: json["title"],
      fileURLs: files,
      description: json["description"],
      owner: userInfo,
      comments: comments,
      creationTime: DateTime.parse(json["creation_time"]),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PostInfo && id == other.id;
  }

  @override
  int get hashCode => creationTime.hashCode;

  @override
  int compareTo(PostInfo other) {
    return creationTime!.compareTo(other.creationTime!);
  }
}
