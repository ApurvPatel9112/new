import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../data/sql_helper.dart';
import '../../utils/validator.dart';
import '../../widget/appbarwidget.dart';
import '../../widget/last_insurance_date.dart';
import '../../widget/next_premium_date.dart';
import 'add_premium_insurance.dart';

class UpdateInsurance extends StatefulWidget {
  //insurance id from insurance list
  int id;
  UpdateInsurance({required this.id});

  @override
  State<UpdateInsurance> createState() => _UpdateInsuranceState();
}

class _UpdateInsuranceState extends State<UpdateInsurance> {
  //controller to hold value from user
  final _UpdateInsuranceCompanyController = TextEditingController();
  final _UpdateInsuranceMembersController = TextEditingController();
  final _UpdateInsuranceDateController = TextEditingController();
  final _UpdateInsurancePremiumController = TextEditingController();
  final _UpdateInsuranceSumController = TextEditingController();
  final _UpdateInsuranceTermController = TextEditingController();
  GlobalKey<FormState> UpdateInsuranceformgloblakey = GlobalKey<FormState>();
  FToast? fToast;

  DateTime dateTime = DateTime.now();

  //to check if user has selected to add in calendar
  bool calendarcheck = false;

  List<Map<String, dynamic>> _getInsurancedetaillist = [];
  int? updatedinsuranceid;

  void updateID(int vid) {
    updatedinsuranceid = vid;
  }

  List<String> stringList = [];

  void initState() {
    super.initState();
    getSingleInsuranceData();
    // loadPrevoiusData(widget.id);
    print(_getInsurancedetaillist.length);
  }

  void getSingleInsuranceData() async {
    final data = await SQLHelper.getSingleInsurance(widget.id);
    print('$data');
    setState(() {
      _getInsurancedetaillist = data;
      String updatedvid =
          _getInsurancedetaillist[0]['insurance_iid'].toString();
      String updatedvcompany =
          _getInsurancedetaillist[0]['insurance_company'].toString();
      String updatedvmembers =
          _getInsurancedetaillist[0]['insurance_members'].toString();
      String updatedvdate =
          _getInsurancedetaillist[0]['insurance_date'].toString();
      String updatedvpremium =
          _getInsurancedetaillist[0]['insurance_premium'].toString();
      String updatedvsum =
          _getInsurancedetaillist[0]['insurance_sum'].toString();
      String updatedvterm =
          _getInsurancedetaillist[0]['insurance_term'].toString();
      print(
          '$updatedvcompany $updatedvmembers $updatedvdate $updatedvpremium $updatedvsum $updatedvterm');
      print(updatedvid);
      final int updatedvidinint = int.parse(updatedvid);
      updateID(updatedvidinint);
      _UpdateInsuranceCompanyController.text = updatedvcompany;
      _UpdateInsuranceMembersController.text = updatedvmembers;
      _UpdateInsuranceDateController.text = updatedvdate;
      _UpdateInsurancePremiumController.text = updatedvpremium;
      _UpdateInsuranceSumController.text = updatedvsum;
      _UpdateInsuranceTermController.text = updatedvterm;
    });
  }

  //drop down value for insurance type
  String updateddropdownvalue = 'Life Insurance';
  var items = [
    'Life Insurance',
    'Motor Insurance',
    'Health Insurance',
    'Travel Insurance',
    'Property Insurance',
    'Mobile Insurance',
    'Cycle Insurance',
    'Bite-Size Insurance'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar("Update Insurance"),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key: UpdateInsuranceformgloblakey,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: textformfieldvalidator,
                    controller: _UpdateInsuranceCompanyController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Insurance Company Name',
                      hintText: 'Example Lic,Bajaj etc',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 60,
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff949291),
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        underline: SizedBox(),
                        value: updateddropdownvalue,
                        dropdownColor: Color(0xfffefefd),
                        iconDisabledColor: Color(0xff000000),
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              style: TextStyle(
                                color: Color(0xff000000),
                              ),
                            ),
                          );
                        }).toList(),
                        // onChanged: (String? value) {  },
                        onChanged: (String? newValue) {
                          setState(() {
                            print("DropDown");
                            updateddropdownvalue = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: membersvalidator,
                    controller: _UpdateInsuranceMembersController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("^(0?[1-9]|[1-9][0-9])\$")),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Members',
                      hintText: 'Enter The No. Of Members(1-20)',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: datevalidator,
                    controller: _UpdateInsuranceDateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: "Insurance Start Date",
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        print(pickedDate);
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate);
                        setState(() {
                          dateTime = pickedDate;
                          _UpdateInsuranceDateController.text = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: durationvalidator,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("^(0?[1-9]|[1-9][0-9])\$")),
                    ],
                    controller: _UpdateInsuranceTermController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Insurance Term',
                      hintText: 'Enter Insurance Term(1-50 years)',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: textformfieldvalidator,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("^[0-9]{0,9}\$")),
                    ],
                    controller: _UpdateInsuranceSumController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sum Insured',
                      hintText: 'Enter Total Insured Amount',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: textformfieldvalidator,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("^[0-9]{0,7}\$")),
                    ],
                    controller: _UpdateInsurancePremiumController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Insurance Premium',
                      hintText: 'Enter Premium Amount',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Text(
                        "Want to add event in google calendar? ",
                        style: TextStyle(fontSize: 15),
                      ),
                      Checkbox(
                          value: calendarcheck,
                          onChanged: ((value) {
                            setState(() {
                              this.calendarcheck = value!;
                            });
                            print(calendarcheck);
                          })),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xfff007dfe)),
                          child: TextButton(
                              onPressed: () {
                                if (UpdateInsuranceformgloblakey.currentState!
                                    .validate()) {
                                  SQLHelper.updateInsurance(
                                      updatedinsuranceid!,
                                      1,
                                      _UpdateInsuranceCompanyController.text,
                                      updateddropdownvalue,
                                      _UpdateInsuranceMembersController.text,
                                      _UpdateInsuranceDateController.text,
                                      _UpdateInsurancePremiumController.text,
                                      _UpdateInsuranceSumController.text,
                                      _UpdateInsuranceTermController.text);
                                  if (calendarcheck) {
                                    try {
                                      Add2Calendar.addEvent2Cal(Event(
                                          title:
                                              'Insurance ${_UpdateInsuranceCompanyController.text}',
                                          startDate: DateTime.parse(
                                              NextPremiumDate(
                                                  _UpdateInsuranceDateController
                                                      .text)),
                                          endDate: DateTime
                                              .parse(NextPremiumDate(
                                                  _UpdateInsuranceDateController
                                                      .text)),
                                          allDay: true,
                                          androidParams: AndroidParams(
                                            emailInvites: [],
                                          ),
                                          recurrence: Recurrence(
                                              frequency: Frequency.yearly,
                                              endDate: DateTime.parse(LastInsuranceDate(
                                                  _UpdateInsuranceDateController
                                                      .text,
                                                  int.parse(
                                                      _UpdateInsuranceTermController
                                                          .text))))));
                                    } catch (e) {
                                      print(e);
                                      Fluttertoast.showToast(
                                          msg:
                                              'Please Enter all the details first!',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.blue,
                                          textColor: Colors.white);
                                    }
                                  }
                                  Navigator.pop(context, 'Updated');
                                  displayCustomToast();
                                }
                              },
                              child: Text("Update",
                                  style: TextStyle(
                                    color: Color(0xfffefefd),
                                    fontSize: 15,
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
        color: Colors.greenAccent,
      ),
      child: const Text(
        "Update Insurance Successfully",
        style: TextStyle(color: Colors.white),
      ),
    );

    fToast?.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );
  }
}
