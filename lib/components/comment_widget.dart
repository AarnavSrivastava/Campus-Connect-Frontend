import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_networking_project/types/comments_info.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    required this.commentInfo,
  });

  final CommentInfo commentInfo;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 25.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.commentInfo.commenter!.photoUrl!,
                            ),
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'MM/dd/yy -',
                        ).add_jm().format(
                              widget.commentInfo.creationTime!.toLocal(),
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  textAlign: TextAlign.left,
                  widget.commentInfo.text!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
