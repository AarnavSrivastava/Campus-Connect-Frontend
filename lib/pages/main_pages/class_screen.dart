import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_networking_project/firebase/auth_firebase_service.dart';
import 'package:school_networking_project/firebase/data_service.dart';
import 'package:school_networking_project/pages/shared_pages/individual_class.dart';
import 'package:school_networking_project/types/class_info.dart';

import '../../components/class_widget.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({
    super.key,
    required this.client,
  });

  final ValueNotifier<GraphQLClient> client;

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  late Future<List<ClassInfo>> classes;
  @override
  void initState() {
    super.initState();

    classes = DataService().getClassesStudent(
      widget.client,
      {
        "id": AuthService.user!.uid,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: double.infinity,
      child: FutureBuilder<List<ClassInfo>>(
        future: classes,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Text("error!!");
          } else if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 200),
                        pageBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) {
                          return IndividualClassScreen(
                            client: widget.client,
                            classInfo: snapshot.data![index],
                          );
                        },
                        transitionsBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: ClassWidget(
                    classInfo: snapshot.data![index],
                    photoUrls: snapshot.data![index].participants!,
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
