import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_networking_project/graphql/queries.dart';
import '../firebase/auth_firebase_service.dart';
import '../graphql/mutations.dart';
import 'loginscreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text("Loading..."),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        } else if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List> items;

  final HttpLink httpLink = HttpLink("http://localhost:4000/");

  late ValueNotifier<GraphQLClient> client;

  @override
  void initState() {
    super.initState();

    client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(
          partialDataPolicy: PartialDataCachePolicy.acceptForOptimisticData,
        ),
      ),
    );

    items = getTodos(client);
  }

  @override
  Widget build(BuildContext context) {
    String assignment = "";

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("GraphQL!!!!"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
              future: items,
              builder: (buildContext, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error!");
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Mutation(
                          options: MutationOptions(
                            document: mutateDeleteTodos,
                          ),
                          builder: (
                            runMutation,
                            result,
                          ) {
                            return Dismissible(
                              key: ValueKey<dynamic>(
                                snapshot.data![index],
                              ),
                              background: Container(
                                alignment: Alignment.centerLeft,
                                child: const Icon(
                                  Icons.delete,
                                  size: 30.0,
                                ),
                              ),
                              secondaryBackground: Container(
                                alignment: Alignment.centerRight,
                                child: const Icon(
                                  Icons.delete,
                                  size: 30.0,
                                ),
                              ),
                              onDismissed: (direction) async {
                                runMutation(
                                  {
                                    'title': snapshot.data![index]["title"]
                                        .toString(),
                                  },
                                );
                                setState(() {
                                  snapshot.data!.removeAt(index);
                                });
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data![index]["title"].toString(),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    );
                  } else {
                    return const Text("You have no todos");
                  }
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your assignment name',
                ),
                onChanged: (value) => assignment = value,
              ),
            ),
            Mutation(
              options: MutationOptions(
                  document: mutateAddTodo,
                  onCompleted: (dynamic resultData) async {
                    setState(() {
                      items = getTodos(client);
                    });
                  },
                  update: (graphQLDataProxy, queryResult) {}),
              builder: (
                runMutation,
                result,
              ) {
                return IconButton(
                  onPressed: () {
                    if (assignment != "") {
                      runMutation(
                        {
                          'title': assignment,
                        },
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: const Text("Sign out"),
            )
          ],
        ),
      ),
    );
  }
}
