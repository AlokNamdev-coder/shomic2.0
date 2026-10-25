import 'package:flutter/material.dart';

Future<void> selectDate(BuildContext context,TextEditingController dobController) async {

  final DateTime? pickedDate = await showDatePicker(
    barrierColor: Colors.black,
    context: context,

    initialDate: DateTime(2004, 9, 3),

    firstDate: DateTime(1900),

    lastDate: DateTime.now(),

    helpText: "Select your birth date",

    cancelText: "Cancel",

    confirmText: "Done",
    initialDatePickerMode: DatePickerMode.year,
  );

  if (pickedDate != null) {

    dobController.text =
    "${pickedDate.day.toString().padLeft(2, '0')}/"
        "${pickedDate.month.toString().padLeft(2, '0')}/"
        "${pickedDate.year}";
  }
}