import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_networking_project/components/comment_widget.dart';
import 'package:school_networking_project/firebase/data_service.dart';
import 'package:school_networking_project/types/comments_info.dart';
import 'package:school_networking_project/types/post_info.dart';

class IndividualPostScreen extends StatefulWidget {
  const IndividualPostScreen({
    super.key,
    required this.postInfo,
    required this.client,
  });

  final PostInfo postInfo;
  final ValueNotifier<GraphQLClient> client;

  @override
  State<IndividualPostScreen> createState() => _IndividualPostScreenState();
}

class _IndividualPostScreenState extends State<IndividualPostScreen> {
  final TextEditingController _textEditingControllerComment =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.postInfo.title!,
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                textAlign: TextAlign.center,
                widget.postInfo.description!,
                style: GoogleFonts.abel(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.postInfo.comments!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CommentWidget(
                    commentInfo: widget.postInfo.comments![index]!,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              height: 0,
              thickness: 3,
              color: Theme.of(context).primaryColor,
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 3,
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        controller: _textEditingControllerComment,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          hintText: "Add a comment...",
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    endIndent: 5,
                    indent: 4,
                    thickness: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      onPressed: () async {
                        if (_textEditingControllerComment.value !=
                            TextEditingValue.empty) {
                          CommentInfo commentInfo =
                              await DataService().createComment(
                            widget.client,
                            {
                              "userID": DataService.user!.id!,
                              "postID": widget.postInfo.id,
                              "text": _textEditingControllerComment.value.text,
                              "creationTime": DateTime.now().toIso8601String(),
                            },
                          );

                          setState(() {
                            widget.postInfo.comments!.add(commentInfo);

                            _textEditingControllerComment.value =
                                TextEditingValue.empty;
                          });
                        } else {
                          const snackbar = SnackBar(
                            content: Text('Please Write A Comment'),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                      },
                      icon: Icon(
                        size: 20,
                        FontAwesomeIcons.paperPlane,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              thickness: 3,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
