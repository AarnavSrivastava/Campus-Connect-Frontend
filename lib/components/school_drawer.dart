import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:school_networking_project/types/school_info.dart';

class SchoolDrawer extends StatefulWidget {
  const SchoolDrawer({
    super.key,
    required this.textEditingController,
    required this.callback,
    required this.schools,
  });

  final TextEditingController textEditingController;
  final Function callback;
  final List<SchoolInfo> schools;

  @override
  State<SchoolDrawer> createState() => _SchoolDrawerState();
}

class _SchoolDrawerState extends State<SchoolDrawer> {
  late TextEditingController _textEditingController;

  List<SelectedListItem> data = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    _textEditingController = widget.textEditingController;

    for (SchoolInfo schoolInfo in widget.schools) {
      data.add(
        SelectedListItem(
          name: schoolInfo.title!,
        ),
      );
    }

    data.add(
      SelectedListItem(name: "Other"),
    );
  }

  void onTextFieldTap() {
    DropDownState(
      DropDown(
        isDismissible: true,
        bottomSheetTitle: const Text(
          "Schools",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: data,
        selectedItems: (List<dynamic> selectedList) {
          List<String> list = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              list.add(item.name);
            }
          }

          setState(() {
            _textEditingController.value = TextEditingValue(text: list[0]);
          });

          int index = 0;

          for (int i = 0; i < widget.schools.length; i++) {
            if (widget.schools[i].title == list[0]) {
              index = i;
            }
          }

          widget.callback(index);
        },
      ),
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: onTextFieldTap,
      controller: _textEditingController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        hintText: "What school do you go to?",
        hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).focusColor, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColorDark, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }
}
