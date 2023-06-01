import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:school_networking_project/firebase/firebase_options.dart';
import 'package:school_networking_project/routes.dart';

void main() async {
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
    return MaterialApp(
      title: 'School Final',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const GraphQLApp(),
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
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
