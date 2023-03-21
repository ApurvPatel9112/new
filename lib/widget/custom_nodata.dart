import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomNoData extends StatelessWidget {
  String iconaddress, maintext, description;
  CustomNoData(
      {required this.iconaddress,
      required this.maintext,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Lottie.asset('$iconaddress')),
          Text(
            '$maintext',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "$description",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
