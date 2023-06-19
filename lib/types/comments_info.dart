import 'package:school_networking_project/types/user_skeleton.dart';

class CommentInfo implements Comparable<CommentInfo> {
  String? id;
  String? text;
  UserSkeleton? commenter;
  DateTime? creationTime;

  CommentInfo({
    required this.id,
    required this.text,
    required this.commenter,
    required this.creationTime,
  });

  factory CommentInfo.fromJson(Map<String, dynamic> json) {
    return CommentInfo(
      id: json["id"],
      text: json["text"],
      commenter: UserSkeleton.fromJson(json["commenter"]),
      creationTime: DateTime.parse(json["creation_time"]),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CommentInfo && id == other.id;
  }

  @override
  int get hashCode => creationTime.hashCode;

  @override
  int compareTo(CommentInfo other) {
    return creationTime!.compareTo(other.creationTime!);
  }
}
