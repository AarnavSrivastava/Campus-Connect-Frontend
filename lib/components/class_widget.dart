import 'package:flutter/material.dart';
import 'package:school_networking_project/types/user_skeleton.dart';

import '../types/class_info.dart';

class ClassWidget extends StatefulWidget {
  ClassWidget({
    super.key,
    required this.classInfo,
    this.photoUrls,
  });

  final ClassInfo classInfo;

  List<UserSkeleton?>? photoUrls;

  @override
  State<ClassWidget> createState() => _ClassWidgetState();
}

class _ClassWidgetState extends State<ClassWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                textAlign: (widget.photoUrls != null)
                    ? TextAlign.left
                    : TextAlign.center,
                widget.classInfo.title!,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (widget.photoUrls != null)
              Container(
                margin: const EdgeInsets.only(
                  top: 20,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 30.0,
                      width: 90.0,
                      child: Stack(
                        children: List.generate(
                          widget.photoUrls!.length <= 3
                              ? widget.photoUrls!.length
                              : 3,
                          (index) {
                            return Positioned(
                              left: index * 30,
                              child: Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      widget.photoUrls![index]!.photoUrl!,
                                    ),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.photoUrls!.length > 3,
                      child: Text(
                        "+${widget.photoUrls!.length - 3}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(),
          ],
        ),
      ),
    );
  }
}
