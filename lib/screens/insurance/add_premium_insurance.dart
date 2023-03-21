import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import '../../data/sql_helper.dart';
import 'package:intl/src/intl/date_format.dart';
import '../../utils/validator.dart';
import '../../widget/appbarwidget.dart';
import '../../widget/last_insurance_date.dart';
import '../../widget/next_premium_date.dart';

class PremiumInsurance extends StatefulWidget {
  //get insurance id from insurance list
  int? uniqueinsuranceid;
  PremiumInsurance({this.uniqueinsuranceid});

  @override
  State<PremiumInsurance> createState() => _PremiumInsuranceState();
}

class _PremiumInsuranceState extends State<PremiumInsurance> {
  //controllers to hold user values
  final _setCompanyNameController = TextEditingController();
  final _setMembersController = TextEditingController();
  final _setdateController = TextEditingController();
  final _setInsurancePremiumController = TextEditingController();
  final _setInsuranceSumController = TextEditingController();
  final _setInsuranceTermController = TextEditingController();
  GlobalKey<FormState> AddInsuranceformgloblakey = GlobalKey<FormState>();
  int? useridforinsurance;
  FToast? fToast;

  DateTime dateTime = DateTime.now();
  bool valuefirst = false;
  int? add_insurance_id;
  bool calendarcheck = false;

  //drop down values for insurance type
  String dropdownvalue = 'Life Insurance';
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
  void initState() {
    super.initState();
    print('user id:');
    print(widget.uniqueinsuranceid);
    useridforinsurance = widget.uniqueinsuranceid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Add Insurance"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: AddInsuranceformgloblakey,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: textformfieldvalidator,
                  controller: _setCompanyNameController,
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
                      value: dropdownvalue,
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
                      onChanged: (String? newValue) {
                        setState(() {
                          print("DropDown");
                          dropdownvalue = newValue!;
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp("^(0?[1-9]|[1-9][0-9])\$")),
                  ],
                  controller: _setMembersController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                  controller: _setdateController,
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
                        _setdateController.text = formattedDate;
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
                  controller: _setInsuranceTermController,
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
                    FilteringTextInputFormatter.allow(RegExp("^[0-9]{0,9}\$")),
                  ],
                  controller: _setInsuranceSumController,
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
                    FilteringTextInputFormatter.allow(RegExp("^[0-9]{0,7}\$")),
                  ],
                  controller: _setInsurancePremiumController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Premium Amount',
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
                              if (AddInsuranceformgloblakey.currentState!
                                  .validate()) {
                                SQLHelper.addIntoTableInsurance(
                                  useridforinsurance!,
                                  _setCompanyNameController.text.toString(),
                                  dropdownvalue,
                                  _setMembersController.text.toString(),
                                  _setdateController.text.toString(),
                                  _setInsurancePremiumController.text
                                      .toString(),
                                  _setInsuranceSumController.text.toString(),
                                  _setInsuranceTermController.text.toString(),
                                );
                                if (calendarcheck) {
                                  try {
                                    Add2Calendar.addEvent2Cal(Event(
                                        title:
                                            'Insurance ${_setCompanyNameController.text}',
                                        startDate: DateTime.parse(
                                            NextPremiumDate(
                                                _setdateController.text)),
                                        endDate: DateTime.parse(NextPremiumDate(
                                            _setdateController.text)),
                                        allDay: true,
                                        androidParams: AndroidParams(
                                          emailInvites: [],
                                        ),
                                        recurrence: Recurrence(
                                            frequency: Frequency.yearly,
                                            endDate: DateTime.parse(
                                                LastInsuranceDate(
                                                    _setdateController.text,
                                                    int.parse(
                                                        _setInsuranceTermController
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
                            child: Text("Save",
                                style: TextStyle(
                                  color: Color(0xfffefefd),
                                  fontSize: 15,
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
        "Add Insurance Successfully",
        style: TextStyle(color: Colors.white),
      ),
    );

    fToast?.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );
  }
}
