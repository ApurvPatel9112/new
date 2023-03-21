import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Choice {
  const Choice({required this.title, required this.icon, required this.colors});
  final String title;
  final IconData icon;
  final Color colors;
}

const List<Choice> choices = const <Choice>[
  const Choice(
    title: 'Vehicle Reminder',
    icon: Icons.directions_car,
    colors: Color.fromARGB(255, 62, 125, 156),
  ),
  const Choice(
    title: 'Insurance Reminder',
    icon: Icons.assignment,
    colors: Color.fromARGB(255, 62, 125, 156),
  ),
];
