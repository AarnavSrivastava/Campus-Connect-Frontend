import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  const NameField({
    Key? key,
    required this.inputController,
    required this.hintText,
    required this.maxLines,
  }) : super(key: key);

  final TextEditingController inputController;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      controller: inputController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
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
