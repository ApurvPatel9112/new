import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  String title, titledata;

  CustomRow({required this.title, required this.titledata});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(
          width: 7,
        ),
        Text('$titledata'),
      ],
    );
  }
}
