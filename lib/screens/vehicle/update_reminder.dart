import 'package:create_reminder/services/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../data/sql_helper.dart';
import '../../widget/appbarwidget.dart';

class UpdateReminder extends StatefulWidget {
  int id;

  UpdateReminder({required this.id});

  @override
  State<UpdateReminder> createState() => _UpdateReminderState();
}

class _UpdateReminderState extends State<UpdateReminder> {
  TextEditingController _updatedsetdateController = TextEditingController();
  TextEditingController _updatedsettimeController = TextEditingController();
  TextEditingController _updatedreminderNameController =
      TextEditingController();
  DateTime? _dateTime;
  FToast? fToast;

  String updateddropdownvalue = 'Does not repeat';

  GlobalKey<FormState> reminderformgloblakey = GlobalKey<FormState>();

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
    getSingleReminderData();
    fToast = FToast();
    fToast?.init(context);
    _updatedsetdateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    _updatedsettimeController.text =
        DateFormat('HH:mm:ss').format(DateTime.now());
  }

  void getSingleReminderData() async {
    final data = await SQLHelper.getSingleReminder(widget.id);
    print('$data');
    setState(() {
      _getreminderdetaillist = data;
      String updaterid = _getreminderdetaillist[0]['reminder_rid'].toString();
      String updatedremindervehicleid =
          _getreminderdetaillist[0]['reminder_vehicle_id'].toString();
      String updatedrtext =
          _getreminderdetaillist[0]['reminder_rname'].toString();
      String updatedrtdate =
          _getreminderdetaillist[0]['reminder_rdate'].toString();
      String updatedrtime =
          _getreminderdetaillist[0]['reminder_rtime'].toString();
      String updatedrrepeat =
          _getreminderdetaillist[0]['reminder_rrepeat'].toString();

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
          key: reminderformgloblakey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                ],
                validator: textformfieldvalidator,
                controller: _updatedreminderNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Remind me to',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'Remind me to',
                ),
              ),
              SizedBox(
                height: 17,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: textformfieldvalidator,
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
                    width: 17,
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
                height: 17,
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
                height: 17,
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
                          if (reminderformgloblakey.currentState!.validate()) {
                            SQLHelper.updateReminder(
                                updatedreminderid!,
                                updatedremindervid!,
                                _updatedreminderNameController.text,
                                _updatedsetdateController.text,
                                _updatedsettimeController.text,
                                updateddropdownvalue);
                            Navigator.pop(context, 'updated');

                            String dateTimeString =
                                '${_updatedsetdateController.text} ${_updatedsettimeController.text}';
                            _dateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                                .parse(dateTimeString);
                            String formattedDateTime =
                                DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(_dateTime!);
                            print("-----------k$formattedDateTime");
                            print("----------@@@@$_dateTime");

                            DateTime now = DateTime.now();
                            int timestamp = now.millisecondsSinceEpoch ~/ 1000;
                            print("timestamp: $timestamp");

                            debugPrint(
                                'Notification Scheduled for ${_updatedsetdateController.text} ${_updatedsettimeController.text}');
                            if (updateddropdownvalue == 'Does not repeat') {
                              notificationService().scheduleNotification(
                                id: timestamp,
                                title: '${_updatedreminderNameController.text}',
                                body:
                                    '${_updatedsetdateController.text} ${_updatedsettimeController.text}',
                                payLoad: "veh ${updatedremindervid}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Updated reminder for once');
                            } else if (updateddropdownvalue == 'Every day') {
                              notificationService().showNotificationEveryDay(
                                title: '${_updatedreminderNameController.text}',
                                body:
                                    '${_updatedsetdateController.text} ${_updatedsettimeController.text}',
                                payLoad: "veh ${updatedremindervid}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Updated reminder for day');
                            } else if (updateddropdownvalue == 'Every week') {
                              notificationService().showNotificationEveryWeek(
                                title: '${_updatedreminderNameController.text}',
                                body:
                                    '${_updatedsetdateController.text} ${_updatedsettimeController.text}',
                                payLoad: "veh ${updatedremindervid}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Updated reminder for week');
                            } else if (updateddropdownvalue == 'Every month') {
                              notificationService().showNotificationEveryMonth(
                                title: '${_updatedreminderNameController.text}',
                                body:
                                    '${_updatedsetdateController.text} ${_updatedsettimeController.text}',
                                payLoad: "veh ${updatedremindervid}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Updated reminder for month');
                            } else if (updateddropdownvalue == 'Every year') {
                              notificationService().showNotificationEveryYear(
                                title: '${_updatedreminderNameController.text}',
                                body:
                                    '${_updatedsetdateController.text} ${_updatedsettimeController.text}',
                                payLoad: "veh ${updatedremindervid}",
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
                              fontSize: 17,
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
        color: Colors.green[600],
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
