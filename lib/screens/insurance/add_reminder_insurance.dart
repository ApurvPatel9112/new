import 'package:create_reminder/data/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../services/notification_service.dart';
import '../../widget/appbarwidget.dart';
import 'detail_page_insurance.dart';

DateTime scheduleTime = DateTime.now();

class AddReminderInsurance extends StatefulWidget {
  final int id;
  AddReminderInsurance({required this.id});

  @override
  State<AddReminderInsurance> createState() => _AddReminderInsuranceState();
}

class _AddReminderInsuranceState extends State<AddReminderInsurance> {
  TextEditingController _setdateController = TextEditingController();
  TextEditingController _settimeController = TextEditingController();
  TextEditingController _reminderNameController = TextEditingController();
  GlobalKey<FormState> remindreformgloblakey = GlobalKey<FormState>();
  String dropdownvalue = 'Does not repeat';
  DateTime? _dateTime;
  String? insid;
  FToast? fToast;

  @override
  void initState() {
    super.initState();
    print(widget.id);
    fToast = FToast();
    fToast?.init(context);
    _setdateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _settimeController.text = DateFormat('HH:mm:ss').format(DateTime.now());
    _setdateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _settimeController.text = DateFormat('HH:mm:ss').format(DateTime.now());
    insid = "ins ${widget.id}";

    // listenToNotification();
  }

  // List of items in our dropdown menu
  var items = [
    'Does not repeat',
    'Every day',
    'Every week',
    'Every month',
    'Every year',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Add Reminder"),
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                ],
                validator: textformfieldvalidator,
                controller: _reminderNameController,
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
                      controller: _setdateController,
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
                            lastDate: DateTime(2050));

                        if (pickedDate != null) {
                          print(pickedDate);
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(formattedDate);
                          setState(() {
                            _setdateController.text = formattedDate;
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
                        controller: _settimeController,
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
                            _settimeController.text = formattedTime;
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
                        onPressed: () async {
                          if (remindreformgloblakey.currentState!.validate()) {
                            String dateTimeString =
                                '${_setdateController.text} ${_settimeController.text}';
                            _dateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                                .parse(dateTimeString);
                            String formattedDateTime =
                                DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                                    .format(_dateTime!);
                            DateTime now = DateTime.now();
                            int timestamp = now.millisecondsSinceEpoch ~/ 1000;
                            print("timestamp: $timestamp");
                            SQLHelper.addIntoTableReminderInsurance(
                              widget.id,
                              _reminderNameController.text.toString(),
                              _setdateController.text.toString(),
                              _settimeController.text.toString(),
                              dropdownvalue,
                              timestamp.toString(),
                            );
                            Navigator.pop(context, 'updated');

                            debugPrint(
                                'Notification Scheduled for ${_setdateController.text} ${_settimeController.text}');

                            if (dropdownvalue == 'Does not repeat') {
                              notificationService().scheduleNotification(
                                id: timestamp,
                                title: '${_reminderNameController.text}',
                                body:
                                    '${_setdateController.text} ${_settimeController.text}',
                                payLoad: "ins ${widget.id}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Reminder for once');
                            } else if (dropdownvalue == 'Every day') {
                              notificationService().showNotificationEveryDay(
                                id: timestamp,
                                title: '${_reminderNameController.text}',
                                body:
                                    '${_setdateController.text} ${_settimeController.text}',
                                payLoad: "ins ${widget.id}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Reminder for day');
                            } else if (dropdownvalue == 'Every week') {
                              notificationService().showNotificationEveryWeek(
                                id: timestamp,
                                title: '${_reminderNameController.text}',
                                body:
                                    '${_setdateController.text} ${_settimeController.text}',
                                payLoad: "ins ${widget.id}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Reminder for week');
                            } else if (dropdownvalue == 'Every month') {
                              notificationService().showNotificationEveryMonth(
                                id: timestamp,
                                title: '${_reminderNameController.text}',
                                body:
                                    '${_setdateController.text} ${_settimeController.text}',
                                payLoad: "ins ${widget.id}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Reminder for month');
                            } else if (dropdownvalue == 'Every year') {
                              notificationService().showNotificationEveryYear(
                                id: timestamp,
                                title: '${_reminderNameController.text}',
                                body:
                                    '${_setdateController.text} ${_settimeController.text}',
                                payLoad: "ins ${widget.id}",
                                scheduledNotificationDateTime: _dateTime!,
                              );
                              print('Reminder for year');
                            }
                            displayCustomToast();
                          }
                        },
                        child: Text("Save",
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

  void onNotificationListener(String? payLoad) {
    if (payLoad != null && payLoad.isNotEmpty) {
      print('payload $payLoad');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailpageInsurance(id: widget.id)));
    }
  }

  displayCustomToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.green[600],
      ),
      child: const Text(
        "Schedule Notification",
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
        '${_setdateController.text} ${_settimeController.text}';
    DateTime _dateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeString);
    if (_dateTime.isBefore(DateTime.now())) {
      return "Enter valid time";
    }
    return null;
  }
}
