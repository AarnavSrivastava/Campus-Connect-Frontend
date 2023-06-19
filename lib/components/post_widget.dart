import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_networking_project/types/post_info.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    super.key,
    required this.postInfo,
  });

  final PostInfo postInfo;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.left,
                  widget.postInfo.title!,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.postInfo.owner!.photoUrl!,
                      ),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.left,
                    widget.postInfo.description!,
                  ),
                  Text(
                    DateFormat(
                      'MM/dd/yy -',
                    ).add_jm().format(
                          widget.postInfo.creationTime!.toLocal(),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
