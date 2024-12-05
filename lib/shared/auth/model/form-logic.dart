import 'package:flutter/material.dart';

enum FieldErrorState { initial, invalid, valid }

class FieldData {
  TextEditingController textEditingController;
  FocusNode focusNode;
  bool isFocused;
  bool isDirty;
  FieldErrorState hasError;
  String? errorMessage;

  FieldData(
      {required this.textEditingController,
        required this.focusNode,
        required this.isFocused,
        required this.isDirty,
        required this.errorMessage,
        required this.hasError});
}