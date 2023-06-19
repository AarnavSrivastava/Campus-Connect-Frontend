import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_networking_project/components/name_field.dart';
import 'package:school_networking_project/firebase/data_service.dart';
import 'package:school_networking_project/types/class_info.dart';
import 'package:school_networking_project/types/post_info.dart';
import 'package:school_networking_project/types/user_skeleton.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({
    super.key,
    required this.classInfo,
    required this.client,
  });

  final ClassInfo classInfo;
  final ValueNotifier<GraphQLClient> client;

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _textEditingControllerTitle =
      TextEditingController();
  final TextEditingController _textEditingControllerDescription =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: Text(
          "Make a post in ${widget.classInfo.title}!",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
          maxLines: 5,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: Column(
            children: [
              NameField(
                maxLines: 1,
                inputController: _textEditingControllerTitle,
                hintText: "Give your post a title...",
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: NameField(
                  maxLines: 10,
                  inputController: _textEditingControllerDescription,
                  hintText: "Give your post a description...",
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        if (_textEditingControllerDescription.value ==
                                TextEditingValue.empty ||
                            _textEditingControllerTitle.value ==
                                TextEditingValue.empty) {
                          const snackbar = SnackBar(
                            content: Text('Please fill all fields'),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        } else {
                          PostInfo postInfo = PostInfo(
                            id: null,
                            fileURLs: [],
                            title: _textEditingControllerTitle.text,
                            comments: [],
                            description: _textEditingControllerDescription.text,
                            owner: UserSkeleton(
                              email: DataService.user!.email,
                              photoUrl: DataService.user!.photoUrl,
                              name: DataService.user!.name,
                            ),
                            creationTime: DateTime.now(),
                          );

                          setState(() {
                            widget.classInfo.posts!.add(postInfo);
                          });

                          //$title: String!, $userID: ID!, $classID: ID!, $files: [String!]!, $description: String!, $creationTime: String!

                          await DataService().createPost(
                            widget.client,
                            {
                              "title": postInfo.title,
                              "userID": DataService.user!.id,
                              "classID": widget.classInfo.id,
                              "files": postInfo.fileURLs,
                              "description": postInfo.description,
                              "creationTime":
                                  postInfo.creationTime!.toIso8601String(),
                            },
                          );

                          Navigator.pop(context);
                        }
                      },
                      icon: const Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
