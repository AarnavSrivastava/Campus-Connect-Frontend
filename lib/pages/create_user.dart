import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_networking_project/components/class_widget.dart';
import 'package:school_networking_project/components/name_field.dart';
import 'package:school_networking_project/components/school_drawer.dart';
import 'package:school_networking_project/components/search_input.dart';
import 'package:school_networking_project/firebase/data_service.dart';
import 'package:school_networking_project/types/class_info.dart';
import 'package:school_networking_project/types/school_info.dart';

// ignore: must_be_immutable
class CreateUser extends StatefulWidget {
  CreateUser({
    super.key,
    required this.client,
    required this.callback,
  });

  final ValueNotifier<GraphQLClient> client;

  Function callback;

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final TextEditingController _textEditingControllerSchool =
      TextEditingController();
  final TextEditingController _textEditingControllerClasses =
      TextEditingController();

  final TextEditingController _textEditingControllerSchoolName =
      TextEditingController();
  final TextEditingController _textEditingControllerClassName =
      TextEditingController();

  List<bool> selectedClasses = List.empty();
  List<ClassInfo> classes = List.empty();
  List<ClassInfo> searchedClasses = List.empty();

  late Future<List<SchoolInfo>> schools;

  int selectedIndex = 0;

  List<SchoolInfo> loadedSchools = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    schools = DataService().getSchools(
      widget.client,
    );

    searchedClasses = classes;
  }

  void callback(int index) {
    setState(() {
      _textEditingControllerSchool.value = _textEditingControllerSchool.value;

      selectedIndex = index;
      classes = loadedSchools[index].classes;

      selectedClasses = List.filled(
        classes.length,
        false,
        growable: true,
      );
    });
  }

  void onChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        searchedClasses = classes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            top: 50,
          ),
          child: Column(
            children: [
              Text(
                "Welcome to CampusConnect!",
                textAlign: TextAlign.center,
                style: GoogleFonts.abel(
                  fontSize: 48,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 50,
                ),
                child: FutureBuilder<List<SchoolInfo>>(
                  future: schools,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.hasData) {
                      loadedSchools = snapshot.data!;
                      return SchoolDrawer(
                        textEditingController: _textEditingControllerSchool,
                        callback: callback,
                        schools: snapshot.data!,
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              Container(
                child: (_textEditingControllerSchool.value.text == "Other")
                    ? Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(
                              50,
                              0,
                              50,
                              10,
                            ),
                            child: NameField(
                              maxLines: 1,
                              inputController: _textEditingControllerSchoolName,
                              hintText: "What's the Name of Your School?",
                            ),
                          ),
                          const Divider(
                            thickness: 3,
                            indent: 20,
                            endIndent: 20,
                          ),
                        ],
                      )
                    : const Divider(
                        thickness: 3,
                        indent: 20,
                        endIndent: 20,
                      ),
              ),
              Column(
                children: (_textEditingControllerSchool.value !=
                        TextEditingValue.empty)
                    ? [
                        Text(
                          "What classes are you taking?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.abel(
                            fontSize: 28,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 50,
                          ),
                          child: SearchInput(
                            hintText: "Search for classes...",
                            textController: _textEditingControllerClasses,
                            onChanged: onChanged,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: double.infinity,
                          child: Container(
                            margin:
                                const EdgeInsets.fromLTRB(0, 10.0, 50.0, 20.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            width: 125.0,
                            height: 40.0,
                            child: TextButton(
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        NameField(
                                          maxLines: 1,
                                          inputController:
                                              _textEditingControllerClassName,
                                          hintText: "Class name...",
                                        ),
                                        const SizedBox(height: 15),
                                        TextButton(
                                          onPressed: () async {
                                            if (_textEditingControllerClassName
                                                    .value.text !=
                                                "") {
                                              final result = await DataService()
                                                  .createClass(
                                                widget.client,
                                                {
                                                  "className":
                                                      _textEditingControllerClassName
                                                          .value.text,
                                                  "schoolID": loadedSchools[
                                                          selectedIndex]
                                                      .id,
                                                },
                                              );

                                              setState(() {
                                                classes.add(result);
                                                selectedClasses.add(false);
                                              });

                                              Navigator.pop(context);
                                            } else {
                                              const snackbar = SnackBar(
                                                content: Text(
                                                    'Please Input A Class Name'),
                                              );

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackbar);
                                            }
                                          },
                                          child: const Text('Confirm'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Add Class",
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
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 70),
                          height: 300,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: classes.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: ClassWidget(
                                      classInfo: classes[index],
                                    ),
                                  ),
                                  Checkbox(
                                    value: selectedClasses[index],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          selectedClasses[index] = value;
                                        });
                                      }
                                    },
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        const Divider(
                          thickness: 3,
                          indent: 20,
                          endIndent: 20,
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Center(
                            child: IconButton(
                              onPressed: () async {
                                for (int i = 0; i < classes.length; i++) {
                                  if (selectedClasses[i]) {
                                    await DataService().connectUserToClass(
                                      widget.client,
                                      {
                                        "classID": classes[i].id,
                                        "userID": DataService.user!.id,
                                      },
                                    );
                                  }
                                }

                                SchoolInfo? school;

                                if (_textEditingControllerSchool.value.text ==
                                    "Other") {
                                  school = await DataService().createSchool(
                                    widget.client,
                                    {
                                      "schoolName":
                                          _textEditingControllerSchoolName
                                              .value.text,
                                    },
                                  );
                                } else {
                                  school = loadedSchools[selectedIndex];
                                }

                                await DataService().connectUserToSchool(
                                  widget.client,
                                  {
                                    "schoolID": school.id,
                                    "userID": DataService.user!.id!,
                                  },
                                );

                                DataService.user!.exists = true;

                                widget.callback(DataService.user);
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
                        const Divider(
                          thickness: 3,
                          indent: 20,
                          endIndent: 20,
                        ),
                      ]
                    : [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
