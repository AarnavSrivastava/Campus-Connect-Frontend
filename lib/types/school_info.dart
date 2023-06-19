import 'package:school_networking_project/types/class_info.dart';
import 'package:school_networking_project/types/user_skeleton.dart';

class SchoolInfo {
  String? id;
  String? title;
  List<ClassInfo> classes;

  SchoolInfo({
    required this.id,
    required this.title,
    required this.classes,
  });

  factory SchoolInfo.fromJson(Map<String, dynamic> json) {
    var classesObjects = json["classes"];

    List<ClassInfo> classes = List.empty(growable: true);

    if (classesObjects != null) {
      for (var object in classesObjects) {
        ClassInfo classInfo = ClassInfo.fromJson(object);

        classes.add(classInfo);
      }
    }

    return SchoolInfo(
      id: json["id"] as String,
      title: json["name"] as String,
      classes: classes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
    };
  }
}
