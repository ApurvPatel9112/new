import 'package:flutter/material.dart';

String? emailValidator(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);

  if (value!.isEmpty) {
    return 'Please this field must be filled';
  } else if (!regex.hasMatch(value)) {
    return 'Please enter valid email';
  }
  return null;
}

// Validation for Number Plate
String? numberplateValidator(String? value) {
  String pattern = r'^[A-Z]{2}\s[0-9]{2}\s[A-Z]{2}\s[0-9]{4}$';
  RegExp regex = new RegExp(pattern);

  if (value!.isEmpty) {
    return 'Please this field must be filled';
  } else if (value.length < 10) {
    return 'Please enter number Valid Number';
  }
  return null;
}

String? textformfieldvalidator(String? value) {
  if (value!.isEmpty) {
    return 'Please this field must be filled';
  }
  return null;
}

// Validation for vehicle year model
String? yeartextformfield(String? value) {
  if (value!.isEmpty) {
    return 'Please this field must be filled';
  } else if (value.length < 4) {
    return 'Please enter correct value';
  }
  return null;
}

String? datevalidator(String? value) {
  if (value!.isEmpty) {
    return 'Please select date';
  }
  return null;
}

String? durationvalidator(String? value) {
  String pattern = "^([1-9]|[1-4][0-9]|50)\$";
  RegExp regex = new RegExp(pattern);

  if (value!.isEmpty) {
    return 'Please this field must be filled';
  } else if (!regex.hasMatch(value)) {
    return 'Please enter valid number';
  }
  return null;
}

String? membersvalidator(String? value) {
  String pattern = "^(0?[1-9]|[1-9][0-9])\$";
  RegExp regex = new RegExp(pattern);

  if (value!.isEmpty) {
    return 'Please this field must be filled';
  } else if (!regex.hasMatch(value)) {
    return 'Please enter valid number';
  }
  return null;
}

String? passwordvalidator(String? value) {
  bool passwordValid = RegExp(
          r"^[a-zA-z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-z0-9]+\.[a-zA-Z0-9]+")
      .hasMatch(value!);
  if (value.isEmpty) {
    return "Enter Passsword";
  } else if (value.length < 8) {
    return 'Pass must be at least 8 Characters.';
  }
}
