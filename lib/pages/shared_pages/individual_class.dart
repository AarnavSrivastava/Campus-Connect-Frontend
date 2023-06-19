import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_networking_project/components/post_widget.dart';
import 'package:school_networking_project/pages/create_post.dart';
import 'package:school_networking_project/types/class_info.dart';

import 'individual_post.dart';

class IndividualClassScreen extends StatefulWidget {
  const IndividualClassScreen({
    super.key,
    required this.classInfo,
    required this.client,
  });

  final ClassInfo classInfo;
  final ValueNotifier<GraphQLClient> client;

  @override
  State<IndividualClassScreen> createState() => _IndividualClassScreenState();
}

class _IndividualClassScreenState extends State<IndividualClassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.classInfo.title!),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              width: double.infinity,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                width: 125.0,
                height: 40.0,
                child: TextButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreatePost(
                          classInfo: widget.classInfo,
                          client: widget.client,
                        ),
                      ),
                    );

                    setState(() {});
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        "Add Post",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            (widget.classInfo.posts!.isNotEmpty)
                ? Container(
                    margin: const EdgeInsets.all(10),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.classInfo.posts!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (builder) {
                                  return IndividualPostScreen(
                                    client: widget.client,
                                    postInfo: widget.classInfo.posts![index]!,
                                  );
                                },
                              ),
                            );
                          },
                          child: PostWidget(
                            postInfo: widget.classInfo.posts![index]!,
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.filePen,
                              size: 60,
                              color: Theme.of(context).disabledColor,
                            ),
                            Container(
                              margin: const EdgeInsets.all(20),
                              child: Text(
                                "There are no posts currently...",
                                style: GoogleFonts.abel(
                                  fontSize: 24,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
