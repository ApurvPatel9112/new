import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../data/sql_helper.dart';
import '../../utils/validator.dart';
import '../../widget/appbarwidget.dart';

class UpdateVehicle extends StatefulWidget {
  int id;

  UpdateVehicle({required this.id});

  @override
  State<UpdateVehicle> createState() => _UpdateVehicleState();
}

class _UpdateVehicleState extends State<UpdateVehicle> {
  final _updatevehicleTypeController = TextEditingController();
  final _updatevehiclenumberController = TextEditingController();
  final _updatevehiclemodelController = TextEditingController();
  final _updatevehiclecompanyController = TextEditingController();
  GlobalKey<FormState> updatevehicleformgloblakey = GlobalKey<FormState>();
  int? updateduseridforvehicle, updatedvehicleid;
  List<Map<String, dynamic>> _getvehicledetaillist = [];
  FToast? fToast;

  var maskFormatter = new MaskTextInputFormatter(
    mask: '####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  void updateID(int vid, int vuid) {
    updatedvehicleid = vid;
    updateduseridforvehicle = vuid;
  }

  List<String> stringList = [];

  void initState() {
    super.initState();
    fToast = FToast();
    fToast?.init(context);
    getSingleVehicleData();
    print(_getvehicledetaillist);
    print(widget.id);
  }

  void getSingleVehicleData() async {
    final data = await SQLHelper.getSingleVehicle(widget.id);
    print('$data');
    setState(() {
      _getvehicledetaillist = data;
      String updatedvid = _getvehicledetaillist[0]['vehicle_vid'].toString();
      String updatedvuid =
          _getvehicledetaillist[0]['vehicle_login_id'].toString();
      String updatedvtype =
          _getvehicledetaillist[0]['vehicle_vtype'].toString();
      String updatedvnum =
          _getvehicledetaillist[0]['vehicle_vnumber'].toString();
      String updatedvcompany =
          _getvehicledetaillist[0]['vehicle_vcompany'].toString();
      String updatedvmodel =
          _getvehicledetaillist[0]['vehicle_vmodel'].toString();
      final int updatedvidinint = int.parse(updatedvid);
      final int updatedvuidinint = int.parse(updatedvuid);

      updateID(updatedvidinint, updatedvuidinint);
      _updatevehicleTypeController.text = updatedvtype;
      _updatevehiclenumberController.text = updatedvnum;
      _updatevehiclecompanyController.text = updatedvcompany;
      _updatevehiclemodelController.text = updatedvmodel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar("Update Vehicle"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: updatevehicleformgloblakey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                    ],
                    validator: textformfieldvalidator,
                    controller: _updatevehicleTypeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Vehicle Name',
                      hintText: 'Enter Vehicle Name',
                    ),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  TextFormField(
                    validator: numberplateValidator,
                    controller: _updatevehiclenumberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Vehicle Number',
                      hintText: 'Enter Vehicle Number i.e.GJ01AA1234',
                    ),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  TextFormField(
                    validator: textformfieldvalidator,
                    controller: _updatevehiclecompanyController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Vehicle Company',
                      hintText: 'Enter Vehicle Company',
                    ),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  TextFormField(
                    inputFormatters: [maskFormatter],
                    keyboardType: TextInputType.number,
                    validator: yeartextformfield,
                    controller: _updatevehiclemodelController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Vehicle Model',
                      hintText: 'Enter Vehicle Model i.e.2001',
                    ),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xfff007dfe),
                          ),
                          child: TextButton(
                              onPressed: () {
                                if (updatevehicleformgloblakey.currentState!
                                    .validate()) {
                                  SQLHelper.updateVehicle(
                                      updatedvehicleid!,
                                      updateduseridforvehicle!,
                                      _updatevehicleTypeController.text,
                                      _updatevehiclenumberController.text,
                                      _updatevehiclemodelController.text,
                                      _updatevehiclecompanyController.text);
                                  Navigator.pop(context, 'Updated');
                                  displayCustomToast();
                                }
                              },
                              child: Text("Update",
                                  style: TextStyle(
                                    color: Color(0xfffefefd),
                                    fontSize: 17,
                                  ))))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  displayCustomToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.green[600],
      ),
      child: const Text(
        "Update Vehicle Successfully",
        style: TextStyle(color: Colors.white),
      ),
    );

    fToast?.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );
  }
}
