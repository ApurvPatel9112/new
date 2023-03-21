import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../data/sql_helper.dart';
import '../../services/notification_service.dart';
import '../../widget/appbarwidget.dart';

class UpdateReminderInsurance extends StatefulWidget {
  //reminder id from detail page insurance
  int id;
  UpdateReminderInsurance({required this.id});

  @override
  State<UpdateReminderInsurance> createState() =>
      _UpdateReminderInsuranceState();
}

class _UpdateReminderInsuranceState extends State<UpdateReminderInsurance> {
  //controller to hold value by user
  final _updatedsetdateController = TextEditingController();
  final _updatedsettimeController = TextEditingController();
  final _updatedreminderNameController = TextEditingController();
  GlobalKey<FormState> remindreformgloblakey = GlobalKey<FormState>();
  DateTime? _dateTime;
  FToast? fToast;

  String updateddropdownvalue = 'Does not repeat'; //By default dropdownvalue

  List<Map<String, dynamic>> _getreminderdetaillist = [];

  int? updatedreminderid, updatedremindervid;

  void updateID(int rid, int rvid) {
    updatedreminderid = rid;
    updatedremindervid = rvid;
  }

  // List of items in our dropdown menu
  var items = [
    'Does not repeat',
    'Every day',
    'Every week',
    'Every month',
    'Every year',
  ];

  void initState() {
    super.initState();
    fToast = FToast();
    fToast?.init(context);
    _updatedsetdateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    _updatedsettimeController.text =
        DateFormat('HH:mm:ss').format(DateTime.now());
    getSingleReminderData();
  }

  void getSingleReminderData() async {
    final data = await SQLHelper.getSingleReminderInsurance(widget.id);
    print('$data');
    setState(() {
      _getreminderdetaillist = data;
      String updaterid = _getreminderdetaillist[0]['reminder_iid'].toString();
      String updatedremindervehicleid =
          _getreminderdetaillist[0]['reminder_insurance_id'].toString();
      String updatedrtext =
          _getreminderdetaillist[0]['reminder_iname'].toString();
      String updatedrtdate =
          _getreminderdetaillist[0]['reminder_idate'].toString();
      String updatedrtime =
          _getreminderdetaillist[0]['reminder_itime'].toString();
      String updatedrrepeat =
          _getreminderdetaillist[0]['reminder_irepeat'].toString();

      final int updatedridinint = int.parse(updaterid);
      final int updatedremindervehicleidinint =
          int.parse(updatedremindervehicleid);
      updateID(updatedridinint, updatedremindervehicleidinint);

      _updatedreminderNameController.text = updatedrtext;
      _updatedsetdateController.text = updatedrtdate;
      _updatedsettimeController.text = updatedrtime;
      updateddropdownvalue = updatedrrepeat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Update Reminder"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: remindreformgloblakey,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: textformfieldvalidator,
                controller: _updatedreminderNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Remind me to',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'Remind me to i.e. Premium payment',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _updatedsetdateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        labelText: "Set Date",
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(pickedDate);
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(formattedDate);
                          setState(() {
                            _updatedsetdateController.text = formattedDate;
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                        validator: timevalidator,
                        controller: _updatedsettimeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          labelText: "Set Time",
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if (pickedTime != null) {
                            print(pickedTime.format(context));
                            DateTime parsedTime = DateFormat.jm()
                                .parse(pickedTime.format(context).toString());

                            print(parsedTime);
                            String formattedTime =
                                DateFormat('HH:mm:ss').format(parsedTime);
                            print(formattedTime);
                            _updatedsettimeController.text = formattedTime;
                          } else {
                            print("Time is not selected");
                          }
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xfff007dfe),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: TextButton(
                        onPressed: () {
                          if (remindreformgloblakey.currentState!.validate()) {
                            SQLHelper.updateReminderInsurance(
                                updatedreminderid!,
                                updatedremindervid!,
                                _updatedreminderNameController.text,
                                _updatedsetdateController.text,
                                _updatedsettimeController.text,
                                updateddropdownvalue);
                            Navigator.pop(context, 'updated');

                            String dateTimeString =
                                '${_updatedsetdateController.text} ${_updatedsettimeController.text}';
                            _dateTime = DateFormat('yyyy-MM-dd HH:mm')
                                .parse(dateTimeString);
                            String formattedDateTime =
                                DateFormat('yyyy-MM-dd HH:mm')
                                    .format(_dateTime!);

                            debugPrint(
                                'Notification Scheduled for ${_updatedsetdateController.text} ${_updatedsettimeController.text}');
                            if (updateddropdownvalue == 'Does not repeat') {
                              notificationService().scheduleNotification(
                                title: '${_updatedreminderNameController.text}',
                                body:
                                    '${_updatedsetdateController.text} ${_updatedsettimeController.text}',
                                payLoad: "ins ${updatedremindervid}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Updated reminder for once');
                            } else if (updateddropdownvalue == 'Every day') {
                              notificationService().showNotificationEveryDay(
                                title: '${_updatedreminderNameController.text}',
                                body:
                                    '${_updatedsetdateController.text} ${_updatedsettimeController.text}',
                                payLoad: "ins ${updatedremindervid}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Updated reminder for day');
                            } else if (updateddropdownvalue == 'Every week') {
                              notificationService().showNotificationEveryWeek(
                                title: '${_updatedreminderNameController.text}',
                                body:
                                    '${_updatedsetdateController.text} ${_updatedsettimeController.text}',
                                payLoad: "ins ${updatedremindervid}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Updated reminder for week');
                            } else if (updateddropdownvalue == 'Every month') {
                              notificationService().showNotificationEveryMonth(
                                title: '${_updatedreminderNameController.text}',
                                body:
                                    '${_updatedsetdateController.text} ${_updatedsettimeController.text}',
                                payLoad: "ins ${updatedremindervid}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Updated reminder for month');
                            } else if (updateddropdownvalue == 'Every year') {
                              notificationService().showNotificationEveryYear(
                                title: '${_updatedreminderNameController.text}',
                                body:
                                    '${_updatedsetdateController.text} ${_updatedsettimeController.text}',
                                payLoad: "ins ${updatedremindervid}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Updated reminder for year');
                            }
                            displayCustomToast();
                          }
                        },
                        child: Text("Update",
                            style: TextStyle(
                              color: Color(0xfffefefd),
                              fontSize: 13,
                            )))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? textformfieldvalidator(String? value) {
    if (value!.isEmpty) {
      return 'Please this field must be filled';
    }
    return null;
  }

  displayCustomToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: const Text(
        "Update Schedule Notification",
        style: TextStyle(color: Colors.white),
      ),
    );

    fToast?.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );
  }

  String? timevalidator(String? time) {
    String dateTimeString =
        '${_updatedsetdateController.text} ${_updatedsettimeController.text}';
    DateTime _dateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeString);
    if (_dateTime.isBefore(DateTime.now())) {
      return "Enter valid time";
    }
    return null;
  }
}
