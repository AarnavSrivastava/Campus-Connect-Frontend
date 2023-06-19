import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_networking_project/components/post_widget.dart';
import 'package:school_networking_project/firebase/auth_firebase_service.dart';
import 'package:school_networking_project/firebase/data_service.dart';
import 'package:school_networking_project/pages/shared_pages/individual_post.dart';
import 'package:school_networking_project/types/post_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.client,
  });

  final ValueNotifier<GraphQLClient> client;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<PostInfo>> posts;

  @override
  void initState() {
    super.initState();

    posts = DataService().getStudentPosts(
      widget.client,
      {
        "userID": AuthService.user!.uid,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              "Your Recent Posts:",
              style: TextStyle(fontSize: 24),
            ),
            FutureBuilder<List<PostInfo>>(
              future: posts,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("err");
                } else if (snapshot.hasData) {
                  snapshot.data!.sort();

                  return ListView.builder(
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (builder) {
                                return IndividualPostScreen(
                                  client: widget.client,
                                  postInfo: snapshot.data![index],
                                );
                              },
                            ),
                          );
                        },
                        child: PostWidget(
                          postInfo: snapshot.data![index],
                        ),
                      );
                    },
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
