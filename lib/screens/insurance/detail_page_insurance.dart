import 'package:create_reminder/screens/insurance/update_reminder_insurance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../data/sql_helper.dart';
import '../../widget/appbarwidget.dart';
import '../../widget/custom_nodata.dart';
import 'add_reminder_insurance.dart';

class DetailpageInsurance extends StatefulWidget {
  final int id;

  DetailpageInsurance({required this.id});

  @override
  State<DetailpageInsurance> createState() => _DetailpageInsuranceState();
}

class _DetailpageInsuranceState extends State<DetailpageInsurance> {
  List<Map<String, dynamic>> _listofsingleinsuranceInsurance = [];
  int? singleinsuranceid, singleinsurancemembers, singleinsurancepremium;
  String? singleinsurancename, singleinsurancedate = "0000-00-00";
  // DateTime? singleinsurancedate;
  static List<Map<String, dynamic>> _listofReminder = [];

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllReminder();
    });
    getInsuranceData();
  }

  void getAllReminder() async {
    final data2 = await SQLHelper.getAllReminderByInsuranceId(widget.id);
    print('$data2');
    setState(() {
      _listofReminder = data2;
    });
  }

  void getInsuranceData() async {
    final data = await SQLHelper.getSingleInsurance(widget.id);
    // print('$data');
    setState(() {
      _listofsingleinsuranceInsurance = data;
      singleinsuranceid = _listofsingleinsuranceInsurance[0]['insurance_iid'];
      singleinsurancename =
          _listofsingleinsuranceInsurance[0]['insurance_company'];
      singleinsurancemembers =
          _listofsingleinsuranceInsurance[0]['insurance_members'];
      singleinsurancepremium =
          _listofsingleinsuranceInsurance[0]['insurance_premium'];
      singleinsurancedate =
          _listofsingleinsuranceInsurance[0]['insurance_date'];

      print(
          '$singleinsuranceid $singleinsurancename  $singleinsurancemembers  $singleinsurancepremium  $singleinsurancedate');

      // print(_listofsingleinsuranceInsurance);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("$singleinsurancename"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          Flexible(
            child: _listofReminder.length == 0
                ? CustomNoData(
                    iconaddress: 'assets/json/noreminderlist.json',
                    maintext: 'No Reminders right now!',
                    description:
                        "When you add Reminder for vehicle \nyou'll see them here",
                  )
                : ListView.builder(
                    itemCount: _listofReminder.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                        '${_listofReminder[index]['reminder_iname']}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.schedule_rounded,
                                          size: 18,
                                          color: Colors.blueAccent,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            '${_listofReminder[index]['reminder_itime']} on ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15)),
                                        Text(
                                            '${_listofReminder[index]['reminder_idate']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.replay_rounded,
                                          size: 18,
                                          color: Colors.blueAccent,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            '${_listofReminder[index]['reminder_irepeat']}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      width: double.infinity,
                                      child: Divider(
                                        color: Colors.black,
                                      )),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _navigatetoUpdate(
                                                  context,
                                                  _listofReminder[index]
                                                      ['reminder_iid']);
                                            },
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.5,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.edit_rounded,
                                                      size: 18,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xfff007dfe)),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _showreminderDialog(index);
                                              // _showDialog(index);
                                            },
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.4,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.delete_rounded,
                                                      size: 18,
                                                      color: Color(0xffffc0303),
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text("Remove",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffffc0303))),
                                                  ],
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
          ),
        ]),
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight * 0.95,
            child: FloatingActionButton.extended(
                backgroundColor: Color(0xfff007dfe),
                onPressed: () {
                  _navigateforReminder(context, singleinsuranceid);
                },
                icon: Icon(
                  Icons.add,
                  color: Color(0xfffefefd),
                ),
                label: Text(
                  'Add Reminder',
                  style: TextStyle(color: Color(0xfffefefd)),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> _navigatetoUpdate(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateReminderInsurance(
                id: index,
              )),
    );
    if (!mounted) return;

    getAllReminder();
    // getAllVehicle();
  }

  Future<void> _navigateforReminder(BuildContext context, var index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddReminderInsurance(id: index)),
    );
    if (!mounted) return;

    getAllReminder();
  }

  void _showreminderDialog(int index) {
    showDialog(
        context: this.context,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: new Text("Delete Reminder"),
            content: new Text("Do you want to Delete Reminder?"),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(00, 00, 08, 08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        child: new Text("Close"),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () async {
                        SQLHelper.deleteReminderInsurance(
                            _listofReminder[index]['reminder_iid']);
                        getAllReminder();
                        // getAllVehicle();
                        Navigator.of(context).pop();
                        await FlutterLocalNotificationsPlugin().cancel(
                            int.parse(
                                _listofReminder[index]['reminder_itimestamp']));
                        print(_listofReminder[index]['reminder_itimestamp']);
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color(0xffffc0303),
                          ),
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: new Text(
                              "Delete",
                              style: TextStyle(
                                  color: Color(0xffffc0303),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                  ],
                ),
              ),
            ],
          );
        }));
  }
}
