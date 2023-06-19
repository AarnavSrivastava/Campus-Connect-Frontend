import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_networking_project/components/class_widget.dart';
import 'package:school_networking_project/components/search_input.dart';
import 'package:school_networking_project/firebase/data_service.dart';
import 'package:school_networking_project/types/class_info.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.client,
  });

  final ValueNotifier<GraphQLClient> client;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  late Future<List<ClassInfo>> classes;
  List<ClassInfo> searchedClasses = List.empty(growable: true);
  List<ClassInfo> allClasses = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    classes = DataService().getClassesSchool(
      widget.client,
      {
        "schoolID": DataService.user!.schoolInfo!.id,
        "userID": DataService.user!.id,
      },
    );
  }

  void onChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        searchedClasses = allClasses;
      });
    } else {
      setState(() {
        searchedClasses = allClasses
            .where(
              (classInfo) => classInfo.title!.toLowerCase().contains(
                    value.toLowerCase(),
                  ),
            )
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          SearchInput(
            textController: _textEditingController,
            hintText: "Search for classes...",
            onChanged: onChanged,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: FutureBuilder<List<ClassInfo>>(
              future: classes,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("err");
                } else if (snapshot.hasData) {
                  allClasses = snapshot.data!;

                  if (_textEditingController.value == TextEditingValue.empty) {
                    searchedClasses = allClasses;
                  }

                  return ListView.builder(
                    itemCount: searchedClasses.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: ClassWidget(
                              classInfo: searchedClasses[index],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await DataService().connectUserToClass(
                                widget.client,
                                {
                                  "classID": searchedClasses[index].id,
                                  "userID": DataService.user!.id!,
                                },
                              );

                              setState(() {
                                classes = DataService().getClassesSchool(
                                  widget.client,
                                  {
                                    "schoolID":
                                        DataService.user!.schoolInfo!.id,
                                    "userID": DataService.user!.id,
                                  },
                                );

                                _textEditingController.value =
                                    TextEditingValue.empty;
                              });
                            },
                            icon: const Icon(
                              Icons.add,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
