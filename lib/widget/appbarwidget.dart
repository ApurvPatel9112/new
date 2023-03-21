import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final Size preferredSize;
  final String title;

  CustomAppBar(this.title) : preferredSize = Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(0xfffefefd), //change your color here
        ),
        backgroundColor: Color(0xfff007dfe),
        elevation: 0.5,
        title: Text(
          title,
          style: TextStyle(color: Color(0xfffefefd)),
        ));
  }
}
