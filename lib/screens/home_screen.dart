import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:create_reminder/screens/vehicle/reminder_details.dart';
import 'package:create_reminder/services/notification_service.dart';
import 'package:create_reminder/data/sql_helper.dart';
import 'package:create_reminder/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/choice.dart';
import 'insurance/insurance_list.dart';

class Home extends StatefulWidget {
  //user id
  int? id;
  Home({this.id});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? index;
  int? vehiclelen;
  int? insurancelen;
  List<Map<String, dynamic>> _Vehiclelist = [];
  List<Map<String, dynamic>> _insuarncelist = [];

  void initState() {
    index = widget.id;
    getAllVehicle();
    getAllInsurances();
    super.initState();
  }

  void getAllInsurances() async {
    final data = await SQLHelper.getAllInsurancebyLoginid(widget.id!);
    setState(() {
      _insuarncelist = data;
      if (_insuarncelist.length == null) {
        insurancelen = 00;
      } else {
        insurancelen = _insuarncelist.length;
      }
    });
  }

  void getAllVehicle() async {
    final data = await SQLHelper.getAllVehiclesbyLoginid(widget.id!);

    setState(() {
      _Vehiclelist = data;
      print(_Vehiclelist.length);
      if (_Vehiclelist.length == null) {
        vehiclelen = 00;
      } else {
        vehiclelen = _Vehiclelist.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            showCloseIcon: true,
            desc: "Exit",
            btnCancelOnPress: () async {},
            btnOkOnPress: () async {
              exit(0);
            }).show();
        return shouldPop!;
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("DashBoard"),
            actions: <Widget>[
              IconButton(
                  onPressed: () async {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        showCloseIcon: true,
                        desc: "Logout",
                        btnCancelOnPress: () async {},
                        btnOkOnPress: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          notificationService().clearAllNoification();
                          final success = await prefs.remove('isLoggedIn');
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        }).show();
                  },
                  icon: Icon(Icons.login_outlined)),
            ],
            backgroundColor: Color(0xfff007dfe),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/images/userprofile.png"),
              ),
            ),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 8.0,
                  children: List.generate(choices.length, (index) {
                    final Choice choice = choices[index];
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          print(choice.title);
                          if (choice.title == 'Vehicle Reminder') {
                            navigateforlengthofvehicle(context);
                          } else if (choice.title == 'Insurance Reminder') {
                            navigateforlengthofinsurence(context);
                          }
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 4,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              color: choice.colors,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          choice.icon,
                                          size: 60,
                                          color: choice.colors,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          choice.title,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                        alignment: Alignment.topRight,
                                        child:
                                            choice.title == "Vehicle Reminder"
                                                ? Text(
                                                    "$vehiclelen",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    '$insurancelen',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    );
                  })),
            ),
          )),
    );
  }

  void navigateforlengthofvehicle(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReminderDetails(
            userid: widget.id,
          ),
        ));
    if (!mounted) return;
    getAllVehicle();
  }

  void navigateforlengthofinsurence(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InsuranceDetails(
            id: widget.id,
          ),
        ));
    if (!mounted) return;
    getAllInsurances();
  }
}
