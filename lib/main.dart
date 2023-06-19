import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:school_networking_project/routes.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'School Final',
      home: GraphQLApp(),
    );
  }
}

class GraphQLApp extends StatefulWidget {
  const GraphQLApp({
    super.key,
  });

  @override
  State<GraphQLApp> createState() => _GraphQLAppState();
}

class _GraphQLAppState extends State<GraphQLApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("err");
        } else if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            routes: appRoutes,
            theme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 149, 14, 29),
              ),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
