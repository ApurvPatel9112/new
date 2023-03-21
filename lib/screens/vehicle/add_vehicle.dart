import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../data/sql_helper.dart';
import '../../utils/validator.dart';
import '../../widget/appbarwidget.dart';

class AddVehicle extends StatefulWidget {
  int? uniquevehicleid;
  AddVehicle({this.uniquevehicleid});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  final _vehicleTypeController = TextEditingController();
  final _vehiclenumberController = TextEditingController();
  final _vehiclemodelController = TextEditingController();
  final _vehiclecompanyController = TextEditingController();
  GlobalKey<FormState> vehicleformgloblakey = GlobalKey<FormState>();
  FToast? fToast;

  var maskFormatter = new MaskTextInputFormatter(
    mask: '####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  void initState() {
    super.initState();
    fToast = FToast();
    fToast?.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Add Vehicle"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: vehicleformgloblakey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                  ],
                  validator: textformfieldvalidator,
                  controller: _vehicleTypeController,
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
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  validator: numberplateValidator,
                  controller: _vehiclenumberController,
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
                  controller: _vehiclecompanyController,
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
                  controller: _vehiclemodelController,
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
                              if (vehicleformgloblakey.currentState!
                                  .validate()) {
                                SQLHelper.addIntoTableVehicle(
                                    widget.uniquevehicleid!,
                                    _vehicleTypeController.text.toString(),
                                    _vehiclenumberController.text.toString(),
                                    _vehiclemodelController.text.toString(),
                                    _vehiclecompanyController.text.toString());
                                Navigator.pop(context, 'Updated');
                                displayCustomToast();
                              }
                            },
                            child: Text("Save",
                                style: TextStyle(
                                  color: Color(0xfffefefd),
                                  fontSize: 17,
                                ))))),
              ],
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
        "Add Vehicle Successfully",
        style: TextStyle(color: Color(0xfffefefd)),
      ),
    );

    fToast?.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );
  }
}
